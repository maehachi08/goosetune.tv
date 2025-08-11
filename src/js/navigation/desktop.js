// Desktop navigation functionality
export function initDesktopNavigation() {
    // gtv style navigation accordion
    $('.gtv-nav-category-header').on('click', function() {
        const $category = $(this).closest('.gtv-nav-category');
        const $content = $category.find('.gtv-nav-category-content');

        if ($category.hasClass('active')) {
            $category.removeClass('active');
            $content.slideUp(200);
        } else {
            $category.addClass('active');
            $content.slideDown(200);
        }
    });

    $('.gtv-nav-subcategory-header').on('click', function() {
        const $subcategory = $(this).closest('.gtv-nav-subcategory');
        const $content = $subcategory.find('.gtv-nav-subcategory-content');

        if ($subcategory.hasClass('active')) {
            $subcategory.removeClass('active');
            $content.slideUp(150);
        } else {
            $subcategory.addClass('active');
            $content.slideDown(150);
        }
    });

    // Close dropdowns when clicking outside
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.gtv-nav-tablet').length) {
            $('#tablet-dropdown').removeClass('active');
        }
    });
}