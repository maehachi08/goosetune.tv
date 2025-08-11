// Tablet navigation functionality
export function initTabletNavigation() {
    // Tablet navigation toggle
    $('#tablet-menu-toggle').on('click', function() {
        const $dropdown = $('#tablet-dropdown');
        $dropdown.toggleClass('active');
    });
}