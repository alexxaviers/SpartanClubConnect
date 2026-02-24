package edu.sjsu.cs157a.team1;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;
import java.util.Properties;

@WebServlet("/events")
public class EventsServlet extends HttpServlet {

    private Properties loadDbProps() throws IOException {
        Properties props = new Properties();
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null)
                throw new FileNotFoundException("db.properties not found in classpath (src/main/resources)");
            props.load(in);
        }
        return props;
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.println("<html><body>");
            out.println("<h1>Events</h1>");

            Properties p = loadDbProps();
            String url = p.getProperty("jdbc.url");
            String user = p.getProperty("jdbc.user");
            String pass = p.getProperty("jdbc.pass");

            String sql = "SELECT EventID, ClubID, title, description, eventDate, location FROM Events";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, user, pass);
                     PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {
                    out.println("<table border='1' cellpadding='6' cellspacing='0'>");
                    out.println("<tr><th>EventID</th><th>ClubID</th><th>Title</th><th>Description</th><th>Date</th><th>Location</th></tr>");

                    int count = 0;
                    while (rs.next()) {
                        count++;
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("EventID") + "</td>");
                        out.println("<td>" + rs.getInt("ClubID") + "</td>");
                        out.println("<td>" + escape(rs.getString("title")) + "</td>");
                        out.println("<td>" + escape(rs.getString("description")) + "</td>");
                        out.println("<td>" + rs.getTimestamp("eventDate") + "</td>");
                        out.println("<td>" + escape(rs.getString("location")) + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");

                    out.println("<p>Total rows: " + count + "</p>");

                } catch (SQLException e) {
                    out.println("<h3>DB Error</h3>");
                    out.println("<pre>");
                    e.printStackTrace(out);
                    out.println("</pre>");
                }

                out.println("</body></html>");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
    }
}