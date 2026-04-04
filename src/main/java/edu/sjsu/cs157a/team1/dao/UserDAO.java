package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.User;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public User findByEmail(String email) {
        String sql = "SELECT user_id, full_name, email, password_hash, created_at, is_active " +
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
                    return user;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createUser(User user) {
        String userSql = "INSERT INTO Users (full_name, email, password_hash, is_active) " +
                "VALUES (?, ?, ?, ?)";
        String roleSql = "INSERT INTO UserRoles (user_id, role_id) VALUES (?, ?)";

        try (Connection conn = DbUtil.getConnection()) {
            conn.setAutoCommit(false);

            int newUserId;

            try (PreparedStatement userStmt = conn.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                userStmt.setString(1, user.getFullName());
                userStmt.setString(2, user.getEmail());
                userStmt.setString(3, user.getPasswordHash());
                userStmt.setBoolean(4, true);

                int rowsInserted = userStmt.executeUpdate();
                if (rowsInserted == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet generatedKeys = userStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newUserId = generatedKeys.getInt(1);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement roleStmt = conn.prepareStatement(roleSql)) {
                roleStmt.setInt(1, newUserId);
                roleStmt.setInt(2, 1); // Student role_id = 1
                roleStmt.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
