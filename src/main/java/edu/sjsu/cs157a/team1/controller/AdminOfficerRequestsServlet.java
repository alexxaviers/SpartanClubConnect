package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubOfficerRequestDAO;
import edu.sjsu.cs157a.team1.model.ClubOfficerRequest;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminOfficerRequestsServlet extends HttpServlet {

    private final ClubOfficerRequestDAO requestDAO = new ClubOfficerRequestDAO();

    private Integer getSessionUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Integer) session.getAttribute("userId");
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Integer adminUserId = getSessionUserId(request);

        if (adminUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        if (!requestDAO.userHasRole(adminUserId, "Admin")) {
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

            List<ClubOfficerRequest> pendingRequests = requestDAO.getPendingRequests();
            List<ClubOfficerRequest> reviewedRequests = requestDAO.getReviewedRequests();

            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("reviewedRequests", reviewedRequests);
            request.getRequestDispatcher("/adminOfficerRequests.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load officer requests.");
            request.getRequestDispatcher("/adminOfficerRequests.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            if (!requireAdmin(request, response)) {
                return;
            }

            Integer adminUserId = getSessionUserId(request);
            String action = request.getParameter("action");
            String requestIdParam = request.getParameter("requestId");

            if (requestIdParam == null || requestIdParam.isBlank()) {
                request.getSession().setAttribute("adminOfficerRequestMessage", "Invalid request ID.");
                response.sendRedirect(request.getContextPath() + "/AdminOfficerRequestsServlet");
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);
            boolean success = false;

            if ("approve".equalsIgnoreCase(action)) {
                success = requestDAO.approveRequest(requestId, adminUserId);
                request.getSession().setAttribute(
                        "adminOfficerRequestMessage",
                        success ? "Officer request approved successfully." : "Unable to approve request."
                );
            } else if ("deny".equalsIgnoreCase(action)) {
                success = requestDAO.denyRequest(requestId, adminUserId);
                request.getSession().setAttribute(
                        "adminOfficerRequestMessage",
                        success ? "Officer request denied successfully." : "Unable to deny request."
                );
            } else {
                request.getSession().setAttribute("adminOfficerRequestMessage", "Invalid action.");
            }

            response.sendRedirect(request.getContextPath() + "/AdminOfficerRequestsServlet");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminOfficerRequestMessage", "Request ID must be a valid number.");
            response.sendRedirect(request.getContextPath() + "/AdminOfficerRequestsServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("adminOfficerRequestMessage", "A database error occurred.");
            response.sendRedirect(request.getContextPath() + "/AdminOfficerRequestsServlet");
        }
    }
}
