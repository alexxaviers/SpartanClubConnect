package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.RsvpDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;

public class EventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        RsvpDAO rsvpDAO = new RsvpDAO();

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));

        try {
            req.setAttribute("events", rsvpDAO.getAllEventsForUser(userId));
        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("error", "Unable to load events right now.");
        }

        req.getRequestDispatcher("events.jsp").forward(req, resp);
    }
}