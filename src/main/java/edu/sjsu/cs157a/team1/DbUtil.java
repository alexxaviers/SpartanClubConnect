package edu.sjsu.cs157a.team1;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DbUtil {
    private static Properties loadProps() throws Exception {
        try (InputStream in = DbUtil.class.getResourceAsStream("/db.properties")) {
            Properties p = new Properties();
            p.load(in);
            return p;
        }
    }

    public static void printStudents() throws Exception {
        Properties p = loadProps();
        String url = p.getProperty("jdbc.url");
        String user = p.getProperty("jdbc.user");
        String pass = p.getProperty("jdbc.pass");

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement("SELECT EventID, ClubID, title, eventDate, location FROM Events");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                System.out.println(
                        rs.getInt("EventID") + "  " +
                                rs.getInt("ClubID") + "  " +
                                rs.getString("title") + "  " +
                                rs.getTimestamp("eventDate") + "  " +
                                rs.getString("location")
                );
            }
        }
    }
}
