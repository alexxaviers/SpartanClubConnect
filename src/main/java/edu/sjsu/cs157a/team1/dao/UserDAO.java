package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.User;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findByEmail(String email) {
        String sql =
                "SELECT user_id, full_name, email, password_hash, is_active " +
                        "FROM Users " +
                        "WHERE email = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

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

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean userHasRole(int userId, String roleName) {
        String sql =
                "SELECT 1 " +
                        "FROM UserRoles ur " +
                        "JOIN Roles r ON ur.role_id = r.role_id " +
                        "WHERE ur.user_id = ? AND r.role_name = ? " +
                        "LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, roleName);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int createUser(User user) {
        String userSql =
                "INSERT INTO Users (full_name, email, password_hash, is_active) " +
                        "VALUES (?, ?, ?, ?)";

        String userRoleSql =
                "INSERT INTO UserRoles (user_id, role_id) " +
                        "VALUES (?, ?)";

        Connection conn = null;

        try {
            conn = DbUtil.getConnection();
            conn.setAutoCommit(false);

            int newUserId = -1;

            try (PreparedStatement userStmt = conn.prepareStatement(
                    userSql,
                    PreparedStatement.RETURN_GENERATED_KEYS)) {

                userStmt.setString(1, user.getFullName());
                userStmt.setString(2, user.getEmail());
                userStmt.setString(3, user.getPasswordHash());
                userStmt.setBoolean(4, true);

                int rowsInserted = userStmt.executeUpdate();
                if (rowsInserted == 0) {
                    conn.rollback();
                    return -1;
                }

                try (ResultSet generatedKeys = userStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newUserId = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            try (PreparedStatement roleStmt = conn.prepareStatement(userRoleSql)) {
                roleStmt.setInt(1, newUserId);
                roleStmt.setInt(2, 1);

                int roleRows = roleStmt.executeUpdate();
                if (roleRows == 0) {
                    conn.rollback();
                    return -1;
                }
            }

            conn.commit();
            return newUserId;

        } catch (SQLException e) {
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            return -1;

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }
}
