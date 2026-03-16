document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("loginForm");

    if (!loginForm) {
        return;
    }

    loginForm.addEventListener("submit", function (e) {
        let isValid = true;

        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();

        const emailError = document.getElementById("emailError");
        const passwordError = document.getElementById("passwordError");

        emailError.textContent = "";
        passwordError.textContent = "";

        if (email === "") {
            emailError.textContent = "Email is required.";
            isValid = false;
        } else if (!isValidEmail(email)) {
            emailError.textContent = "Please enter a valid email address.";
            isValid = false;
        } else if (!email.endsWith("@sjsu.edu")) {
            emailError.textContent = "Email must end with @sjsu.edu.";
            isValid = false;
        }

        if (password === "") {
            passwordError.textContent = "Password is required.";
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    function isValidEmail(email) {
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailPattern.test(email);
    }
});
