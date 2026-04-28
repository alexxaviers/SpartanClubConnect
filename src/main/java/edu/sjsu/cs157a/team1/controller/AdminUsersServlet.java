package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.AdminUserDAO;
import edu.sjsu.cs157a.team1.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminUsersServlet extends HttpServlet {

    private final AdminUserDAO adminUserDAO = new AdminUserDAO();

    private Integer getSessionUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Integer) session.getAttribute("userId");
    }

    private boolean isAdmin(HttpServletRequest request) throws SQLException {
        Integer userId = getSessionUserId(request);
        return userId != null && adminUserDAO.userHasRole(userId, "Admin");
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Integer sessionUserId = getSessionUserId(request);

        if (sessionUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            if (!requireAdmin(request, response)) {
                return;
            }

            List<User> users = adminUserDAO.getAllUsers();
            Map<Integer, String> userDisplayRoleMap = new LinkedHashMap<>();

            for (User user : users) {
                String displayRole = "Student";

                if (adminUserDAO.userHasRole(user.getUserId(), "Admin")) {
                    displayRole = "Admin";
                } else if (adminUserDAO.userHasRole(user.getUserId(), "Club Officer")) {
                    displayRole = "Club Officer";
                }

                userDisplayRoleMap.put(user.getUserId(), displayRole);
            }

            request.setAttribute("users", users);
            request.setAttribute("userDisplayRoleMap", userDisplayRoleMap);
            request.getRequestDispatcher("/adminUsers.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load users.");
            request.getRequestDispatcher("/adminUsers.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            if (!requireAdmin(request, response)) {
                return;
            }

            Integer sessionUserId = getSessionUserId(request);
            String action = request.getParameter("action");
            String userIdParam = request.getParameter("userId");

            if (userIdParam == null || userIdParam.isBlank()) {
                request.getSession().setAttribute("adminUsersMessage", "Invalid user ID.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            int targetUserId = Integer.parseInt(userIdParam);
            boolean success;

            switch (action) {
                case "deactivate":
                    if (targetUserId == sessionUserId) {
                        request.getSession().setAttribute("adminUsersMessage", "You cannot deactivate your own account.");
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        return;
                    }

                    if (adminUserDAO.userHasRole(targetUserId, "Admin")) {
                        request.getSession().setAttribute("adminUsersMessage", "You cannot deactivate another admin account.");
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        return;
                    }

                    String deactivateReason = request.getParameter("reason");
                    success = adminUserDAO.deactivateAccountWithAudit(targetUserId, sessionUserId, deactivateReason);
                    request.getSession().setAttribute(
                            "adminUsersMessage",
                            success ? "User deactivated successfully." : "No changes were made."
                    );
                    break;

                case "reactivate":
                    success = adminUserDAO.reactivateAccountAndClearAudit(targetUserId);
                    request.getSession().setAttribute(
                            "adminUsersMessage",
                            success ? "User reactivated successfully." : "No changes were made."
                    );
                    break;

                default:
                    request.getSession().setAttribute("adminUsersMessage", "Invalid action.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminUsersMessage", "User ID must be a valid number.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("adminUsersMessage", "A database error occurred.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
