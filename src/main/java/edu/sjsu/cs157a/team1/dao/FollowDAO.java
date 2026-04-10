package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.Club;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FollowDAO{
	
	public boolean follow(int userId, int clubId) {
		String sql = "INSERT INTO Follows (user_id, club_id) VALUES (?, ?)";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)){
			stmt.setInt(1, userId);
			stmt.setInt(2, clubId);
			return stmt.executeUpdate() == 1;
		}
		catch (SQLException e) {
			if(e.getErrorCode() == 1062 || "23000".equals(e.getSQLState())) {
				return false;
			}
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean unfollow(int userId, int clubId) {
		String sql = "DELETE FROM Follows WHERE user_id = ? AND club_id = ?";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)){
			stmt.setInt(1, userId);
			stmt.setInt(2, clubId);
			return stmt.executeUpdate() >= 1;
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public int countFollowersForClub(int clubId) {
		String sql = "SELECT COUNT(*) AS cnt FROM Follows WHERE club_id = ?";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)){
			stmt.setInt(1, clubId);
			try(ResultSet rs = stmt.executeQuery()){
				if (rs.next()) {
					return rs.getInt("cnt");
				}
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	public boolean isFollowing(int userId, int clubId) {
		String sql = "SELECT 1 FROM Follows WHERE user_id = ? AND club_id = ? LIMIT 1";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)){
			stmt.setInt(1, userId);
			stmt.setInt(2, clubId);
			try(ResultSet rs = stmt.executeQuery()){
				return rs.next();
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public List<Club> getClubsFollowedByUser(int userId) {
        String sql = clubRowSelect()
                + "FROM Follows f "
                + "INNER JOIN Clubs c ON c.club_id = f.club_id "
                + "LEFT JOIN ClubCategoryMaps ccm ON ccm.club_id = c.club_id "
                + "LEFT JOIN ClubCategories cc ON cc.category_id = ccm.category_id "
                + "WHERE f.user_id = ? "
                + "ORDER BY f.followed_at DESC, c.club_name ASC, cc.category_name ASC";

        List<Club> list = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                Club pending = null;
                List<String> categoryParts = new ArrayList<>();
                while (rs.next()) {
                    int clubId = rs.getInt("club_id");
                    if (pending == null || clubId != pending.getClubId()) {
                        if (pending != null) {
                            applyCategoryList(pending, categoryParts);
                            list.add(pending);
                        }
                        pending = mapClub(rs);
                        categoryParts = new ArrayList<>();
                        addCategoryIfPresent(categoryParts, rs.getString("category_name"));
                    } else {
                        addCategoryIfPresent(categoryParts, rs.getString("category_name"));
                    }
                }
                if (pending != null) {
                    applyCategoryList(pending, categoryParts);
                    list.add(pending);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
	
	private static void addCategoryIfPresent(List<String> parts, String name) {
		if(name != null && !name.isEmpty()) {
			parts.add(name);
		}
	}
	
	private static void applyCategoryList(Club club, List<String> parts) {
		if(!parts.isEmpty()) {
			club.setCategory(String.join(", ", parts));
		}
	}
	
	private static String clubRowSelect() {
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
                + "    cc.category_name ";
    }

    private static Club mapClub(ResultSet rs) throws SQLException {
        Club c = new Club();
        c.setClubId(rs.getInt("club_id"));
        c.setName(rs.getString("club_name"));
        c.setDescription(rs.getString("description"));
        c.setCategory(null);
        c.setContactEmail(rs.getString("contact_email"));
        c.setMeetingInfo(rs.getString("meeting_info"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setManagerFullName(rs.getString("manager_full_name"));
        return c;
    }
}