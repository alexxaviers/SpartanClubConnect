document.addEventListener("DOMContentLoaded", function () {
    var form = document.getElementById("createAccountForm");
    if (!form) {
        return;
    }

    var fullNameInput = document.getElementById("fullName");
    var emailInput = document.getElementById("email");
    var passwordInput = document.getElementById("password");
    var confirmPasswordInput = document.getElementById("confirmPassword");

    var fullNameError = document.getElementById("fullNameError");
    var emailError = document.getElementById("emailError");
    var passwordError = document.getElementById("passwordError");
    var confirmPasswordError = document.getElementById("confirmPasswordError");

    function clearErrors() {
        fullNameError.textContent = "";
        emailError.textContent = "";
        passwordError.textContent = "";
        confirmPasswordError.textContent = "";
    }

    function isValidEmail(email) {
        var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return pattern.test(email);
    }

    form.addEventListener("submit", function (e) {
        var isValid = true;
        clearErrors();

        var fullName = fullNameInput.value.trim();
        var email = emailInput.value.trim();
        var password = passwordInput.value;
        var confirmPassword = confirmPasswordInput.value;

        if (fullName === "") {
            fullNameError.textContent = "Full name is required.";
            isValid = false;
        }

        if (email === "") {
            emailError.textContent = "Email address is required.";
            isValid = false;
        } else if (!isValidEmail(email)) {
            emailError.textContent = "Please enter a valid email address.";
            isValid = false;
        } else if (!email.toLowerCase().endsWith("@sjsu.edu")) {
            emailError.textContent = "Email must be an @sjsu.edu address.";
            isValid = false;
        }

        if (password === "") {
            passwordError.textContent = "Password is required.";
            isValid = false;
        } else if (password.length < 8) {
            passwordError.textContent = "Password must be at least 8 characters.";
            isValid = false;
        }

        if (confirmPassword === "") {
            confirmPasswordError.textContent = "Please confirm your password.";
            isValid = false;
        } else if (confirmPassword !== password) {
            confirmPasswordError.textContent = "Passwords do not match.";
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
        }
    });
});