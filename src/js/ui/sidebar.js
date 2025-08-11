// Sidebar functionality
export function initSidebar() {
    $('#js-sidebar').click(function() {
        $('.ui.sidebar').sidebar('toggle');
    });
}