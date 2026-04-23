package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.BookmarkDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;

public class MyBookmarksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        BookmarkDAO bookmarkDAO = new BookmarkDAO();

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));

        try {
            req.setAttribute("events", bookmarkDAO.getBookmarkedUpcomingEvents(userId));
        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("error", "Unable to load saved events right now.");
        }

        req.getRequestDispatcher("myBookmarks.jsp").forward(req, resp);
    }
}
