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

    public static class RegisterResult {
        private final boolean saved;
        private final String status;
        private final String error;

        private RegisterResult(boolean saved, String status, String error) {
            this.saved = saved;
            this.status = status;
            this.error = error;
        }

        public static RegisterResult saved(String status) {
            return new RegisterResult(true, status, null);
        }

        public static RegisterResult failed(String error) {
            return new RegisterResult(false, null, error);
        }

        public boolean isSaved() {
            return saved;
        }

        public String getStatus() {
            return status;
        }

        public String getError() {
            return error;
        }
    }

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
        private String category;
        private String imageUrl;
        private Integer capacity;
        private int goingCount;
        private boolean userRsvped;
        private String userRsvpStatus;

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

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
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

        public String getUserRsvpStatus() {
            return userRsvpStatus;
        }

        public void setUserRsvpStatus(String userRsvpStatus) {
            this.userRsvpStatus = userRsvpStatus;
        }

        public boolean isFull() {
            return capacity != null && goingCount >= capacity;
        }
    }

    public static class AttendeeView {
        private int userId;
        private String fullName;
        private String email;
        private String status;
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

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Timestamp getRsvpTime() {
            return rsvpTime;
        }

        public void setRsvpTime(Timestamp rsvpTime) {
            this.rsvpTime = rsvpTime;
        }
    }
    //We are using COALESCE to get the count of those who are going, if there are none then 
    //just have it as 0
    public List<EventView> getAllEventsForUser(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
            "e.location, e.category, e.image_url, e.capacity, " +
            "COALESCE(rc.going_count, 0) AS going_count, " +
            "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN 1 ELSE 0 END AS has_rsvp, " +
            "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN r.status ELSE NULL END AS user_rsvp_status " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
            "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? " +
            "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
            "WHERE e.is_active = TRUE AND e.date >= CURDATE() " +
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
    
    public List<EventView> getFollowedClubEventsForUser(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.category, e.image_url, e.capacity, " +
                "COALESCE(rc.going_count, 0) AS going_count, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN 1 ELSE 0 END AS has_rsvp, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN r.status ELSE NULL END AS user_rsvp_status " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "JOIN Follows f ON f.club_id = e.club_id AND f.user_id = ? " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? " +
                "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
                "WHERE e.is_active = TRUE AND e.date >= CURDATE() " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<EventView> events = new ArrayList<>();
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
    
    public EventView getEventById(int eventId, int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.category, e.image_url, e.capacity, " +
                "COALESCE(rc.going_count, 0) AS going_count, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN 1 ELSE 0 END AS has_rsvp, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN r.status ELSE NULL END AS user_rsvp_status " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? " +
                "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
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
        String sql = "SELECT 1 FROM RSVPs WHERE user_id = ? AND event_id = ? AND status IN ('Going', 'Waitlisted') LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public String getRsvpStatus(int userId, int eventId) throws SQLException {
        String sql = "SELECT status FROM RSVPs WHERE user_id = ? AND event_id = ? LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }
        }

        return null;
    }

    public boolean upsertRsvpStatus(int userId, int eventId, String status) throws SQLException {
        String sql = "INSERT INTO RSVPs (user_id, event_id, status, rsvp_time) VALUES (?, ?, ?, CURRENT_TIMESTAMP) " +
                "ON DUPLICATE KEY UPDATE status = VALUES(status), rsvp_time = CURRENT_TIMESTAMP";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            stmt.setString(3, status);
            return stmt.executeUpdate() > 0;
        }
    }

    public RegisterResult registerUserAtomically(int userId, int eventId) throws SQLException {
        String lockEventSql = "SELECT date, end_time, capacity, is_active FROM Events WHERE event_id = ? FOR UPDATE";
        String userStatusSql = "SELECT status FROM RSVPs WHERE user_id = ? AND event_id = ? LIMIT 1 FOR UPDATE";
        String goingCountSql = "SELECT COUNT(*) AS going_count FROM RSVPs WHERE event_id = ? AND status = 'Going'";
        String upsertSql = "INSERT INTO RSVPs (user_id, event_id, status, rsvp_time) VALUES (?, ?, ?, CURRENT_TIMESTAMP) " +
                "ON DUPLICATE KEY UPDATE status = VALUES(status), rsvp_time = CURRENT_TIMESTAMP";

        try (Connection conn = DbUtil.getConnection()) {
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                Date eventDate;
                Time eventEndTime;
                Integer capacity;

                try (PreparedStatement lockStmt = conn.prepareStatement(lockEventSql)) {
                    lockStmt.setInt(1, eventId);
                    try (ResultSet rs = lockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            conn.setAutoCommit(originalAutoCommit);
                            return RegisterResult.failed("Event not found");
                        }

                        if (!rs.getBoolean("is_active")) {
                            conn.rollback();
                            conn.setAutoCommit(originalAutoCommit);
                            return RegisterResult.failed("Event not found");
                        }

                        eventDate = rs.getDate("date");
                        eventEndTime = rs.getTime("end_time");
                        int capacityValue = rs.getInt("capacity");
                        capacity = rs.wasNull() ? null : capacityValue;
                    }
                }

                if (eventDate != null) {
                    java.time.LocalDate today = java.time.LocalDate.now();
                    java.time.LocalDate eventLocalDate = eventDate.toLocalDate();
                    java.time.LocalTime now = java.time.LocalTime.now();
                    boolean eventEnded = eventEndTime != null && !now.isBefore(eventEndTime.toLocalTime());

                    if (eventLocalDate.isBefore(today) || (eventLocalDate.isEqual(today) && eventEnded)) {
                        conn.rollback();
                        conn.setAutoCommit(originalAutoCommit);
                        return RegisterResult.failed("Cannot RSVP to a past event");
                    }
                }

                try (PreparedStatement userStatusStmt = conn.prepareStatement(userStatusSql)) {
                    userStatusStmt.setInt(1, userId);
                    userStatusStmt.setInt(2, eventId);
                    try (ResultSet rs = userStatusStmt.executeQuery()) {
                        if (rs.next()) {
                            String existingStatus = rs.getString("status");
                            if ("Going".equals(existingStatus) || "Waitlisted".equals(existingStatus)) {
                                conn.rollback();
                                conn.setAutoCommit(originalAutoCommit);
                                return RegisterResult.failed("Already RSVPed");
                            }
                        }
                    }
                }

                int goingCount;
                try (PreparedStatement countStmt = conn.prepareStatement(goingCountSql)) {
                    countStmt.setInt(1, eventId);
                    try (ResultSet rs = countStmt.executeQuery()) {
                        rs.next();
                        goingCount = rs.getInt("going_count");
                    }
                }

                String targetStatus = (capacity != null && goingCount >= capacity) ? "Waitlisted" : "Going";

                boolean saved;
                try (PreparedStatement upsertStmt = conn.prepareStatement(upsertSql)) {
                    upsertStmt.setInt(1, userId);
                    upsertStmt.setInt(2, eventId);
                    upsertStmt.setString(3, targetStatus);
                    saved = upsertStmt.executeUpdate() > 0;
                }

                if (!saved) {
                    conn.rollback();
                    conn.setAutoCommit(originalAutoCommit);
                    return RegisterResult.failed("Could not RSVP");
                }

                conn.commit();
                conn.setAutoCommit(originalAutoCommit);
                return RegisterResult.saved(targetStatus);
            } catch (SQLException e) {
                conn.rollback();
                conn.setAutoCommit(originalAutoCommit);
                throw e;
            }
        }
    }

    public boolean cancelRsvp(int userId, int eventId) throws SQLException {
        String sql = "UPDATE RSVPs SET status = 'Cancelled' WHERE user_id = ? AND event_id = ? AND status IN ('Going', 'Waitlisted')";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean cancelAndPromoteAtomically(int userId, int eventId) throws SQLException {
        String lockEventSql = "SELECT capacity FROM Events WHERE event_id = ? FOR UPDATE";
        String getUserStatusSql = "SELECT status FROM RSVPs WHERE user_id = ? AND event_id = ? LIMIT 1 FOR UPDATE";
        String cancelSql = "UPDATE RSVPs SET status = 'Cancelled' WHERE user_id = ? AND event_id = ? AND status IN ('Going', 'Waitlisted')";
        String goingCountSql = "SELECT COUNT(*) AS going_count FROM RSVPs WHERE event_id = ? AND status = 'Going'";
        String promoteSql = "UPDATE RSVPs target " +
                "JOIN (SELECT user_id FROM RSVPs WHERE event_id = ? AND status = 'Waitlisted' ORDER BY rsvp_time ASC LIMIT 1) candidate " +
                "ON target.user_id = candidate.user_id AND target.event_id = ? " +
                "SET target.status = 'Going', target.rsvp_time = CURRENT_TIMESTAMP";

        try (Connection conn = DbUtil.getConnection()) {
            boolean originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                Integer capacity;
                try (PreparedStatement lockStmt = conn.prepareStatement(lockEventSql)) {
                    lockStmt.setInt(1, eventId);
                    try (ResultSet rs = lockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            conn.setAutoCommit(originalAutoCommit);
                            return false;
                        }
                        int capValue = rs.getInt("capacity");
                        capacity = rs.wasNull() ? null : capValue;
                    }
                }

                String oldStatus;
                try (PreparedStatement statusStmt = conn.prepareStatement(getUserStatusSql)) {
                    statusStmt.setInt(1, userId);
                    statusStmt.setInt(2, eventId);
                    try (ResultSet rs = statusStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            conn.setAutoCommit(originalAutoCommit);
                            return false;
                        }
                        oldStatus = rs.getString("status");
                    }
                }

                if (!"Going".equals(oldStatus) && !"Waitlisted".equals(oldStatus)) {
                    conn.rollback();
                    conn.setAutoCommit(originalAutoCommit);
                    return false;
                }

                int cancelledRows;
                try (PreparedStatement cancelStmt = conn.prepareStatement(cancelSql)) {
                    cancelStmt.setInt(1, userId);
                    cancelStmt.setInt(2, eventId);
                    cancelledRows = cancelStmt.executeUpdate();
                }

                if (cancelledRows == 0) {
                    conn.rollback();
                    conn.setAutoCommit(originalAutoCommit);
                    return false;
                }

                if ("Going".equals(oldStatus)) {
                    int goingCount;
                    try (PreparedStatement countStmt = conn.prepareStatement(goingCountSql)) {
                        countStmt.setInt(1, eventId);
                        try (ResultSet rs = countStmt.executeQuery()) {
                            rs.next();
                            goingCount = rs.getInt("going_count");
                        }
                    }

                    if (capacity == null || goingCount < capacity) {
                        try (PreparedStatement promoteStmt = conn.prepareStatement(promoteSql)) {
                            promoteStmt.setInt(1, eventId);
                            promoteStmt.setInt(2, eventId);
                            promoteStmt.executeUpdate();
                        }
                    }
                }

                conn.commit();
                conn.setAutoCommit(originalAutoCommit);
                return true;
            } catch (SQLException e) {
                conn.rollback();
                conn.setAutoCommit(originalAutoCommit);
                throw e;
            }
        }
    }

    public List<EventView> getMyUpcomingRsvps(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.category, e.image_url, e.capacity, " +
                "COALESCE(rc.going_count, 0) AS going_count, " +
                "1 AS has_rsvp, " +
                "r.status AS user_rsvp_status " +
                "FROM RSVPs r " +
                "JOIN Events e ON e.event_id = r.event_id " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
                "WHERE r.user_id = ? AND r.status IN ('Going', 'Waitlisted') AND e.is_active = TRUE AND e.date >= CURDATE() " +
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
        String sql = "SELECT u.user_id, u.full_name, u.email, r.status, r.rsvp_time " +
                "FROM RSVPs r " +
                "JOIN Users u ON u.user_id = r.user_id " +
            "WHERE r.event_id = ? AND r.status IN ('Going', 'Waitlisted') " +
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
                    attendee.setStatus(rs.getString("status"));
                    attendee.setRsvpTime(rs.getTimestamp("rsvp_time"));
                    attendees.add(attendee);
                }
            }
        }

        return attendees;
    }

    public boolean promoteFirstWaitlisted(int eventId) throws SQLException {
        String sql = "UPDATE RSVPs target " +
                "JOIN (SELECT user_id FROM RSVPs WHERE event_id = ? AND status = 'Waitlisted' ORDER BY rsvp_time ASC LIMIT 1) candidate " +
                "ON target.user_id = candidate.user_id AND target.event_id = ? " +
                "SET target.status = 'Going', target.rsvp_time = CURRENT_TIMESTAMP";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, eventId);
            return stmt.executeUpdate() > 0;
        }
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

    public List<EventView> getEventsForUserByClub(int userId, int clubId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.category, e.image_url, e.capacity, " +
                "COALESCE(rc.going_count, 0) AS going_count, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN 1 ELSE 0 END AS has_rsvp, " +
                "CASE WHEN r.status IN ('Going', 'Waitlisted') THEN r.status ELSE NULL END AS user_rsvp_status " +
                "FROM Events e " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "LEFT JOIN RSVPs r ON r.event_id = e.event_id AND r.user_id = ? " +
                "LEFT JOIN (SELECT event_id, COUNT(*) AS going_count FROM RSVPs WHERE status = 'Going' GROUP BY event_id) rc ON rc.event_id = e.event_id " +
                "WHERE e.is_active = TRUE AND e.date >= CURDATE() AND e.club_id = ? " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<EventView> events = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapEventRow(rs));
                }
            }
        }

        return events;
    }
}
