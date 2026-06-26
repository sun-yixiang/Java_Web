(function () {
    function ready(fn) {
        if (document.readyState !== "loading") {
            fn();
        } else {
            document.addEventListener("DOMContentLoaded", fn);
        }
    }

    ready(function () {
        var nav = document.querySelector("[data-nav-slider]");
        if (!nav) return;

        var indicator = nav.querySelector(".nav-indicator");
        var active = nav.querySelector("a.active");
        if (!indicator || !active) return;

        var key = nav.getAttribute("data-nav-key") || "nav-slider";
        var navRect = nav.getBoundingClientRect();
        var activeRect = active.getBoundingClientRect();
        var targetX = activeRect.left - navRect.left;
        var targetW = activeRect.width;
        var previous = null;

        try {
            previous = JSON.parse(localStorage.getItem(key));
        } catch (e) {
            previous = null;
        }

        if (previous && typeof previous.x === "number" && typeof previous.w === "number") {
            indicator.style.transition = "none";
            indicator.style.opacity = "1";
            indicator.style.width = previous.w + "px";
            indicator.style.transform = "translateX(" + previous.x + "px)";
            requestAnimationFrame(function () {
                requestAnimationFrame(function () {
                    indicator.style.transition = "";
                    indicator.style.width = targetW + "px";
                    indicator.style.transform = "translateX(" + targetX + "px)";
                });
            });
        } else {
            indicator.style.opacity = "1";
            indicator.style.width = targetW + "px";
            indicator.style.transform = "translateX(" + targetX + "px)";
        }

        try {
            localStorage.setItem(key, JSON.stringify({ x: targetX, w: targetW }));
        } catch (e) {
        }

        nav.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", function () {
                var rect = link.getBoundingClientRect();
                var base = nav.getBoundingClientRect();
                indicator.style.opacity = "1";
                indicator.style.width = rect.width + "px";
                indicator.style.transform = "translateX(" + (rect.left - base.left) + "px)";
                try {
                    localStorage.setItem(key, JSON.stringify({ x: rect.left - base.left, w: rect.width }));
                } catch (e) {
                }
            });
        });
    });
})();
