package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.model.Event;
import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getAllEventsForAdmin() throws SQLException {
        String sql = """
                SELECT
                    e.event_id,
                    e.title,
                    e.description,
                    e.date,
                    e.start_time,
                    e.end_time,
                    e.location,
                    e.capacity,
                    e.image_url,
                    e.created_at,
                    e.is_active,
                    e.club_id,
                    e.created_by,
                    c.club_name,
                    u.full_name AS creator_name
                FROM Events e
                JOIN Clubs c ON e.club_id = c.club_id
                JOIN Users u ON e.created_by = u.user_id
                ORDER BY e.date DESC, e.start_time DESC
                """;

        List<Event> events = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                events.add(mapRow(rs));
            }
        }

        return events;
    }

    public Event getEventById(int eventId) throws SQLException {
        String sql = """
                SELECT
                    e.event_id,
                    e.title,
                    e.description,
                    e.date,
                    e.start_time,
                    e.end_time,
                    e.location,
                    e.capacity,
                    e.image_url,
                    e.created_at,
                    e.is_active,
                    e.club_id,
                    e.created_by,
                    c.club_name,
                    u.full_name AS creator_name
                FROM Events e
                JOIN Clubs c ON e.club_id = c.club_id
                JOIN Users u ON e.created_by = u.user_id
                WHERE e.event_id = ?
                LIMIT 1
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    public boolean setEventActiveStatus(int eventId, boolean isActive) throws SQLException {
        String sql = """
                UPDATE Events
                SET is_active = ?
                WHERE event_id = ?
                """;

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, isActive);
            stmt.setInt(2, eventId);

            return stmt.executeUpdate() == 1;
        }
    }

    public List<Event> getApprovedEvents() throws SQLException {
        String sql = """
                SELECT
                    e.event_id,
                    e.title,
                    e.description,
                    e.date,
                    e.start_time,
                    e.end_time,
                    e.location,
                    e.capacity,
                    e.image_url,
                    e.created_at,
                    e.is_active,
                    e.club_id,
                    e.created_by
                FROM Events e
                WHERE e.is_active = TRUE
                ORDER BY e.date ASC, e.start_time ASC
                """;

        List<Event> events = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setTitle(rs.getString("title"));
                event.setDescription(rs.getString("description"));
                event.setDate(rs.getDate("date"));
                event.setStartTime(rs.getTime("start_time"));
                event.setEndTime(rs.getTime("end_time"));
                event.setLocation(rs.getString("location"));
                event.setCapacity((Integer) rs.getObject("capacity"));
                event.setImageUrl(rs.getString("image_url"));
                event.setCreatedAt(rs.getTimestamp("created_at"));
                event.setActive(rs.getBoolean("is_active"));
                event.setClubId(rs.getInt("club_id"));
                event.setCreatedBy(rs.getInt("created_by"));
                events.add(event);
            }
        }

        return events;
    }

    public boolean userHasRole(int userId, String roleName) throws SQLException {
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

    private Event mapRow(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventId(rs.getInt("event_id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setDate(rs.getDate("date"));
        event.setStartTime(rs.getTime("start_time"));
        event.setEndTime(rs.getTime("end_time"));
        event.setLocation(rs.getString("location"));
        event.setCapacity((Integer) rs.getObject("capacity"));
        event.setImageUrl(rs.getString("image_url"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        event.setActive(rs.getBoolean("is_active"));
        event.setClubId(rs.getInt("club_id"));
        event.setCreatedBy(rs.getInt("created_by"));
        event.setClubName(rs.getString("club_name"));
        event.setCreatorName(rs.getString("creator_name"));
        return event;
    }
}
