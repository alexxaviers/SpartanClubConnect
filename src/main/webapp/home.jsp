<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    response.sendRedirect(ctx + "/dashboard.jsp");
%>
