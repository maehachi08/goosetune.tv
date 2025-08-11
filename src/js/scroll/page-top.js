// Page top button functionality
export function initPageTopButton() {
    const $pageTop = $('#pageTop');
    const $pusher = $('.pusher');
    const $window = $(window);
    const $document = $(document);
    
    // Initially hide the button
    $pageTop.hide();
    
    // Click handler for page top button
    $pageTop.on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        performScroll();
        return false;
    });
    
    $pageTop.find('a').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        performScroll();
        return false;
    });
    
    function performScroll() {
        // Method 1: Animate pusher if it exists and has scroll
        if ($pusher.length > 0 && $pusher.scrollTop() > 0) {
            $pusher.animate({ scrollTop: 0 }, 500);
        }
        
        // Method 2: Animate window/document
        const windowScroll = $window.scrollTop();
        const documentScroll = $document.scrollTop();
        if (windowScroll > 0 || documentScroll > 0) {
            $('html, body').animate({ scrollTop: 0 }, 500);
        }
        
        // Method 3: Direct scroll API
        try {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        } catch (e) {
            // Fallback for older browsers
            window.scrollTo(0, 0);
        }
        
        // Method 4: Scroll all currently scrolled elements
        const currentlyScrolledElements = [];
        document.querySelectorAll('*').forEach(el => {
            if (el.scrollTop > 0) {
                currentlyScrolledElements.push(el);
            }
        });
        
        // Animate currently scrolled elements
        currentlyScrolledElements.forEach((el) => {
            $(el).animate({ scrollTop: 0 }, 500);
        });
        
        // Fallback immediate scroll
        setTimeout(function() {
            window.scrollTo(0, 0);
            document.documentElement.scrollTop = 0;
            document.body.scrollTop = 0;
            
            if ($pusher.length > 0) {
                $pusher.scrollTop(0);
                $pusher[0].scrollTop = 0;
            }
            
            // Ensure all scrolled elements are reset to top
            currentlyScrolledElements.forEach(el => {
                el.scrollTop = 0;
            });
        }, 100);
    }
    
    // Monitor scroll for button visibility
    function handleScroll() {
        let windowScroll = $window.scrollTop();
        let documentScroll = $document.scrollTop();
        let pusherScroll = $pusher.length > 0 ? $pusher.scrollTop() : 0;
        let bodyScroll = document.body.scrollTop;
        let docElementScroll = document.documentElement.scrollTop;
        
        // Check for any scrolled elements
        let hasScrolledElements = false;
        document.querySelectorAll('*').forEach(el => {
            if (el.scrollTop > 0) {
                hasScrolledElements = true;
            }
        });
        
        let maxScroll = Math.max(windowScroll, documentScroll, pusherScroll, bodyScroll, docElementScroll);
        
        if (maxScroll > 300 || hasScrolledElements) {
            $pageTop.fadeIn(300);
        } else {
            $pageTop.fadeOut(300);
        }
    }
    
    // Attach scroll handlers
    $pusher.on('scroll', handleScroll);
    $window.on('scroll', handleScroll);
    $document.on('scroll', handleScroll);
    
    // Initial check
    setTimeout(handleScroll, 1000);
}