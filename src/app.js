// bootstrap
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import '../node_modules/bootstrap/dist/js/bootstrap.min.js';

// semantic-ui-css
import '../node_modules/semantic-ui-css/semantic.min';
import '../node_modules/semantic-ui-css/semantic.min.css';
import './css/semantic-ui-custom.css';

import '../node_modules/imagesloaded/imagesloaded.pkgd.js';
import '../node_modules/infinite-scroll/dist/infinite-scroll.pkgd.js';
import '../node_modules/jquery-bridget/jquery-bridget.js';

// jquery masonry
import '../node_modules/jquery-bridget/jquery-bridget.js';
import '../node_modules/masonry-layout/dist/masonry.pkgd.js';
import '../node_modules/imagesloaded/imagesloaded.pkgd.min.js';

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

    // アニメーション初期化関数
    function initializeAnimations() {
        document.querySelectorAll('.masonry').forEach(container => {
            console.log('Masonry container found, initializing animations');
            
            // 実際のMasonryインスタンスを作成
            const msnry = new Masonry(container, {
                itemSelector: '.masonry-item',
                columnWidth: '.masonry-item',
                percentPosition: true,
                gutter: 10
            });
            
            // カードアニメーションの初期化
            const items = container.querySelectorAll('.masonry-item');
            console.log(`Found ${items.length} masonry items`);
            
            // 既存のカードにアニメーションを適用
            items.forEach((item, index) => {
                console.log(`Setting up animation for item ${index}:`, item);
                console.log(`Item classes before:`, item.className);
                
                // 初期状態を設定
                item.classList.add('animate-in');
                console.log(`Item classes after adding animate-in:`, item.className);
                
                // 強制的にスタイルを適用
                item.style.opacity = '0';
                item.style.transform = 'translateY(30px) scale(0.95)';
                
                // スタッガード（時差）アニメーション
                setTimeout(() => {
                    console.log(`Starting animation for item ${index}`);
                    item.classList.add('show');
                    console.log(`Item classes after adding show:`, item.className);
                    
                    // CSSが効かない場合は直接スタイルを適用
                    item.style.transition = 'opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1), transform 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0) scale(1)';
                }, index * 100 + 200); // 200ms初期遅延 + 100msずつ遅延
            });
            
            // 画像読み込み後にレイアウト再計算
            imagesLoaded(container, () => {
              msnry.layout();
              console.log('Masonry layout initialized after images loaded');
            });
            
            // レスポンシブ変更時のスムーズなアニメーション
            let resizeTimeout;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimeout);
                // レイアウト変更クラスを追加
                container.querySelectorAll('.masonry-item').forEach(item => {
                    item.classList.add('layout-changing');
                });
                
                resizeTimeout = setTimeout(() => {
                    msnry.layout();
                    // レイアウト変更クラスを削除
                    container.querySelectorAll('.masonry-item').forEach(item => {
                        item.classList.remove('layout-changing');
                    });
                    console.log('Layout updated after resize');
                }, 300);
            });

            // Infinite Scrollが存在する場合のみ初期化
            if (container.querySelector('#page-nav')) {
                var infScroll = new InfiniteScroll( container, {
                    // onInit
                    //   2ページ目以降を infinite-scrollで追加する際にmagnefic-popupの初期化を行う
                    //
                    //   refs
                    //     https://infinite-scroll.com/options.html#oninit
                    //     https://stackoverflow.com/questions/46348603/infinite-scroll-with-magnific-popup-callback
                    onInit: function() {
                        this.on( 'append', function( response, path, items ) {
                            console.log('Infinite Scroll appended.')
                            console.log('magnefic-popup initialization.')
                            
                            console.log('New items added:', items);
                            
                            // 新しく追加されたアイテムにアニメーションを適用
                            $(items).each(function(index, item) {
                                console.log(`Setting up animation for new item ${index}`);
                                $(item).addClass('animate-in');
                                
                                // 強制的に初期スタイルを適用
                                item.style.opacity = '0';
                                item.style.transform = 'translateY(30px) scale(0.95)';
                                
                                // スタッガードアニメーション
                                setTimeout(() => {
                                    console.log(`Animating new item ${index}`);
                                    $(item).addClass('show');
                                    
                                    // 直接スタイルでアニメーション実行
                                    item.style.transition = 'opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1), transform 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                                    item.style.opacity = '1';
                                    item.style.transform = 'translateY(0) scale(1)';
                                }, index * 150); // 150msずつ遅延
                            });
                            
                            // 新しく追加されたアイテムにmagnific-popupを適用
                            $(items).find('.magnific-popup').magnificPopup({
                                type: 'iframe',
                                mainClass: 'mfp-fade',
                                removalDelay: 200,
                                preloader: false
                            });
                            
                            // 画像読み込み後にレイアウト再計算
                            imagesLoaded(items, () => {
                                msnry.appended(items);
                                msnry.layout();
                                console.log('Masonry layout updated after infinite scroll');
                            });
                        });
                    },

                    // history: false
                    //   disable changing the URL by setting.
                    //   refs
                    //     https://github.com/metafizzy/infinite-scroll/issues/701#issuecomment-321832327
                    //     https://infinite-scroll.com/options.html#history
                    history         : false,
                    appendCallback  : true,
                    scrollThreshold : 300,
                    append          : '.masonry-item',
                    outlayer        : msnry,
                    navSelector     : '#page-nav',
                    nextSelector    : '#page-nav a',
                    path            : '#page-nav a',
                    itemSelector    : '.masonry-item',
                    status          : '.page-load-status'
                });
            }

            $('.page-load-status').hide();
        });
    }

    // アニメーション初期化は application.html.erb の jQuery ready で実行
    // ここではコメントアウト
    // document.addEventListener("DOMContentLoaded", initializeAnimations);
    // $(document).ready(initializeAnimations);
});

