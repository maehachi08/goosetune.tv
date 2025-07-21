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
    jQueryBridget( 'imagesLoaded', imagesLoaded, $ );
    jQueryBridget( 'masonry', Masonry, $ );
    jQueryBridget( 'infinitescroll', InfiniteScroll, $ );
    InfiniteScroll.imagesLoaded = imagesLoaded;

    // 要素の存在確認
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
    var msnry = new Masonry( masonryElement, {
        itemSelector : '.ui.card.item',
        columnWidth  : '.ui.card.item',
        percentPosition: true,
        gutter: 12
    });
    // 初期アイテムの画像読み込み完了を待ってレイアウトを実行
    $(masonryElement).imagesLoaded(function() {
        msnry.layout();
        // さらに確実にレイアウトを実行
        setTimeout(() => {
            msnry.layout();
        }, 200);
    });



    // page-nav要素の存在確認
    var pageNavElement = document.querySelector('#page-nav');
    var nextLinkElement = document.querySelector('#page-nav a[rel="next"]');
    if (!pageNavElement || !nextLinkElement) {
        console.error('❌ Page nav or next link element not found!');
        return;
    }

    var infScroll = new InfiniteScroll( '.masonry', {
        path: '#page-nav a[rel="next"]',
        append: '.ui.card.item',
        history: false,
        outlayer: msnry,
        status: '.page-load-status',
        scrollThreshold: 300,          // スクロール位置が末尾から何px以内になったら次を読み込むか
        loadOnScroll: true,
        elementScroll: '.pusher',      // pusherエリアのスクロールを監視
        checkLastPage: true,
        debug: false,
        // 5.0.0用の追加設定
        button: false,
        hideNav: '#page-nav'  // セレクターで指定してナビゲーションを隠す
    });
    // pusherエリアのみスクロール可能にしてサイドバーのstickyを維持
    const pusher = document.querySelector('.pusher');
    if (pusher) {
        pusher.style.setProperty('overflow-y', 'auto', 'important');
        pusher.style.setProperty('height', '100vh', 'important');
    }
    
    // masonryコンテナは自然な高さに任せる
    const masonryContainer = document.querySelector('.masonry');
    if (masonryContainer) {
        masonryContainer.style.setProperty('height', 'auto', 'important');
        // padding-bottomを削除して自然な表示に
        masonryContainer.style.removeProperty('padding-bottom');
    }

    // InfiniteScrollライブラリに自動スクロール検知を任せる
    infScroll.on('request', function(path, fetchPromise) {
        $('.page-load-status').show();
        $('.infinite-scroll-request').show();
    });

    infScroll.on('load', function(response, path) {
        $('.infinite-scroll-request').hide();
    });

    infScroll.on('append', function(response, path, items) {
        if (items && items.length > 0) {
            // 新しいアイテムを最初は非表示にする
            items.forEach(item => {
                item.style.opacity = '0';
                item.style.transform = 'scale(0.8)';
                item.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
            });

            // 画像読み込み完了を待ってからMasonryレイアウト更新
            $(items).imagesLoaded(function() {
                msnry.reloadItems();
                msnry.layout();

                // レイアウト完了後に新しいアイテムを表示
                setTimeout(() => {
                    items.forEach(item => {
                        item.style.opacity = '1';
                        item.style.transform = 'scale(1)';
                    });
                }, 100);
            });

            // Magnific Popupを再初期化
            $(items).find('.magnific-popup').magnificPopup({
                type: 'iframe',
                mainClass: 'mfp-fade',
                removalDelay: 200,
                preloader: false
            });
        }

        $('.page-load-status').hide();
    });

    infScroll.on('last', function(response, path) {
        $('.page-load-status').hide();
        $('.infinite-scroll-last').show();
    });

    infScroll.on('error', function(error, path) {
        $('.infinite-scroll-request').hide();
        $('.infinite-scroll-error').show();
    });

    // ローディングステータスを初期状態で非表示にする
    $('.page-load-status').hide();
});
