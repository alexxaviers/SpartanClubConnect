package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.FollowDAO;
import edu.sjsu.cs157a.team1.util.PaginationUtil;
import edu.sjsu.cs157a.team1.model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class FollowedClubsServlet extends HttpServlet{
    private static final int PAGE_SIZE = 5;
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		if(session == null || session.getAttribute("userId") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		
		if(Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
			response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
			return;
		}
		
		Integer userId = (Integer) session.getAttribute("userId");
		FollowDAO followDAO = new FollowDAO();
		List<Club> allFollowedClubs = followDAO.getClubsFollowedByUser(userId);
		int page = PaginationUtil.parsePage(request.getParameter("page"));
		PaginationUtil.PageResult<Club> pagedResult = PaginationUtil.paginate(allFollowedClubs, page, PAGE_SIZE);
		List<Club> followedClubs = pagedResult.getItems();
		
		request.setAttribute("followedClubs", followedClubs);
		request.setAttribute("totalClubs", pagedResult.getTotalItems());
		request.setAttribute("currentPage", pagedResult.getCurrentPage());
		request.setAttribute("totalPages", pagedResult.getTotalPages());
		request.getRequestDispatcher("/followedClubs.jsp").forward(request, response);
	}
}
