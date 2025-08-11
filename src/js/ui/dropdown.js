// Semantic UI Dropdown initialization
export function initDropdown() {
    $('select.dropdown').dropdown();
    $('.ui.dropdown').dropdown();
    // GTVスタイルのselectも初期化
    $('select.gtv-select').dropdown();
}