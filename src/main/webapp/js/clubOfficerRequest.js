document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector(".dashboard-form");
    if (!form) return;

    const submitBtn = form.querySelector(".primary-btn");
    const justification = document.getElementById("justification");
    const charCount = document.getElementById("justificationCount");

    if (justification && charCount) {
        const updateCount = function () {
            charCount.textContent = justification.value.length + "/500 characters";
        };

        justification.addEventListener("input", updateCount);
        updateCount();
    }

    if (submitBtn) {
        form.addEventListener("submit", function () {
            submitBtn.disabled = true;
            submitBtn.textContent = "Submitting...";
        });
    }
});
