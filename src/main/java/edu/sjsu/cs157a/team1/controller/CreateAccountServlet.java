package edu.sjsu.cs157a.team1.controller;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import edu.sjsu.cs157a.team1.dao.UserDAO;
import edu.sjsu.cs157a.team1.model.User;
import edu.sjsu.cs157a.team1.util.PasswordUtil;

import javax.servlet.ServletException;

public class CreateAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String error = validate(fullName, email, password, confirmPassword);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            return;
        }

        UserDAO userDao = new UserDAO();

        // Check if the user email already exists
        if (userDao.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "An account with that email already exists.");
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            return;
        }

        // Hash the password and create user
        String passwordHash = PasswordUtil.hashPassword(password);
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(passwordHash);
        user.setRole("Student");

        boolean created = userDao.createUser(user);
        if (!created) {
            request.setAttribute("errorMessage", "Unable to create account at this time. Please try again later.");
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            return;
        }

        request.setAttribute("successMessage", "Account created successfully. You can now log in.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private String validate(String fullName, String email, String password, String confirmPassword) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }

        if (email == null || email.trim().isEmpty()) {
            return "SJSU email address is required.";
        }

        String trimmedEmail = email.trim().toLowerCase();
        if (!trimmedEmail.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return "Please enter a valid email address.";
        }

        if (!trimmedEmail.endsWith("@sjsu.edu")) {
            return "Email must be an @sjsu.edu address.";
        }

        if (password == null || password.isEmpty()) {
            return "Password is required.";
        }

        if (password.length() < 8) {
            return "Password must be at least 8 characters.";
        }

        if (confirmPassword == null || !password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }

        return null;
    }
}