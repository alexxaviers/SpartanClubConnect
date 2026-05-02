package edu.sjsu.cs157a.team1.controller;

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

public class MyRsvpsServlet extends HttpServlet {
    private static final int PAGE_SIZE = 5;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        RsvpDAO rsvpDAO = new RsvpDAO();
        int page = PaginationUtil.parsePage(req.getParameter("page"));

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));

        try {
        	List<RsvpDAO.EventView> allEvents = rsvpDAO.getMyUpcomingRsvps(userId);
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
            req.setAttribute("error", "Unable to load your RSVPs right now.");
        }

        req.getRequestDispatcher("myRsvps.jsp").forward(req, resp);
    }
}
