<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String queryString = request.getQueryString();
    String destination = ctx + "/officer-event";
    if (queryString != null && !queryString.isEmpty()) {
        destination += "?" + queryString;
    }
    response.sendRedirect(destination);
%>
