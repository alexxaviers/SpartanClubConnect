package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.User;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO {


    public List<User> getAllUsers() throws SQLException {
    	//Get informations of all users and order by user_id
        String sql = """
                SELECT user_id, full_name, email, password_hash, is_active
                FROM Users
                ORDER BY user_id ASC
                """;

        List<User> users = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setActive(rs.getBoolean("is_active"));
                users.add(user);
            }
        }

        return users;
    }

    public User getUserById(int userId) throws SQLException {
    	//Get information of a user based on their user id.
        String sql = """
                SELECT user_id, full_name, email, password_hash, is_active
                FROM Users
                WHERE user_id = ?
                LIMIT 1
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setActive(rs.getBoolean("is_active"));
                    return user;
                }
            }
        }

        return null;
    }

    public boolean updateAccountStatus(int userId, boolean isActive) throws SQLException {
    	//Update the status of the user account between active and inactive.
        String sql = """
                UPDATE Users
                SET is_active = ?
                WHERE user_id = ?
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, isActive);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() == 1;
        }
    }

    public boolean deactivateAccountWithAudit(int targetUserId, int adminUserId, String reason) throws SQLException {
        String sql = """
                UPDATE Users
                SET is_active = FALSE,
                    deactivated_by = ?,
                    deactivated_at = NOW(),
                    deactivation_reason = ?
                WHERE user_id = ?
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, adminUserId);
            stmt.setString(2, normalizeReason(reason));
            stmt.setInt(3, targetUserId);

            return stmt.executeUpdate() == 1;
        }
    }

    public boolean reactivateAccountAndClearAudit(int targetUserId) throws SQLException {
        String sql = """
                UPDATE Users
                SET is_active = TRUE,
                    deactivated_by = NULL,
                    deactivated_at = NULL,
                    deactivation_reason = NULL
                WHERE user_id = ?
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, targetUserId);
            return stmt.executeUpdate() == 1;
        }
    }


    public boolean userHasRole(int userId, String roleName) throws SQLException {
    	 //Get the role to the user based on their user id and role id
        String sql = """
                SELECT 1
                FROM UserRoles ur
                JOIN Roles r ON ur.role_id = r.role_id
                WHERE ur.user_id = ? AND r.role_name = ?
                LIMIT 1
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, roleName);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private String normalizeReason(String reason) {
        if (reason == null) {
            return null;
        }
        String trimmed = reason.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
