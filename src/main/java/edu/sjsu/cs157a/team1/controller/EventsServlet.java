package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.BookmarkDAO;
import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.dao.RsvpDAO;
import edu.sjsu.cs157a.team1.model.Club;
import edu.sjsu.cs157a.team1.util.PaginationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.Set;
import java.util.List;

public class EventsServlet extends HttpServlet {
    private static final int PAGE_SIZE = 5;

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
        int page = PaginationUtil.parsePage(req.getParameter("page"));


        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));
        req.setAttribute("feedMode", feedMode);
        req.setAttribute("activeNav", "browseEvents");

        try {
        	List<RsvpDAO.EventView> allEvents;
            if (clubIdParam != null && !clubIdParam.trim().isEmpty()) {
                int clubId = Integer.parseInt(clubIdParam.trim());
                allEvents = rsvpDAO.getEventsForUserByClub(userId, clubId);

                Club club = clubDAO.findById(clubId);
                if (club != null) {
                    req.setAttribute("selectedClubName", club.getName());
                    req.setAttribute("selectedClubId", clubId);
                }
            } else if ("personalized".equals(feedMode)) {
            	allEvents = rsvpDAO.getFollowedClubEventsForUser(userId);
            } else {
            	allEvents = rsvpDAO.getAllEventsForUser(userId);
            }
            PaginationUtil.PageResult<RsvpDAO.EventView> pagedResult = PaginationUtil.paginate(allEvents, page, PAGE_SIZE);

            req.setAttribute("events", pagedResult.getItems());
            req.setAttribute("totalEvents", pagedResult.getTotalItems());
            req.setAttribute("currentPage", pagedResult.getCurrentPage());
            req.setAttribute("totalPages", pagedResult.getTotalPages());

            Set<Integer> bookmarkedEventIds = bookmarkDAO.getBookmarkedEventIds(userId);
            req.setAttribute("bookmarkedEventIds", bookmarkedEventIds);

        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("bookmarkedEventIds", Collections.emptySet());
            req.setAttribute("totalEvents", 0);
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 0);
            req.setAttribute("error", "Unable to load events right now.");
        }

        req.getRequestDispatcher("/events.jsp").forward(req, resp);
    }
}
