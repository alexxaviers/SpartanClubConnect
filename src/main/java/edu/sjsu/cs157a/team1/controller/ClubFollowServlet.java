package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.FollowDAO;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class ClubFollowServlet extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
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
		String clubIdParam = request.getParameter("clubId");
		String action = request.getParameter("action");
		
		int clubId;
        try {
            clubId = Integer.parseInt(clubIdParam != null ? clubIdParam.trim() : "");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }
		
        String ctx = request.getContextPath();
        String back = ctx + "/club?id=" + clubId;
        
        FollowDAO followDAO = new FollowDAO();
        if ("unfollow".equalsIgnoreCase(action)){
        	followDAO.unfollow(userId, clubId);
        }
        else if ("follow".equalsIgnoreCase(action)) {
        	followDAO.follow(userId, clubId);
        }
        else {
        	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Action");
        	return;
        }
		
        if ("json".equals(request.getParameter("format"))) {
            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            int followerCount = followDAO.countFollowersForClub(clubId);
            boolean following = followDAO.isFollowing(userId, clubId);
            response.getWriter().print("{\"followerCount\":"
                    + followerCount
                    + ",\"isFollowing\":"
                    + following
                    + "}");
            return;
        }
        
        String returnTo = request.getParameter("returnTo");
        if("followedClubs".equals(returnTo)) {
        	response.sendRedirect(ctx + "/followedClubs");
        	return;
        }
        
        response.sendRedirect(back);
	}
}