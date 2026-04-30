package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ProfileDAO;
import edu.sjsu.cs157a.team1.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ProfileUpdateServlet extends HttpServlet {

    private static final int MAX_FULL_NAME_LENGTH = 100;
    private static final int MIN_PASSWORD_LENGTH = 8;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String fullName = trimToEmpty(request.getParameter("fullName"));
        String password = trimToEmpty(request.getParameter("password"));
        String confirmPassword = trimToEmpty(request.getParameter("confirmPassword"));

        request.setAttribute("profileEditMode", true);
        request.setAttribute("submittedFullName", fullName);

        if (fullName.isEmpty()) {
            request.setAttribute("profileError", "Full name is required.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (fullName.length() > MAX_FULL_NAME_LENGTH) {
            request.setAttribute("profileError", "Full name cannot exceed " + MAX_FULL_NAME_LENGTH + " characters.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        boolean updatePassword = !password.isEmpty() || !confirmPassword.isEmpty();
        String passwordHash = null;

        if (updatePassword) {
            if (password.length() < MIN_PASSWORD_LENGTH) {
                request.setAttribute("profileError", "Password must be at least " + MIN_PASSWORD_LENGTH + " characters.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("profileError", "Password and confirm password do not match.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            passwordHash = PasswordUtil.hashPassword(password);
        }

        ProfileDAO profileDAO = new ProfileDAO();
        boolean updated = profileDAO.updateProfile(userId, fullName, passwordHash);

        if (!updated) {
            request.setAttribute("profileError", "Unable to update profile right now.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        session.setAttribute("fullName", fullName);
        request.getSession().setAttribute("toastMessage", "Profile updated successfully.");
        request.getSession().setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
