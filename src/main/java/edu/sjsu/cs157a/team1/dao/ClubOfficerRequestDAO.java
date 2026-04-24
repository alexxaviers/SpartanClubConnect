package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.ClubOfficerRequest;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClubOfficerRequestDAO {

    public boolean hasPendingRequest(int userId) throws SQLException {
    	//Check user who are currently waiting for approval to become club officer
        String sql = """
                SELECT 1
                FROM ClubOfficerRequests
                WHERE user_id = ? AND status = 'Pending'
                LIMIT 1
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean createRequest(ClubOfficerRequest request) throws SQLException {
    	//Insert new club officer requests along with provided information from user
        String sql = """
                INSERT INTO ClubOfficerRequests
                (sjsu_id, club_name, justification, status, created_at, user_id)
                VALUES (?, ?, ?, 'Pending', NOW(), ?)
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, request.getSjsuId());
            stmt.setString(2, request.getClubName());
            stmt.setString(3, request.getJustification());
            stmt.setInt(4, request.getUserId());

            return stmt.executeUpdate() == 1;
        }
    }

    public boolean userHasRole(int userId, String roleName) throws SQLException {
    	//Map user to their roles such as 1 for student, 2 for club officer, and 3 for admin
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

    public List<ClubOfficerRequest> getPendingRequests() throws SQLException {
    	//Get a list of users who currently have a pending request
        String sql = """
            SELECT
                cor.request_id,
                cor.sjsu_id,
                cor.club_name,
                cor.justification,
                cor.status,
                cor.created_at,
                cor.user_id,
                cor.reviewed_by,
                cor.reviewed_at,
                u.full_name,
                u.email
            FROM ClubOfficerRequests cor
            JOIN Users u ON cor.user_id = u.user_id
            WHERE cor.status = 'Pending'
            ORDER BY cor.created_at ASC
            """;

        List<ClubOfficerRequest> requests = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ClubOfficerRequest request = new ClubOfficerRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setSjsuId(rs.getString("sjsu_id"));
                request.setClubName(rs.getString("club_name"));
                request.setJustification(rs.getString("justification"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setUserId(rs.getInt("user_id"));
                request.setRequesterName(rs.getString("full_name"));
                request.setRequesterEmail(rs.getString("email"));

                int reviewedBy = rs.getInt("reviewed_by");
                if (!rs.wasNull()) {
                    request.setReviewedBy(reviewedBy);
                }

                request.setReviewedAt(rs.getTimestamp("reviewed_at"));
                requests.add(request);
            }
        }

        return requests;
    }

    public Integer getRoleIdByName(String roleName) throws SQLException {
    	//Get name of roles that correspond to their role id
        String sql = """
                SELECT role_id
                FROM Roles
                WHERE role_name = ?
                LIMIT 1
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, roleName);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("role_id");
                }
                return null;
            }
        }
    }

    public boolean approveRequest(int requestId, int adminUserId) throws SQLException {
        Connection conn = null;

        try {
            conn = DbUtil.getConnection();
            conn.setAutoCommit(false);
            //Get pending club officer request from user for updating 
            String selectRequestSql = """
                    SELECT user_id
                    FROM ClubOfficerRequests
                    WHERE request_id = ? AND status = 'Pending'
                    FOR UPDATE
                    """;

            int targetUserId;

            try (PreparedStatement stmt = conn.prepareStatement(selectRequestSql)) {
                stmt.setInt(1, requestId);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    targetUserId = rs.getInt("user_id");
                }
            }

            Integer clubOfficerRoleId = null;
            //Get the role id that correspond to club officer, which is 2
            String findRoleSql = """
                    SELECT role_id
                    FROM Roles
                    WHERE role_name = 'Club Officer'
                    LIMIT 1
                    """;

            try (PreparedStatement stmt = conn.prepareStatement(findRoleSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    clubOfficerRoleId = rs.getInt("role_id");
                }
            }

            if (clubOfficerRoleId == null) {
                conn.rollback();
                throw new SQLException("Club Officer role does not exist in Roles table.");
            }
            //Update request from pending to approve and track the admin that approved the request
            String updateRequestSql = """
                    UPDATE ClubOfficerRequests
                    SET status = 'Approved',
                        reviewed_by = ?,
                        reviewed_at = NOW()
                    WHERE request_id = ? AND status = 'Pending'
                    """;

            try (PreparedStatement stmt = conn.prepareStatement(updateRequestSql)) {
                stmt.setInt(1, adminUserId);
                stmt.setInt(2, requestId);

                if (stmt.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }
            //Check the current role of the user 
            String checkUserRoleSql = """
                    SELECT 1
                    FROM UserRoles
                    WHERE user_id = ? AND role_id = ?
                    LIMIT 1
                    """;

            boolean alreadyHasRole;
            try (PreparedStatement stmt = conn.prepareStatement(checkUserRoleSql)) {
                stmt.setInt(1, targetUserId);
                stmt.setInt(2, clubOfficerRoleId);

                try (ResultSet rs = stmt.executeQuery()) {
                    alreadyHasRole = rs.next();
                }
            }

            if (!alreadyHasRole) {
            	//Change the role of the user from student to club officer
                String insertUserRoleSql = """
                        INSERT INTO UserRoles (user_id, role_id, assigned_at)
                        VALUES (?, ?, NOW())
                        """;

                try (PreparedStatement stmt = conn.prepareStatement(insertUserRoleSql)) {
                    stmt.setInt(1, targetUserId);
                    stmt.setInt(2, clubOfficerRoleId);
                    stmt.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean denyRequest(int requestId, int adminUserId) throws SQLException {
    	//Update the pending request to denied and track which admin reviewed it
        String sql = """
                UPDATE ClubOfficerRequests
                SET status = 'Denied',
                    reviewed_by = ?,
                    reviewed_at = NOW()
                WHERE request_id = ? AND status = 'Pending'
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, adminUserId);
            stmt.setInt(2, requestId);

            return stmt.executeUpdate() == 1;
        }
    }

    public List<ClubOfficerRequest> getReviewedRequests() throws SQLException {
    	//Get list of reviewed requests with status as approved or denied
        String sql = """
            SELECT
                cor.request_id,
                cor.sjsu_id,
                cor.club_name,
                cor.justification,
                cor.status,
                cor.created_at,
                cor.user_id,
                cor.reviewed_by,
                cor.reviewed_at,
                requester.full_name AS requester_name,
                requester.email AS requester_email,
                reviewer.full_name AS reviewer_name
            FROM ClubOfficerRequests cor
            JOIN Users requester ON cor.user_id = requester.user_id
            LEFT JOIN Users reviewer ON cor.reviewed_by = reviewer.user_id
            WHERE cor.status IN ('Approved', 'Denied')
            ORDER BY cor.reviewed_at DESC, cor.created_at DESC
            """;

        List<ClubOfficerRequest> requests = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ClubOfficerRequest request = new ClubOfficerRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setSjsuId(rs.getString("sjsu_id"));
                request.setClubName(rs.getString("club_name"));
                request.setJustification(rs.getString("justification"));
                request.setStatus(rs.getString("status"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setUserId(rs.getInt("user_id"));
                request.setRequesterName(rs.getString("requester_name"));
                request.setRequesterEmail(rs.getString("requester_email"));
                request.setReviewerName(rs.getString("reviewer_name"));

                int reviewedBy = rs.getInt("reviewed_by");
                if (!rs.wasNull()) {
                    request.setReviewedBy(reviewedBy);
                }

                request.setReviewedAt(rs.getTimestamp("reviewed_at"));
                requests.add(request);
            }
        }

        return requests;
    }
}
