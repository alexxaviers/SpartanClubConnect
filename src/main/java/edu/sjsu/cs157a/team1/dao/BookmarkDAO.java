package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class BookmarkDAO{
	
	public boolean addBookmark(int userId, int eventId) throws SQLException{
		String sql = "INSERT INTO Bookmarks (user_id, event_id) VALUES (?,?)";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setInt(1, userId);
				stmt.setInt(2, eventId);
				return stmt.executeUpdate() == 1;
			
		} catch (SQLException e) {
			if(e.getErrorCode() == 1062) {
				return false;
			}
			throw e;
		}
	}
	
	public boolean removeBookmark(int userId, int eventId) throws SQLException{
		String sql = "DELETE FROM Bookmarks WHERE user_id = ? AND event_id = ?";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setInt(1, userId);
				stmt.setInt(2, eventId);
				return stmt.executeUpdate() > 0;
		}
	}
	
	public boolean isBookmarked(int userId, int eventId) throws SQLException{
		String sql = "SELECT 1 FROM Bookmarks WHERE user_id = ? AND event_id = ? LIMIT 1";
		try(Connection conn = DbUtil.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {
				stmt.setInt(1, userId);
				stmt.setInt(2, eventId);
				try(ResultSet rs = stmt.executeQuery()){
					return rs.next();
				}
		}
	}
    public Set<Integer> getBookmarkedEventIds(int userId) throws SQLException {
        String sql = "SELECT event_id FROM Bookmarks WHERE user_id = ?";
        Set<Integer> bookmarked = new HashSet<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookmarked.add(rs.getInt("event_id"));
                }
            }
        }
        return bookmarked;
    }

    public List<RsvpDAO.EventView> getBookmarkedUpcomingEvents(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.category, e.image_url, e.capacity, " +
                "COALESCE(rc.going_count, 0) AS going_count, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN 1 ELSE 0 END AS has_rsvp, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN r.status ELSE NULL END AS user_rsvp_status " +
                "FROM Bookmarks b " +
                "JOIN Events e ON e.event_id = b.event_id " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? " +
                "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
                "WHERE b.user_id = ? AND e.is_active = TRUE AND e.date >= CURDATE() " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<RsvpDAO.EventView> events = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapEventRow(rs));
                }
            }
        }

        return events;
    }

    private RsvpDAO.EventView mapEventRow(ResultSet rs) throws SQLException {
        RsvpDAO.EventView event = new RsvpDAO.EventView();
        event.setEventId(rs.getInt("event_id"));
        event.setClubId(rs.getInt("club_id"));
        event.setClubName(rs.getString("club_name"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setDate(rs.getDate("date"));
        event.setStartTime(rs.getTime("start_time"));
        event.setEndTime(rs.getTime("end_time"));
        event.setLocation(rs.getString("location"));
        event.setCategory(rs.getString("category"));
        event.setImageUrl(rs.getString("image_url"));

        int capacity = rs.getInt("capacity");
        if (rs.wasNull()) {
            event.setCapacity(null);
        } else {
            event.setCapacity(capacity);
        }

        event.setGoingCount(rs.getInt("going_count"));
        event.setUserRsvped(rs.getInt("has_rsvp") == 1);
        event.setUserRsvpStatus(rs.getString("user_rsvp_status"));
        return event;
    }
}