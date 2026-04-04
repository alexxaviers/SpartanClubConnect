package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class RsvpDAO {

    public static class EventView {
        private int eventId;
        private int clubId;
        private String clubName;
        private String title;
        private String description;
        private Date date;
        private Time startTime;
        private Time endTime;
        private String location;
        private Integer capacity;
        private int goingCount;
        private boolean userRsvped;

        public int getEventId() {
            return eventId;
        }

        public void setEventId(int eventId) {
            this.eventId = eventId;
        }

        public int getClubId() {
            return clubId;
        }

        public void setClubId(int clubId) {
            this.clubId = clubId;
        }

        public String getClubName() {
            return clubName;
        }

        public void setClubName(String clubName) {
            this.clubName = clubName;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public Date getDate() {
            return date;
        }

        public void setDate(Date date) {
            this.date = date;
        }

        public Time getStartTime() {
            return startTime;
        }

        public void setStartTime(Time startTime) {
            this.startTime = startTime;
        }

        public Time getEndTime() {
            return endTime;
        }

        public void setEndTime(Time endTime) {
            this.endTime = endTime;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public Integer getCapacity() {
            return capacity;
        }

        public void setCapacity(Integer capacity) {
            this.capacity = capacity;
        }

        public int getGoingCount() {
            return goingCount;
        }

        public void setGoingCount(int goingCount) {
            this.goingCount = goingCount;
        }

        public boolean isUserRsvped() {
            return userRsvped;
        }

        public void setUserRsvped(boolean userRsvped) {
            this.userRsvped = userRsvped;
        }

        public boolean isFull() {
            return capacity != null && goingCount >= capacity;
        }
    }

    public static class AttendeeView {
        private int userId;
        private String fullName;
        private String email;
        private Timestamp rsvpTime;

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public Timestamp getRsvpTime() {
            return rsvpTime;
        }

        public void setRsvpTime(Timestamp rsvpTime) {
            this.rsvpTime = rsvpTime;
        }
    }

    public List<EventView> getAllEventsForUser(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.capacity, " +
                "(SELECT COUNT(*) FROM RSVPs rc WHERE rc.event_id = e.event_id AND rc.status = 'Going') AS going_count, " +
                "CASE WHEN r.user_id IS NULL THEN 0 ELSE 1 END AS has_rsvp " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? AND r.status = 'Going' " +
                "WHERE e.is_active = TRUE " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<EventView> events = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapEventRow(rs));
                }
            }
        }

        return events;
    }

    public EventView getEventById(int eventId, int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.capacity, " +
                "(SELECT COUNT(*) FROM RSVPs rc WHERE rc.event_id = e.event_id AND rc.status = 'Going') AS going_count, " +
                "CASE WHEN r.user_id IS NULL THEN 0 ELSE 1 END AS has_rsvp " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? AND r.status = 'Going' " +
                "WHERE e.event_id = ? AND e.is_active = TRUE";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapEventRow(rs);
                }
            }
        }

        return null;
    }

    public boolean hasActiveRsvp(int userId, int eventId) throws SQLException {
        String sql = "SELECT 1 FROM RSVPs WHERE user_id = ? AND event_id = ? AND status = 'Going' LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean createRsvp(int userId, int eventId) throws SQLException {
        String sql = "INSERT INTO RSVPs (user_id, event_id, status) VALUES (?, ?, 'Going')";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteRsvp(int userId, int eventId) throws SQLException {
        String sql = "DELETE FROM RSVPs WHERE user_id = ? AND event_id = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<EventView> getMyUpcomingRsvps(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.capacity, " +
                "(SELECT COUNT(*) FROM RSVPs rc WHERE rc.event_id = e.event_id AND rc.status = 'Going') AS going_count, " +
                "1 AS has_rsvp " +
                "FROM RSVPs r " +
                "JOIN Events e ON e.event_id = r.event_id " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "WHERE r.user_id = ? AND r.status = 'Going' AND e.is_active = TRUE AND e.date >= CURDATE() " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<EventView> events = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapEventRow(rs));
                }
            }
        }

        return events;
    }

    public boolean canOfficerViewAttendees(int officerUserId, int eventId) throws SQLException {
        String sql = "SELECT 1 " +
                "FROM Events e " +
                "JOIN Manages m ON m.club_id = e.club_id " +
                "WHERE e.event_id = ? AND m.user_id = ? " +
                "LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, officerUserId);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<AttendeeView> getAttendeesForEvent(int eventId) throws SQLException {
        String sql = "SELECT u.user_id, u.full_name, u.email, r.rsvp_time " +
                "FROM RSVPs r " +
                "JOIN Users u ON u.user_id = r.user_id " +
                "WHERE r.event_id = ? AND r.status = 'Going' " +
                "ORDER BY r.rsvp_time ASC";

        List<AttendeeView> attendees = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AttendeeView attendee = new AttendeeView();
                    attendee.setUserId(rs.getInt("user_id"));
                    attendee.setFullName(rs.getString("full_name"));
                    attendee.setEmail(rs.getString("email"));
                    attendee.setRsvpTime(rs.getTimestamp("rsvp_time"));
                    attendees.add(attendee);
                }
            }
        }

        return attendees;
    }

    private EventView mapEventRow(ResultSet rs) throws SQLException {
        EventView event = new EventView();
        event.setEventId(rs.getInt("event_id"));
        event.setClubId(rs.getInt("club_id"));
        event.setClubName(rs.getString("club_name"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setDate(rs.getDate("date"));
        event.setStartTime(rs.getTime("start_time"));
        event.setEndTime(rs.getTime("end_time"));
        event.setLocation(rs.getString("location"));

        int capacity = rs.getInt("capacity");
        if (rs.wasNull()) {
            event.setCapacity(null);
        } else {
            event.setCapacity(capacity);
        }

        event.setGoingCount(rs.getInt("going_count"));
        event.setUserRsvped(rs.getInt("has_rsvp") == 1);
        return event;
    }
}
