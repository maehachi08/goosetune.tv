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
    var InfiniteScroll = require('infinite-scroll');
    jQueryBridget( 'imagesLoaded', imagesLoaded, $ );
    jQueryBridget( 'masonry', Masonry, $ );
    jQueryBridget( 'infinitescroll', InfiniteScroll, $ );
    InfiniteScroll.imagesLoaded = imagesLoaded;

    var msnry = new Masonry( '.masonry', {
        itemSelector : '.ui.card.item',
        columnWidth  : '.ui.card.item',
        percentPosition: true,
        gutter: 20
    });



    console.log('Initializing infinite scroll...');
    var infScroll = new InfiniteScroll( '.masonry', {
        //path: '#page-nav a[rel="Next"]',
        path: '#page-nav a[rel="Next"]',
        append: '.masonry .ui.card.item',
        history: false,
        outlayer: msnry,
        status: '.page-load-status',
        scrollThreshold: 200,
        elementScroll: false,
        loadOnScroll: true,
        debug: true
    });
    console.log('Infinite scroll initialized:', infScroll);

    infScroll.on('append', function(response, path, items) {
        $('.magnific-popup').magnificPopup({
            type: 'iframe',
            mainClass: 'mfp-fade',
            removalDelay: 200,
            preloader: false
        });
    });

    $('.page-load-status').hide();
});
