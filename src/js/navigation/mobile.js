// Mobile navigation functionality
export function initMobileNavigation() {
    // Mobile navigation toggle
    $('#mobile-menu-toggle').on('click', function() {
        $('#mobile-sidebar').addClass('active');
        $('body').css('overflow', 'hidden');
    });

    $('#mobile-menu-close, #mobile-overlay').on('click', function() {
        $('#mobile-sidebar').removeClass('active');
        $('body').css('overflow', '');
    });
}