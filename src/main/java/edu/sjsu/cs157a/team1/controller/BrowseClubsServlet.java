package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.model.Club;
import edu.sjsu.cs157a.team1.util.PaginationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class BrowseClubsServlet extends HttpServlet {
	
	private static final int PAGE_SIZE = 5;
	
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String keyword = request.getParameter("q");
        String category = request.getParameter("category");
        String sort = request.getParameter("sort");

        if (sort == null || sort.trim().isEmpty()) {
            sort = "name_asc";
        }
        
        int page = PaginationUtil.parsePage(request.getParameter("page"));

        ClubDAO clubDAO = new ClubDAO();
        List<Club> filteredClubs = clubDAO.searchClubs(keyword, category, sort);
        PaginationUtil.PageResult<Club> pagedResult = PaginationUtil.paginate(filteredClubs, page, PAGE_SIZE);
        List<Club> clubs = pagedResult.getItems();

        request.setAttribute("activeNav", "browseClubs");
        request.setAttribute("clubs", clubs);
        request.setAttribute("totalClubs", pagedResult.getTotalItems());
        request.setAttribute("currentPage", pagedResult.getCurrentPage());
        request.setAttribute("totalPages", pagedResult.getTotalPages());
        request.setAttribute("q", keyword != null ? keyword : "");
        request.setAttribute("category", category != null ? category : "");
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/clubs.jsp").forward(request, response);
    }
}
