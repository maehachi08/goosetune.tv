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
import InfiniteScroll from 'infinite-scroll';

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

console.log('Starting jQuery ready function...');
$(function() {
    console.log('jQuery ready function executed!');
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
    jQueryBridget( 'imagesLoaded', imagesLoaded, $ );
    jQueryBridget( 'masonry', Masonry, $ );
    jQueryBridget( 'infinitescroll', InfiniteScroll, $ );
    InfiniteScroll.imagesLoaded = imagesLoaded;

    // 要素の存在確認
    console.log('Masonry element check:', document.querySelector('.masonry'));
    console.log('Page nav element check:', document.querySelector('#page-nav'));
    console.log('Items found:', document.querySelectorAll('.ui.card.item').length);
    
    var masonryElement = document.querySelector('.masonry');
    if (!masonryElement) {
        console.error('Masonry element not found!');
        return;
    }
    
    // 既存のMasonryスタイルをクリア
    masonryElement.style.height = '';
    masonryElement.style.position = '';
    
    // 各アイテムの位置をリセット
    const items = masonryElement.querySelectorAll('.ui.card.item');
    items.forEach(item => {
        item.style.position = '';
        item.style.left = '';
        item.style.top = '';
        item.style.transform = '';
    });
    
    console.log('🔧 Before Masonry init - items:', items.length);
    console.log('🔧 Container height before init:', masonryElement.style.height);
    
    var msnry = new Masonry( masonryElement, {
        itemSelector : '.ui.card.item',
        columnWidth  : '.ui.card.item',
        percentPosition: true,
        gutter: 12
    });
    
    console.log('🔧 After Masonry init - container height:', masonryElement.style.height);
    
    // 初期アイテムの画像読み込み完了を待ってレイアウトを実行
    $(masonryElement).imagesLoaded(function() {
        console.log('🎯 Initial images loaded, updating layout...');
        msnry.layout();
        
        // さらに確実にレイアウトを実行
        setTimeout(() => {
            msnry.layout();
            console.log('🎯 Second layout executed');
            
            // コンテナの高さをログで確認
            console.log('🎯 Initial container height:', masonryElement.style.height);
            console.log('🎯 Container computed height:', window.getComputedStyle(masonryElement).height);
            console.log('🎯 Container scroll height:', masonryElement.scrollHeight);
            console.log('🎯 Initial masonry layout completed');
        }, 200);
    });



    console.log('Initializing infinite scroll 5.0.0...');
    
    // page-nav要素の存在確認
    var pageNavElement = document.querySelector('#page-nav');
    var nextLinkElement = document.querySelector('#page-nav a[rel="next"]');
    
    console.log('🔍 Page nav element:', pageNavElement);
    console.log('🔍 Next link element:', nextLinkElement);
    console.log('🔍 Next link href:', nextLinkElement ? nextLinkElement.href : 'none');
    console.log('🔍 Masonry container:', document.querySelector('.masonry'));
    console.log('🔍 Current items count:', document.querySelectorAll('.ui.card.item').length);
    console.log('🔍 Status container:', document.querySelector('.page-load-status'));
    
    if (!pageNavElement || !nextLinkElement) {
        console.error('❌ Page nav or next link element not found!');
        return;
    }

    // ナビゲーションを見た目上非表示にするが、DOMには残す
    pageNavElement.style.opacity = '0';
    pageNavElement.style.height = '0';
    pageNavElement.style.overflow = 'hidden';
    pageNavElement.style.pointerEvents = 'none';
    
    var infScroll = new InfiniteScroll( '.masonry', {
        path: '#page-nav a[rel="next"]',
        append: '.ui.card.item',
        history: false,
        outlayer: msnry,
        status: '.page-load-status',
        scrollThreshold: 100,
        loadOnScroll: true,
        elementScroll: false,
        checkLastPage: true,
        debug: true,
        // 5.0.0用の追加設定
        button: false,
        hideNav: false
    });
    
    // 自動ロード機能は無効化（コメントアウト）
    // 通常のスクロール動作のみ有効
    
    // infinite scrollの内部状態をチェック
    console.log('🔧 InfiniteScroll internal state:');
    console.log('🔧 loadOnScroll:', infScroll.options.loadOnScroll);
    console.log('🔧 scrollThreshold:', infScroll.options.scrollThreshold);
    console.log('🔧 Element scroll:', infScroll.options.elementScroll);
    console.log('🔧 Path selector working:', document.querySelector('#page-nav a[rel="next"]'));
    console.log('🔧 Current path:', infScroll.getPath && infScroll.getPath());
    console.log('🔧 Container element:', infScroll.element);
    console.log('🔧 Is enabled:', infScroll.isEnabled);
    
    // シンプルなテスト用ボタン
    let currentPage = 1;
    
    const testButton = document.createElement('button');
    testButton.textContent = 'Load Next Page';
    testButton.style.position = 'fixed';
    testButton.style.top = '10px';
    testButton.style.right = '10px';
    testButton.style.zIndex = '9999';
    testButton.style.backgroundColor = 'red';
    testButton.style.color = 'white';
    testButton.style.padding = '10px';
    
    testButton.onclick = function() {
        currentPage++;
        const nextPath = '/youtubes/view_counts?page=' + currentPage;
        
        fetch(nextPath)
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newItems = doc.querySelectorAll('.ui.card.item');
                
                if (newItems.length > 0) {
                    const masonryContainer = document.querySelector('.masonry');
                    const newElements = [];
                    
                    // 新しいアイテムをDOMに追加
                    newItems.forEach(item => {
                        const clonedItem = item.cloneNode(true);
                        masonryContainer.appendChild(clonedItem);
                        newElements.push(clonedItem);
                    });
                    
                    // 画像読み込み完了を待ってからMasonryレイアウト更新
                    $(newElements).imagesLoaded(function() {
                        // Masonryを完全にリロード
                        msnry.reloadItems();
                        msnry.layout();
                        console.log(`✅ Added ${newItems.length} items from page ${currentPage}`);
                    });
                }
            })
            .catch(err => console.log('Error:', err));
    };
    
    document.body.appendChild(testButton);
    
    console.log('Infinite scroll 5.0.0 initialized:', infScroll);

    infScroll.on('request', function(path, fetchPromise) {
        console.log('🔄 REQUEST: Loading:', path);
        console.log('📍 Status element exists:', document.querySelector('.page-load-status'));
        console.log('📍 Request element exists:', document.querySelector('.infinite-scroll-request'));
        
        $('.page-load-status').show();
        $('.infinite-scroll-request').show();
        console.log('✅ Loading status shown');
    });
    
    infScroll.on('load', function(response, path) {
        console.log('📥 LOAD: Loaded:', path);
        console.log('📊 Response type:', typeof response);
        console.log('📊 Response length:', response ? response.length : 'null');
        $('.infinite-scroll-request').hide();
    });
    
    infScroll.on('append', function(response, path, items) {
        console.log('📌 APPEND: Items:', items);
        console.log('📌 Items length:', items ? items.length : 'null');
        console.log('📌 Items type:', typeof items);
        
        if (items && items.length > 0) {
            console.log('✅ Adding', items.length, 'items to masonry');
            
            // Masonryレイアウトを更新
            msnry.appended(items);
            
            // Magnific Popupを再初期化
            $(items).find('.magnific-popup').magnificPopup({
                type: 'iframe',
                mainClass: 'mfp-fade',
                removalDelay: 200,
                preloader: false
            });
        } else {
            console.log('❌ No items to append');
        }
        
        $('.page-load-status').hide();
    });
    
    infScroll.on('last', function(response, path) {
        console.log('🏁 LAST: Last page reached');
        $('.page-load-status').hide();
        $('.infinite-scroll-last').show();
    });
    
    infScroll.on('error', function(error, path) {
        console.log('❌ ERROR: Loading failed:', path, error);
        $('.infinite-scroll-request').hide();
        $('.infinite-scroll-error').show();
    });

    // ローディングステータスを初期状態で非表示にする
    $('.page-load-status').hide();
});
