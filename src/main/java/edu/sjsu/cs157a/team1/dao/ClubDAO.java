package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.Club;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ClubDAO {

    public boolean nameExistsNormalized(String name) {
        if (name == null) {
            return false;
        }
        String sql = ""
                + "SELECT 1 "
                + "FROM Clubs "
                + "WHERE LOWER(TRIM(club_name)) = LOWER(TRIM(?)) "
                + "LIMIT 1";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean nameExistsNormalizedExcludingClub(String name, int excludeClubId) {
        if (name == null) {
            return false;
        }
        String sql = ""
                + "SELECT 1 "
                + "FROM Clubs "
                + "WHERE LOWER(TRIM(club_name)) = LOWER(TRIM(?)) "
                + "  AND club_id <> ? "
                + "LIMIT 1";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setInt(2, excludeClubId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Club findById(int clubId) {
        String sql = ""
                + clubSelectBase()
                + "FROM Clubs c "
                + "WHERE c.club_id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isOfficer(int clubId, int userId) {
        String sql = ""
                + "SELECT 1 "
                + "FROM Manages "
                + "WHERE club_id = ? "
                + "  AND user_id = ? "
                + "LIMIT 1";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, clubId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public Integer createClub(Club club, int creatorUserId) {
        String insertClub = ""
                + "INSERT INTO Clubs (club_name, description, contact_email, meeting_info) "
                + "VALUES (?, ?, ?, ?)";
        String insertManage = ""
                + "INSERT INTO Manages (user_id, club_id) "
                + "VALUES (?, ?)";

        try (Connection conn = DbUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int clubId;
                try (PreparedStatement stmt = conn.prepareStatement(insertClub, Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, club.getName().trim());
                    stmt.setString(2, nullIfBlank(club.getDescription()));
                    stmt.setString(3, nullIfBlank(club.getContactEmail()));
                    stmt.setString(4, nullIfBlank(club.getMeetingInfo()));
                    if (stmt.executeUpdate() == 0) {
                        conn.rollback();
                        return null;
                    }
                    try (ResultSet keys = stmt.getGeneratedKeys()) {
                        if (!keys.next()) {
                            conn.rollback();
                            return null;
                        }
                        clubId = keys.getInt(1);
                    }
                }
                try (PreparedStatement m = conn.prepareStatement(insertManage)) {
                    m.setInt(1, creatorUserId);
                    m.setInt(2, clubId);
                    m.executeUpdate();
                }
                replaceClubCategories(conn, clubId, club.getCategory());
                conn.commit();
                return clubId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateClub(Club club) {
        String sql = ""
                + "UPDATE Clubs "
                + "SET club_name = ?, "
                + "    description = ?, "
                + "    contact_email = ?, "
                + "    meeting_info = ? "
                + "WHERE club_id = ?";
        try (Connection conn = DbUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, club.getName().trim());
                    stmt.setString(2, nullIfBlank(club.getDescription()));
                    stmt.setString(3, nullIfBlank(club.getContactEmail()));
                    stmt.setString(4, nullIfBlank(club.getMeetingInfo()));
                    stmt.setInt(5, club.getClubId());
                    if (stmt.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                replaceClubCategories(conn, club.getClubId(), club.getCategory());
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Club> searchClubs(String keyword, String categoryFilter, String sort) {
        StringBuilder sql = new StringBuilder(clubSelectBase());
        sql.append("FROM Clubs c ");
        sql.append("WHERE 1 = 1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String like = "%" + keyword.trim() + "%";
            sql.append("AND ( ");
            sql.append("    c.club_name LIKE ? ");
            sql.append("    OR c.description LIKE ? ");
            sql.append("    OR EXISTS ( ");
            sql.append("        SELECT 1 ");
            sql.append("        FROM ClubCategoryMaps ccmk ");
            sql.append("        JOIN ClubCategories cck ");
            sql.append("          ON cck.category_id = ccmk.category_id ");
            sql.append("        WHERE ccmk.club_id = c.club_id ");
            sql.append("          AND cck.category_name LIKE ? ");
            sql.append("    ) ");
            sql.append(") ");
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            sql.append("AND EXISTS ( ");
            sql.append("    SELECT 1 ");
            sql.append("    FROM ClubCategoryMaps ccmf ");
            sql.append("    JOIN ClubCategories ccf ");
            sql.append("      ON ccf.category_id = ccmf.category_id ");
            sql.append("    WHERE ccmf.club_id = c.club_id ");
            sql.append("      AND ccf.category_name LIKE ? ");
            sql.append(") ");
            params.add("%" + categoryFilter.trim() + "%");
        }

        if ("name_desc".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY c.club_name DESC ");
        } else {
            sql.append("ORDER BY c.club_name ASC ");
        }

        List<Club> list = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClub(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private static String clubSelectBase() {
        return ""
                + "SELECT "
                + "    c.club_id, "
                + "    c.club_name, "
                + "    c.description, "
                + "    c.contact_email, "
                + "    c.meeting_info, "
                + "    c.created_at, "
                + "    ( "
                + "        SELECT u.full_name "
                + "        FROM Manages m "
                + "        JOIN Users u ON u.user_id = m.user_id "
                + "        WHERE m.club_id = c.club_id "
                + "        ORDER BY m.assigned_at ASC "
                + "        LIMIT 1 "
                + "    ) AS manager_full_name, "
                + "    ( "
                + "        SELECT GROUP_CONCAT(cc.category_name ORDER BY cc.category_name SEPARATOR ', ') "
                + "        FROM ClubCategoryMaps ccm "
                + "        JOIN ClubCategories cc ON cc.category_id = ccm.category_id "
                + "        WHERE ccm.club_id = c.club_id "
                + "    ) AS category_list ";
    }

    private static void replaceClubCategories(Connection conn, int clubId, String categoryLabel) throws SQLException {
        String deleteMaps = ""
                + "DELETE FROM ClubCategoryMaps "
                + "WHERE club_id = ?";
        try (PreparedStatement del = conn.prepareStatement(deleteMaps)) {
            del.setInt(1, clubId);
            del.executeUpdate();
        }
        if (categoryLabel == null || categoryLabel.trim().isEmpty()) {
            return;
        }
        int categoryId = findOrCreateCategory(conn, categoryLabel.trim());
        String insertMap = ""
                + "INSERT INTO ClubCategoryMaps (club_id, category_id) "
                + "VALUES (?, ?)";
        try (PreparedStatement ins = conn.prepareStatement(insertMap)) {
            ins.setInt(1, clubId);
            ins.setInt(2, categoryId);
            ins.executeUpdate();
        }
    }

    private static int findOrCreateCategory(Connection conn, String name) throws SQLException {
        String selectCategory = ""
                + "SELECT category_id "
                + "FROM ClubCategories "
                + "WHERE category_name = ?";
        try (PreparedStatement sel = conn.prepareStatement(selectCategory)) {
            sel.setString(1, name);
            try (ResultSet rs = sel.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        String insertCategory = ""
                + "INSERT INTO ClubCategories (category_name) "
                + "VALUES (?)";
        try (PreparedStatement ins = conn.prepareStatement(insertCategory, Statement.RETURN_GENERATED_KEYS)) {
            ins.setString(1, name);
            ins.executeUpdate();
            try (ResultSet keys = ins.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("No generated key for ClubCategories");
                }
                return keys.getInt(1);
            }
        }
    }

    private static Club mapClub(ResultSet rs) throws SQLException {
        Club c = new Club();
        c.setClubId(rs.getInt("club_id"));
        c.setName(rs.getString("club_name"));
        c.setDescription(rs.getString("description"));
        c.setCategory(rs.getString("category_list"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setMeetingInfo(rs.getString("meeting_info"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setManagerFullName(rs.getString("manager_full_name"));
        return c;
    }

    private static String nullIfBlank(String s) {
        if (s == null) {
            return null;
        }
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}