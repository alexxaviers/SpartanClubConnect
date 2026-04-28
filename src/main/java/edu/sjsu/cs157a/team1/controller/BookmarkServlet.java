package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.BookmarkDAO;
import edu.sjsu.cs157a.team1.util.CsrfUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class BookmarkServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (!CsrfUtil.isValid(session, req.getParameter("csrfToken"))) {
            resp.sendRedirect("events?error=Invalid+request");
            return;
        }

        String action = req.getParameter("action");
        String returnTo = req.getParameter("returnTo");
        String returnFeed = req.getParameter("returnFeed");

        int eventId;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect("events?error=Invalid+event+ID");
            return;
        }

        BookmarkDAO bookmarkDAO = new BookmarkDAO();
        try {
            if ("save".equalsIgnoreCase(action)) {
                boolean saved = bookmarkDAO.addBookmark(userId, eventId);
                if (saved) {
                    redirectWithMessage(resp, returnTo, returnFeed, eventId, "success", "Event saved");
                } else {
                    redirectWithMessage(resp, returnTo, returnFeed, eventId, "error", "Event already saved");
                }
            	return;
        	} else if ("remove".equalsIgnoreCase(action)) {
                boolean removed = bookmarkDAO.removeBookmark(userId, eventId);
                if (removed) {
                    redirectWithMessage(resp, returnTo, returnFeed, eventId, "success", "Bookmark removed");
                } else {
                    redirectWithMessage(resp, returnTo, returnFeed, eventId, "error", "Bookmark was already removed");
                }
                return;
            }

            redirectWithMessage(resp, returnTo, returnFeed, eventId, "error", "Unknown action");
        } catch (Exception e) {
            log("Bookmark processing failed for userId=" + userId + ", eventId=" + eventId, e);
            redirectWithMessage(resp, returnTo, returnFeed, eventId, "error", "Unable to update bookmark right now");
        }
    }

    private void redirectWithMessage(HttpServletResponse resp, String returnTo, String returnFeed, int eventId, String key, String value)
            throws IOException {
        String encoded = URLEncoder.encode(value, StandardCharsets.UTF_8);

        if ("my-bookmarks".equals(returnTo)) {
            resp.sendRedirect("my-bookmarks?" + key + "=" + encoded);
            return;
        }

        if ("events".equals(returnTo)) {
            String feedQuery = ("personalized".equals(returnFeed) || "all".equals(returnFeed))
                    ? "&feed=" + returnFeed
                    : "";
            resp.sendRedirect("events?" + key + "=" + encoded + feedQuery);
            return;
        }

        resp.sendRedirect("event-details?eventId=" + eventId + "&" + key + "=" + encoded);
    }
}
