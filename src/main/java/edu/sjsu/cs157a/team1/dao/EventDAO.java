package edu.sjsu.cs157a.team1.dao;

import edu.sjsu.cs157a.team1.util.DbUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public static class ClubView {
        private int clubId;
        private String clubName;

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
    }

    public static class ManagedEventView {
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
        private String category;
        private String imageUrl;

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
    }

    public boolean isClubOfficer(int userId) throws SQLException {
        String sql = "SELECT 1 FROM UserRoles ur JOIN Roles r ON ur.role_id = r.role_id " +
                "WHERE ur.user_id = ? AND r.role_name = 'Club Officer' LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<ClubView> getManagedClubs(int userId) throws SQLException {
        String sql = "SELECT c.club_id, c.club_name FROM Manages m " +
                "JOIN Clubs c ON c.club_id = m.club_id " +
                "WHERE m.user_id = ? ORDER BY c.club_name";

        List<ClubView> clubs = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ClubView club = new ClubView();
                    club.setClubId(rs.getInt("club_id"));
                    club.setClubName(rs.getString("club_name"));
                    clubs.add(club);
                }
            }
        }

        return clubs;
    }

    public boolean canManageClub(int userId, int clubId) throws SQLException {
        String sql = "SELECT 1 FROM Manages WHERE user_id = ? AND club_id = ? LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, clubId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean canManageEvent(int userId, int eventId) throws SQLException {
        String sql = "SELECT 1 FROM Events e JOIN Manages m ON e.club_id = m.club_id " +
                "WHERE e.event_id = ? AND m.user_id = ? LIMIT 1";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<ManagedEventView> getManagedEvents(int userId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.capacity, e.category, e.image_url " +
                "FROM Events e JOIN Manages m ON m.club_id = e.club_id " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "WHERE m.user_id = ? AND e.is_active = TRUE " +
                "ORDER BY e.date ASC, e.start_time ASC";

        List<ManagedEventView> events = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapManagedEvent(rs));
                }
            }
        }

        return events;
    }

    public ManagedEventView getManagedEventById(int userId, int eventId) throws SQLException {
        String sql = "SELECT e.event_id, e.club_id, c.club_name, e.title, e.description, e.date, e.start_time, e.end_time, " +
                "e.location, e.capacity, e.category, e.image_url " +
                "FROM Events e JOIN Manages m ON m.club_id = e.club_id " +
                "JOIN Clubs c ON c.club_id = e.club_id " +
                "WHERE m.user_id = ? AND e.event_id = ? AND e.is_active = TRUE";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapManagedEvent(rs);
                }
            }
        }

        return null;
    }

    public boolean createEvent(int userId, int clubId, String title, String description, Date date,
                               Time startTime, Time endTime, String location, Integer capacity,
                               String category, String imageUrl) throws SQLException {
        String sql = "INSERT INTO Events (title, description, date, start_time, end_time, location, capacity, category, image_url, is_active, club_id, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, TRUE, ?, ?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setDate(3, date);
            stmt.setTime(4, startTime);
            stmt.setTime(5, endTime);
            stmt.setString(6, location);
            if (capacity == null) {
                stmt.setNull(7, Types.INTEGER);
            } else {
                stmt.setInt(7, capacity);
            }
            stmt.setString(8, category);
            stmt.setString(9, imageUrl);
            stmt.setInt(10, clubId);
            stmt.setInt(11, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateEvent(int userId, int eventId, String title, String description, Date date,
                               Time startTime, Time endTime, String location, Integer capacity,
                               String category, String imageUrl) throws SQLException {
        String sql = "UPDATE Events e JOIN Manages m ON e.club_id = m.club_id " +
                "SET e.title = ?, e.description = ?, e.date = ?, e.start_time = ?, e.end_time = ?, " +
                "e.location = ?, e.capacity = ?, e.category = ?, e.image_url = ? " +
                "WHERE e.event_id = ? AND m.user_id = ? AND e.is_active = TRUE";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setDate(3, date);
            stmt.setTime(4, startTime);
            stmt.setTime(5, endTime);
            stmt.setString(6, location);
            if (capacity == null) {
                stmt.setNull(7, Types.INTEGER);
            } else {
                stmt.setInt(7, capacity);
            }
            stmt.setString(8, category);
            stmt.setString(9, imageUrl);
            stmt.setInt(10, eventId);
            stmt.setInt(11, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean softDeleteEvent(int userId, int eventId) throws SQLException {
        String sql = "UPDATE Events e JOIN Manages m ON e.club_id = m.club_id " +
                "SET e.is_active = FALSE " +
                "WHERE e.event_id = ? AND m.user_id = ? AND e.is_active = TRUE";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    private ManagedEventView mapManagedEvent(ResultSet rs) throws SQLException {
        ManagedEventView event = new ManagedEventView();
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

        event.setCategory(rs.getString("category"));
        event.setImageUrl(rs.getString("image_url"));
        return event;
    }
}
