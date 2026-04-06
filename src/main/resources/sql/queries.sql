-- ==========================================
-- GENERAL VALIDATION / SCREENSHOT QUERIES
-- ==========================================

USE CS157SpartanClubConnect;

-- ==========================================
-- OPTIONAL: row counts
-- Run one at a time to verify data exists
-- ==========================================

SELECT COUNT(*) AS user_count
FROM Users;

SELECT COUNT(*) AS role_count
FROM Roles;

SELECT COUNT(*) AS user_role_count
FROM UserRoles;

SELECT COUNT(*) AS club_count
FROM Clubs;

SELECT COUNT(*) AS club_category_count
FROM ClubCategories;

SELECT COUNT(*) AS club_category_map_count
FROM ClubCategoryMaps;

SELECT COUNT(*) AS event_count
FROM Events;

SELECT COUNT(*) AS manages_count
FROM Manages;

SELECT COUNT(*) AS follows_count
FROM Follows;

SELECT COUNT(*) AS bookmark_count
FROM Bookmarks;

SELECT COUNT(*) AS rsvp_count
FROM RSVPs;

SELECT COUNT(*) AS officer_request_count
FROM ClubOfficerRequests;

-- ==========================================
-- SCREENSHOT TABLE QUERIES
-- Run one section at a time
-- ==========================================

-- 1. Users
SELECT *
FROM Users;

-- 2. Roles
SELECT *
FROM Roles;

-- 3. UserRoles
SELECT *
FROM UserRoles;

-- 4. Clubs
SELECT *
FROM Clubs;

-- 5. ClubCategories
SELECT *
FROM ClubCategories;

-- 6. ClubCategoryMaps
SELECT *
FROM ClubCategoryMaps;

-- 7. Events
SELECT *
FROM Events;

-- 8. Manages
SELECT *
FROM Manages;

-- 9. Follows
SELECT *
FROM Follows;

-- 10. Bookmarks
SELECT *
FROM Bookmarks;

-- 11. RSVPs
SELECT *
FROM RSVPs;

-- 12. ClubOfficerRequests
SELECT *
FROM ClubOfficerRequests;
