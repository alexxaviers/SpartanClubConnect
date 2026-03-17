-- ==========================================
-- USEFUL QUERIES TO VIEW TEST DATA
-- ==========================================

USE CS157SpartanClubConnect;

-- View all users
SELECT * FROM Users;

-- View all students
SELECT u.user_id, u.full_name, u.email, s.user_id 
FROM Users u 
JOIN Students s ON u.user_id = s.user_id;

-- View all admin users
SELECT u.user_id, u.full_name, u.email 
FROM Users u 
JOIN Admin a ON u.user_id = a.user_id;

-- View all club officers with their role
SELECT u.user_id, u.full_name, u.email, co.role 
FROM Users u 
JOIN ClubOfficers co ON u.user_id = co.user_id;

-- View all clubs
SELECT * FROM Clubs;

-- View all club categories
SELECT * FROM ClubCategories;

-- View clubs with their categories
SELECT c.club_id, c.club_name, cat.category_name 
FROM Clubs c 
JOIN ClubCategoryMaps ccm ON c.club_id = ccm.club_id 
JOIN ClubCategories cat ON ccm.category_id = cat.category_id;

-- View which officers manage which clubs
SELECT u.full_name, u.email, c.club_name 
FROM Manages m 
JOIN ClubOfficers co ON m.user_id = co.user_id 
JOIN Users u ON co.user_id = u.user_id 
JOIN Clubs c ON m.club_id = c.club_id;

-- View all events
SELECT * FROM Events;

-- View events with club names and organizer info
SELECT e.event_id, e.title, c.club_name, u.full_name AS created_by, e.date, e.start_time 
FROM Events e 
JOIN Clubs c ON e.club_id = c.club_id 
JOIN ClubOfficers co ON e.created_by = co.user_id 
JOIN Users u ON co.user_id = u.user_id;

-- View all RSVPs with event and student info
SELECT u.full_name, e.title, r.status, r.rsvp_time 
FROM RSVPs r 
JOIN Students s ON r.user_id = s.user_id 
JOIN Users u ON s.user_id = u.user_id 
JOIN Events e ON r.event_id = e.event_id;

-- View all bookmarked events
SELECT u.full_name, e.title, b.saved_at 
FROM Bookmarks b 
JOIN Students s ON b.user_id = s.user_id 
JOIN Users u ON s.user_id = u.user_id 
JOIN Events e ON b.event_id = e.event_id;

-- View followed clubs
SELECT u.full_name, c.club_name, f.followed_at 
FROM Follows f 
JOIN Students s ON f.user_id = s.user_id 
JOIN Users u ON s.user_id = u.user_id 
JOIN Clubs c ON f.club_id = c.club_id;

-- View club officer requests
SELECT cor.request_id, u.full_name, cor.justification, cor.status, admin.full_name AS reviewed_by 
FROM ClubOfficerRequests cor 
JOIN Students s ON cor.user_id = s.user_id 
JOIN Users u ON s.user_id = u.user_id 
LEFT JOIN Admin a ON cor.reviewed_by = a.user_id 
LEFT JOIN Users admin ON a.user_id = admin.user_id;

-- View event sessions
SELECT e.event_id, e.title, es.session_number 
FROM EventSessions es 
JOIN Events e ON es.event_id = e.event_id;

-- Count rows in each table
SELECT 'Users' AS table_name, COUNT(*) AS row_count FROM Users
UNION
SELECT 'Students', COUNT(*) FROM Students
UNION
SELECT 'Admin', COUNT(*) FROM Admin
UNION
SELECT 'ClubOfficers', COUNT(*) FROM ClubOfficers
UNION
SELECT 'Clubs', COUNT(*) FROM Clubs
UNION
SELECT 'ClubCategories', COUNT(*) FROM ClubCategories
UNION
SELECT 'ClubCategoryMaps', COUNT(*) FROM ClubCategoryMaps
UNION
SELECT 'Events', COUNT(*) FROM Events
UNION
SELECT 'EventSessions', COUNT(*) FROM EventSessions
UNION
SELECT 'Manages', COUNT(*) FROM Manages
UNION
SELECT 'Follows', COUNT(*) FROM Follows
UNION
SELECT 'Bookmarks', COUNT(*) FROM Bookmarks
UNION
SELECT 'RSVPs', COUNT(*) FROM RSVPs
UNION
SELECT 'ClubOfficerRequests', COUNT(*) FROM ClubOfficerRequests;
