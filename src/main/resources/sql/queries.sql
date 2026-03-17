-- ==========================================
-- SCREENSHOT QUERIES
-- Run one section at a time in MySQL Workbench.
-- ==========================================

USE CS157SpartanClubConnect;

-- 0. Optional: verify each table has at least 10 rows
SELECT 'Users' AS table_name, COUNT(*) AS row_count FROM Users
UNION ALL
SELECT 'Students', COUNT(*) FROM Students
UNION ALL
SELECT 'Admin', COUNT(*) FROM Admin
UNION ALL
SELECT 'ClubOfficers', COUNT(*) FROM ClubOfficers
UNION ALL
SELECT 'Clubs', COUNT(*) FROM Clubs
UNION ALL
SELECT 'ClubCategories', COUNT(*) FROM ClubCategories
UNION ALL
SELECT 'ClubCategoryMaps', COUNT(*) FROM ClubCategoryMaps
UNION ALL
SELECT 'Events', COUNT(*) FROM Events
UNION ALL
SELECT 'EventSessions', COUNT(*) FROM EventSessions
UNION ALL
SELECT 'Manages', COUNT(*) FROM Manages
UNION ALL
SELECT 'Follows', COUNT(*) FROM Follows
UNION ALL
SELECT 'Bookmarks', COUNT(*) FROM Bookmarks
UNION ALL
SELECT 'RSVPs', COUNT(*) FROM RSVPs
UNION ALL
SELECT 'ClubOfficerRequests', COUNT(*) FROM ClubOfficerRequests;

-- 1. Users
SELECT * FROM Users;

-- 2. Students
SELECT * FROM Students;

-- 3. Admin
SELECT * FROM Admin;

-- 4. ClubOfficers
SELECT * FROM ClubOfficers;

-- 5. Clubs
SELECT * FROM Clubs;

-- 6. ClubCategories
SELECT * FROM ClubCategories;

-- 7. ClubCategoryMaps
SELECT * FROM ClubCategoryMaps;

-- 8. Events
SELECT * FROM Events;

-- 9. EventSessions
SELECT * FROM EventSessions;

-- 10. Manages
SELECT * FROM Manages;

-- 11. Follows
SELECT * FROM Follows;

-- 12. Bookmarks
SELECT * FROM Bookmarks;

-- 13. RSVPs
SELECT * FROM RSVPs;

-- 14. ClubOfficerRequests
SELECT * FROM ClubOfficerRequests;
