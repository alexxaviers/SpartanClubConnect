package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.BookmarkDAO;
import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.dao.RsvpDAO;
import edu.sjsu.cs157a.team1.model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.Set;

public class EventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        RsvpDAO rsvpDAO = new RsvpDAO();
        ClubDAO clubDAO = new ClubDAO();
        BookmarkDAO bookmarkDAO = new BookmarkDAO();

        String feedParam = req.getParameter("feed");
        String feedMode = "personalized".equalsIgnoreCase(feedParam) ? "personalized" : "all";
        String clubIdParam = req.getParameter("clubId");

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));
        req.setAttribute("feedMode", feedMode);
        req.setAttribute("activeNav", "browseEvents");

        try {
            if (clubIdParam != null && !clubIdParam.trim().isEmpty()) {
                int clubId = Integer.parseInt(clubIdParam.trim());
                req.setAttribute("events", rsvpDAO.getEventsForUserByClub(userId, clubId));

                Club club = clubDAO.findById(clubId);
                if (club != null) {
                    req.setAttribute("selectedClubName", club.getName());
                    req.setAttribute("selectedClubId", clubId);
                }
            } else if ("personalized".equals(feedMode)) {
                req.setAttribute("events", rsvpDAO.getFollowedClubEventsForUser(userId));
            } else {
                req.setAttribute("events", rsvpDAO.getAllEventsForUser(userId));
            }

            Set<Integer> bookmarkedEventIds = bookmarkDAO.getBookmarkedEventIds(userId);
            req.setAttribute("bookmarkedEventIds", bookmarkedEventIds);

        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("bookmarkedEventIds", Collections.emptySet());
            req.setAttribute("error", "Unable to load events right now.");
        }

        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }
}
