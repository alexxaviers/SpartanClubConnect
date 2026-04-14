document.addEventListener("DOMContentLoaded", function () {
    var sidebar = document.getElementById("dashboardSidebar");
    var overlay = document.getElementById("dashboardOverlay");
    var openBtn = document.getElementById("sidebarOpenBtn");
    var closeBtn = document.getElementById("sidebarCloseBtn");

    if (!sidebar || !overlay || !openBtn || !closeBtn) {
        return;
    }

    function openSidebar() {
        sidebar.classList.add("open");
        overlay.classList.add("show");
    }

    function closeSidebar() {
        sidebar.classList.remove("open");
        overlay.classList.remove("show");
    }

    function toggleSidebar() {
        if (sidebar.classList.contains("open")) {
            closeSidebar();
        } else {
            openSidebar();
        }
    }

    openBtn.addEventListener("click", toggleSidebar);
    closeBtn.addEventListener("click", closeSidebar);
    overlay.addEventListener("click", closeSidebar);

    window.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeSidebar();
        }
    });

    window.addEventListener("resize", function () {
        closeSidebar();
    });
});
