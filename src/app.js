// bootstrap
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import '../node_modules/bootstrap/dist/js/bootstrap.min.js';

// semantic-ui-css
import '../node_modules/semantic-ui-css/semantic.min';
import '../node_modules/semantic-ui-css/semantic.min.css';
import './css/semantic-ui-custom.css';

// jquery masonry and infinite scroll
import '../node_modules/jquery-bridget/jquery-bridget.js';
import '../node_modules/masonry-layout/dist/masonry.pkgd.js';
import '../node_modules/imagesloaded/imagesloaded.pkgd.js';
import '../node_modules/infinite-scroll/dist/infinite-scroll.pkgd.js';

// jquery magnefic popup
import '../node_modules/magnific-popup/dist/magnific-popup.css';
import '../node_modules/magnific-popup/dist/jquery.magnific-popup.js';

// custom css
import './css/bootstrap.css';
import './app.css';
import './css/common.css';
import './css/entry.css';
import './css/infinitescroll_loading.css';
import './css/page_to_top.css';
import './css/members.css';

// custom scss
import './scss/footer.scss';
import './scss/entry.scss';
import './scss/artists.scss';
import './scss/crown.scss';

import './js/page_to_top.js';

// テスト用のJavaScript
import './test_simple.js';

$(function() {
    $('.magnific-popup').magnificPopup({
        type: 'iframe',
        mainClass: 'mfp-fade',
        removalDelay: 200,
        preloader: false
    });

    /////
    // Webpackでmasonryをビルドする場合のお作法
    //    https://github.com/desandro/masonry/issues/936
    //    https://masonry.desandro.com/extras.html#webpack
    // Webpackでimagesloadedをビルドする場合のお作法
    //    https://github.com/desandro/imagesloaded#webpack
    // Webpackでinfinite-scrollをビルドする場合のお作法
    //    https://infinite-scroll.com/extras.html#webpack-browserify
    /////
    var jQueryBridget = require('jquery-bridget');
    var imagesLoaded = require('imagesloaded');
    var Masonry = require('masonry-layout');
    var InfiniteScroll = require('infinite-scroll');
    jQueryBridget( 'imagesLoaded', imagesLoaded, $ );
    jQueryBridget( 'masonry', Masonry, $ );
    jQueryBridget( 'infinitescroll', InfiniteScroll, $ );
    InfiniteScroll.imagesLoaded = imagesLoaded;

    const grid = document.querySelector('.masonry');
    let isInfiniteScrollInitialized = false;
    
    function initializeInfiniteScroll() {
        if (isInfiniteScrollInitialized) {
            console.log('Infinite scroll already initialized, skipping...');
            return;
        }
        
        console.log('Initializing infinite scroll...');
        const containers = document.querySelectorAll('.masonry');
        console.log('Found masonry containers:', containers.length);
        
        if (containers.length === 0) {
            console.warn('No .masonry containers found!');
            return;
        }
        
        containers.forEach(container => {
            console.log('Processing container:', container);
            const msnry = new Masonry(container, {
                itemSelector : '.ui.card.item',
                columnWidth  : '.ui.card.item',
                percentPosition: true,
                gutter: 20
            });
            
            // グローバルにMasonryインスタンスを保存
            window.masonryInstance = msnry;
            container._masonryInstance = msnry;
            // 画像読み込み後にレイアウト再計算
            imagesLoaded(container, () => {
              msnry.layout();
              const initialHeight = container.offsetHeight;
              console.log('Images loaded, layout recalculated, initial height:', initialHeight + 'px');
              
              // コンテナの高さを強制的に設定してスクロール可能にする
              const items = container.querySelectorAll('.ui.card.item');
              if (items.length > 0) {
                  // アイテムの総高さを計算
                  let totalHeight = 0;
                  items.forEach(item => {
                      totalHeight += item.offsetHeight + 20; // gutter分も追加
                  });
                  
                  // 最小高さを設定（画面高さ + マージン）
                  const minRequiredHeight = window.innerHeight + 200;
                  const finalHeight = Math.max(totalHeight, minRequiredHeight);
                  
                  container.style.height = finalHeight + 'px';
                  console.log('Container height forced to:', finalHeight + 'px', 'to ensure scrollability');
                  
                  // 親要素の高さ制限も解除
                  const segmentContainer = document.querySelector('div.ui.raised.segment');
                  const pushableContainer = document.querySelector('div.ui.pushable > div');
                  const bodyContainer = document.querySelector('body');
                  
                  if (segmentContainer) {
                      segmentContainer.style.height = 'auto';
                      segmentContainer.style.minHeight = 'auto';
                      segmentContainer.style.overflow = 'visible';
                      console.log('Segment container height constraints removed');
                  }
                  
                  if (pushableContainer) {
                      pushableContainer.style.height = 'auto';
                      pushableContainer.style.minHeight = 'auto';
                      console.log('Pushable container height constraints removed');
                  }
                  
                  if (bodyContainer) {
                      bodyContainer.style.height = 'auto';
                      bodyContainer.style.minHeight = 'auto';
                      console.log('Body height constraints removed');
                  }
                  
                  // レイアウト再計算
                  setTimeout(() => {
                      msnry.layout();
                      
                      // 強制的にドキュメント高さを確認
                      const docHeight = document.documentElement.scrollHeight;
                      const winHeight = window.innerHeight;
                      console.log('After height fixes - Document height:', docHeight, 'Window height:', winHeight);
                      console.log('Should be scrollable now:', docHeight > winHeight);
                  }, 100);
              }
            });

            // Check for navigation elements
            const navElement = document.querySelector('#page-nav');
            const nextLink = document.querySelector('#page-nav a');
            console.log('Navigation element:', navElement);
            console.log('Next link:', nextLink);
            console.log('Next link href:', nextLink ? nextLink.href : 'Not found');

            if (!navElement || !nextLink) {
                console.warn('Navigation elements not found - infinite scroll will not work');
                return;
            }

            // Check container height and scroll position
            console.log('Container height:', container.scrollHeight);
            console.log('Container client height:', container.clientHeight);
            console.log('Window scroll Y:', window.scrollY);
            console.log('Document height:', document.documentElement.scrollHeight);

            try {
                console.log('Attempting to create InfiniteScroll instance...');
                console.log('InfiniteScroll available?', typeof InfiniteScroll !== 'undefined');
                console.log('InfiniteScroll object:', InfiniteScroll);
                var infScroll = new InfiniteScroll( container, {
                // path: function for v3.0.6+
                path: function() {
                    const nextLink = document.querySelector('#page-nav a[rel="next"]');
                    const nextUrl = nextLink ? nextLink.href : null;
                    console.log('InfiniteScroll path function called, next URL:', nextUrl);
                    return nextUrl;
                },
                // history: false
                //   disable changing the URL by setting.
                //   refs
                //     https://github.com/metafizzy/infinite-scroll/issues/701#issuecomment-321832327
                //     https://infinite-scroll.com/options.html#history
                history         : false,
                append          : '.ui.card.item',
                scrollThreshold : 400,
                itemSelector    : '.ui.card.item',
                status          : '.page-load-status',
                responseType    : 'text',
                elementScroll   : false, // windowスクロールを使用
                loadOnScroll    : true,
                checkLastPage   : 'a[rel=next]',
                debug           : true, // デバッグを有効にして詳細ログを確認
                fetchOptions: {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Cache-Control': 'no-cache'
                    }
                }
                });

                console.log('InfiniteScroll instance created, setting up event listeners...');
                isInfiniteScrollInitialized = true;
                
                // グローバルに保存してデバッグで使用できるようにする
                window.infScrollInstance = infScroll;
                
                infScroll.on( 'request', function( path ) {
                    console.log('🚀 Infinite Scroll requesting new page:', path);
                    $('.page-load-status').show();
                });
                
                infScroll.on( 'append', function( response, path, items ) {
                    console.log('🎉 Infinite Scroll appended successfully!');
                    console.log('Response length:', response ? response.length : 'no response');
                    console.log('Path:', path);
                    console.log('Items appended:', items ? items.length : 0);
                    console.log('Items details:', items);
                    
                    // 現在の総アイテム数を確認
                    const totalItems = document.querySelectorAll('.ui.card.item').length;
                    console.log('Total items after append:', totalItems);

                    // 完全なMasonry再初期化で重複表示を解決
                    if (items && items.length > 0) {
                        console.log('🔧 Complete Masonry reinitialization...');
                        
                        const $masonry = $('.masonry');
                        
                        // 画像読み込み完了後にMasonryを完全に再初期化
                        $masonry.imagesLoaded(function() {
                            console.log('Images loaded, reinitializing Masonry...');
                            
                            try {
                                // 既存のMasonryインスタンスを破棄
                                if (window.masonryInstance) {
                                    window.masonryInstance.destroy();
                                    console.log('Previous Masonry instance destroyed');
                                }
                                
                                // アイテムのスタイルを確認してからクリア
                                const allItems = container.querySelectorAll('.ui.card.item');
                                allItems.forEach(item => {
                                    // 現在のスタイルをログ出力
                                    console.log('Before clearing - Item styles:', {
                                        position: item.style.position,
                                        left: item.style.left,
                                        top: item.style.top,
                                        height: item.style.height,
                                        minHeight: item.style.minHeight,
                                        computedHeight: window.getComputedStyle(item).height
                                    });
                                    
                                    // Masonryが設定したポジション関連のスタイルをクリア（heightは保持）
                                    item.style.position = '';
                                    item.style.left = '';
                                    item.style.top = '';
                                    item.style.transform = '';
                                    
                                    // 高さ設定を確実に適用
                                    item.style.setProperty('min-height', '250px', 'important');
                                    item.style.setProperty('min-width', '150px', 'important');
                                    
                                    // .content要素の高さ制限を解除
                                    const contentElements = item.querySelectorAll('.content, .extra.content');
                                    contentElements.forEach(content => {
                                        content.style.setProperty('height', 'auto', 'important');
                                        content.style.setProperty('min-height', 'auto', 'important');
                                        console.log('Content height freed for:', content);
                                    });
                                    
                                    console.log('After clearing - Item styles:', {
                                        position: item.style.position,
                                        minHeight: item.style.minHeight,
                                        computedHeight: window.getComputedStyle(item).height
                                    });
                                });
                                console.log('Masonry positioning styles cleared and heights restored');
                                
                                // コンテナの高さをリセット
                                container.style.height = '';
                                console.log('Container height reset');
                                
                                // 新しいMasonryインスタンスを作成
                                const newMasonry = new Masonry(container, {
                                    itemSelector: '.ui.card.item',
                                    columnWidth: '.ui.card.item',
                                    percentPosition: true,
                                    gutter: 20,
                                    transitionDuration: 0, // アニメーションを無効にして即座に配置
                                    resize: true // リサイズイベントに応答
                                });
                                
                                window.masonryInstance = newMasonry;
                                container._masonryInstance = newMasonry;
                                
                                console.log('✅ New Masonry instance created with', allItems.length, 'total items');
                                
                                // CSSで動的にスタイルを強制適用
                                const styleId = 'infinite-scroll-card-fix';
                                let existingStyle = document.getElementById(styleId);
                                if (!existingStyle) {
                                    const style = document.createElement('style');
                                    style.id = styleId;
                                    style.textContent = `
                                        .masonry .ui.card.item {
                                            min-height: 250px !important;
                                            min-width: 150px !important;
                                            height: auto !important;
                                        }
                                        .masonry .ui.card.item .content {
                                            height: auto !important;
                                            min-height: auto !important;
                                            flex: 1 !important;
                                        }
                                        .masonry .ui.card.item .extra.content {
                                            height: auto !important;
                                            min-height: auto !important;
                                        }
                                        div.ui.raised.segment {
                                            height: auto !important;
                                            min-height: auto !important;
                                            overflow: visible !important;
                                        }
                                        div.ui.pushable > div {
                                            height: auto !important;
                                            min-height: auto !important;
                                        }
                                        body {
                                            height: auto !important;
                                            min-height: auto !important;
                                        }
                                    `;
                                    document.head.appendChild(style);
                                    console.log('Dynamic CSS rule added for card heights');
                                }
                                
                                // レイアウトを強制実行してコンテナ高さを更新
                                setTimeout(() => {
                                    newMasonry.layout();
                                    
                                    // Masonryのネイティブサイズ計算を使用
                                    const masonrySize = newMasonry.getSize();
                                    const calculatedHeight = masonrySize.height;
                                    console.log('Masonry calculated height:', calculatedHeight);
                                    
                                    // 最下部のアイテムを見つけてフォールバック計算
                                    let maxBottom = 0;
                                    allItems.forEach(item => {
                                        const itemTop = parseInt(item.style.top) || 0;
                                        const itemHeight = item.offsetHeight;
                                        const itemBottom = itemTop + itemHeight;
                                        maxBottom = Math.max(maxBottom, itemBottom);
                                    });
                                    
                                    // より大きい値を使用してコンテナの高さを設定
                                    const finalHeight = Math.max(calculatedHeight, maxBottom);
                                    if (finalHeight > 0) {
                                        container.style.height = finalHeight + 'px';
                                        console.log('Container height set to:', finalHeight + 'px');
                                    }
                                    
                                    // 親のsegmentコンテナの高さも更新
                                    const segmentContainer = document.querySelector('div.ui.raised.segment');
                                    if (segmentContainer) {
                                        segmentContainer.style.height = 'auto';
                                        segmentContainer.style.minHeight = 'auto';
                                        console.log('Segment container height reset to auto');
                                    }
                                    
                                    const newHeight = container.offsetHeight;
                                    console.log('Final layout applied, container height:', newHeight + 'px');
                                }, 100);
                                
                            } catch (error) {
                                console.error('❌ Error reinitializing Masonry:', error);
                            }
                        });
                    }

                    // magnific-popup再初期化
                    $('.magnific-popup').magnificPopup({
                        type: 'iframe',
                        mainClass: 'mfp-fade',
                        removalDelay: 200,
                        preloader: false
                    });
                    
                    $('.page-load-status').hide();
                });

                // 最後のページに到達した時の処理
                infScroll.on( 'last', function() {
                    console.log('Infinite Scroll reached last page.')
                    $('.page-load-status').hide();
                    $('.infinite-scroll-last').show();
                });

                // エラー時の処理
                infScroll.on( 'error', function( error, path ) {
                    console.error('❌ Infinite Scroll error!');
                    console.error('Error details:', error);
                    console.error('Path:', path);
                    console.error('Error type:', typeof error);
                    console.error('Error message:', error && error.message ? error.message : 'Unknown error');
                    $('.page-load-status').hide();
                    $('.infinite-scroll-error').show();
                });
                
                // load イベント - InfiniteScroll 3.0.6+ のメインイベント
                infScroll.on( 'load', function( response, path, responseElements ) {
                    console.log('📥 InfiniteScroll load event triggered');
                    console.log('Load response type:', typeof response);
                    console.log('Load response length:', response ? response.length : 'no response');
                    console.log('Load path:', path);
                    console.log('Response elements:', responseElements ? responseElements.length : 'no elements');
                    
                    if (response) {
                        // レスポンスからアイテムを手動で抽出してテスト
                        const tempDiv = document.createElement('div');
                        tempDiv.innerHTML = response;
                        const items = tempDiv.querySelectorAll('.ui.card.item');
                        console.log('Items found in load response:', items.length);
                        
                        if (items.length > 0) {
                            console.log('✅ Load event contains items, should trigger append');
                        } else {
                            console.warn('⚠️ Load event has no items to append');
                        }
                    }
                    
                    $('.page-load-status').hide();
                });

                // デバッグ用：スクロール位置のログ
                infScroll.on( 'scrollThreshold', function() {
                    console.log('Infinite Scroll: scroll threshold reached');
                    
                    // InfiniteScrollの内部状態をチェック
                    console.log('InfiniteScroll state:', {
                        pageIndex: infScroll.pageIndex,
                        loadCount: infScroll.loadCount,
                        isLoading: infScroll.isLoading,
                        canLoad: infScroll.canLoad
                    });
                    
                    // 次のページのURLを確認
                    const nextUrl = infScroll.getPath();
                    console.log('Next URL from getPath():', nextUrl);
                    
                    // 次ページリンクの存在確認
                    const nextLink = document.querySelector('#page-nav a[rel="next"]');
                    console.log('Next link element:', nextLink);
                    console.log('Next link href:', nextLink ? nextLink.href : 'Not found');
                    
                    // 手動でloadNextPageを実行してみる
                    if (infScroll && typeof infScroll.loadNextPage === 'function') {
                        if (infScroll.canLoad !== false) {
                            console.log('🔄 Manually triggering loadNextPage from scrollThreshold...');
                            infScroll.loadNextPage();
                        } else {
                            console.warn('⚠️ InfiniteScroll canLoad is false, cannot load next page');
                        }
                    } else {
                        console.error('❌ loadNextPage not available on scrollThreshold');
                    }
                });
                
                // 手動スクロール監視（デバッグ用）
                let scrollTimeout;
                window.addEventListener('scroll', function() {
                    clearTimeout(scrollTimeout);
                    scrollTimeout = setTimeout(function() {
                        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                        const windowHeight = window.innerHeight;
                        const documentHeight = document.documentElement.scrollHeight;
                        const scrollPercent = (scrollTop / (documentHeight - windowHeight)) * 100;
                        
                        if (scrollPercent > 70) { // 70%スクロールしたらログ
                            console.log('Scroll debug:', {
                                scrollTop: scrollTop,
                                windowHeight: windowHeight,
                                documentHeight: documentHeight,
                                scrollPercent: scrollPercent.toFixed(2) + '%',
                                threshold: 1000
                            });
                        }
                    }, 100);
                });
                
                console.log('Event listeners attached successfully');

                // Test if infinite scroll is working by checking internal state
                setTimeout(function() {
                    console.log('=== InfiniteScroll Debug Info ===');
                    console.log('InfiniteScroll instance:', infScroll);
                    console.log('Is loading?:', infScroll.isLoading);
                    console.log('Page index:', infScroll.pageIndex);
                    console.log('Options:', infScroll.options);
                    
                    // Check if page is scrollable
                    const docHeight = document.documentElement.scrollHeight;
                    const winHeight = window.innerHeight;
                    const isScrollable = docHeight > winHeight;
                    console.log('Document height:', docHeight);
                    console.log('Window height:', winHeight);
                    console.log('Is page scrollable?:', isScrollable);
                    
                    if (!isScrollable) {
                        console.warn('⚠️  Page is not scrollable initially. Waiting for content to load and make page scrollable...');
                        console.log('💡 Once page becomes scrollable, infinite scroll will work automatically');
                        
                        // ページが短い場合は、コンテンツ更新後にスクロール可能になるのを待つ
                        setTimeout(function() {
                            const updatedDocHeight = document.documentElement.scrollHeight;
                            const updatedWinHeight = window.innerHeight;
                            const isNowScrollable = updatedDocHeight > updatedWinHeight;
                            
                            console.log('Updated document height:', updatedDocHeight);
                            console.log('Updated window height:', updatedWinHeight); 
                            console.log('Is page now scrollable?:', isNowScrollable);
                            
                            if (isNowScrollable) {
                                console.log('✅ Page is now scrollable. Infinite scroll will trigger on scroll.');
                            } else {
                                console.log('⚠️ Page is still not scrollable. May need more content or manual testing.');
                            }
                        }, 3000);
                    } else {
                        console.log('✅ Page is scrollable. Infinite scroll will trigger automatically when scrolled to bottom.');
                    }
                    console.log('==============================');
                }, 1000);

                $('.page-load-status').hide(); // 初期状態では非表示
                console.log('InfiniteScroll instance created successfully');
                
            } catch (error) {
                console.error('Error creating InfiniteScroll instance:', error);
                console.error('Error stack:', error.stack);
            }
        });
    }
    
    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener("DOMContentLoaded", initializeInfiniteScroll);
    } else {
        // DOM is already loaded
        setTimeout(initializeInfiniteScroll, 100);
    }
});

