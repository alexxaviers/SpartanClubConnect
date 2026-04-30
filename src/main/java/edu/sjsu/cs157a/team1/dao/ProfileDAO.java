package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ProfileDAO {

    public boolean updateProfile(int userId, String fullName, String passwordHash) {
        String sqlWithoutPassword = ""
                + "UPDATE Users "
                + "SET full_name = ? "
                + "WHERE user_id = ?";

        String sqlWithPassword = ""
                + "UPDATE Users "
                + "SET full_name = ?, "
                + "    password_hash = ? "
                + "WHERE user_id = ?";

        try (Connection conn = DbUtil.getConnection()) {
            if (passwordHash == null || passwordHash.trim().isEmpty()) {
                try (PreparedStatement stmt = conn.prepareStatement(sqlWithoutPassword)) {
                    stmt.setString(1, fullName);
                    stmt.setInt(2, userId);
                    return stmt.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement stmt = conn.prepareStatement(sqlWithPassword)) {
                    stmt.setString(1, fullName);
                    stmt.setString(2, passwordHash);
                    stmt.setInt(3, userId);
                    return stmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
