package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.BookmarkDAO;
import edu.sjsu.cs157a.team1.dao.RsvpDAO;
import edu.sjsu.cs157a.team1.util.PaginationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class MyBookmarksServlet extends HttpServlet {
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        BookmarkDAO bookmarkDAO = new BookmarkDAO();
        int page = PaginationUtil.parsePage(req.getParameter("page"));

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));

        try {
        	List<RsvpDAO.EventView> allEvents = bookmarkDAO.getBookmarkedUpcomingEvents(userId);
            PaginationUtil.PageResult<RsvpDAO.EventView> pagedResult = PaginationUtil.paginate(allEvents, page, PAGE_SIZE);

            req.setAttribute("events", pagedResult.getItems());
            req.setAttribute("totalEvents", pagedResult.getTotalItems());
            req.setAttribute("currentPage", pagedResult.getCurrentPage());
            req.setAttribute("totalPages", pagedResult.getTotalPages());
        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("totalEvents", 0);
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 0);
            req.setAttribute("error", "Unable to load saved events right now.");
        }

        req.getRequestDispatcher("myBookmarks.jsp").forward(req, resp);
    }
}
