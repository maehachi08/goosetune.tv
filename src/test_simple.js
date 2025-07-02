// テスト用の簡単なJavaScript
console.log("TEST: Simple JavaScript is working!");
console.log("TEST: This should appear immediately!");

// グローバルスコープでのテスト
window.testVariable = "JavaScript is loaded!";

// DOMContentLoadedイベントのテスト
document.addEventListener("DOMContentLoaded", function() {
    console.log("TEST: DOMContentLoaded fired!");
});

// ページ読み込み完了のテスト
window.addEventListener("load", function() {
    console.log("TEST: Window load event fired!");
});

// jQueryがロードされているかテスト
if (typeof jQuery !== 'undefined') {
    console.log("TEST: jQuery is loaded - version:", jQuery.fn.jquery);
} else {
    console.log("TEST: jQuery is NOT loaded");
}

// DOMが既に読み込まれている場合の処理
if (document.readyState === 'loading') {
    console.log("TEST: DOM is still loading");
} else {
    console.log("TEST: DOM is already loaded, state:", document.readyState);
}