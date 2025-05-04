// bootstrap
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import '../node_modules/bootstrap/dist/js/bootstrap.min.js';

// semantic-ui-css
import '../node_modules/semantic-ui-css/semantic.min';
import '../node_modules/semantic-ui-css/semantic.min.css';

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
import './css/semantic-ui-custom.css';
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

    var msnry = new Masonry( '#masonry', {
        itemSelector : '.ui.item.item',
        columnWidth  : 5,
        isFitWidth   : false,
        isAnimated   : true,
        animationOptions: {
            duration : 750,
            easing   : 'linear',
            queue    : false
        }
    });

    var infScroll = new InfiniteScroll( '#masonry', {

        // onInit
        //   2ページ目以降を infinite-scrollで追加する際にmagnefic-popupの初期化を行う
        //
        //   refs
        //     https://infinite-scroll.com/options.html#oninit
        //     https://stackoverflow.com/questions/46348603/infinite-scroll-with-magnific-popup-callback
        onInit: function() {
            this.on( 'append', function() {
                console.log('Infinite Scroll appended.')
                console.log('magnefic-popup initialization.')
                $('.magnific-popup').magnificPopup({
                    type: 'iframe',
                    mainClass: 'mfp-fade',
                    removalDelay: 200,
                    preloader: false
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
        scrollThreshold : 10,
        append          : '.ui.card.item',
        outlayer        : msnry,
        navSelector     : '#page-nav',
        nextSelector    : '#page-nav a',
        path            : '#page-nav a',
        itemSelector    : '.item',
        status          : '.page-load-status'
    });

    $('.page-load-status').hide();
});

