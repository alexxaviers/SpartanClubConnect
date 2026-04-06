-- ==========================================
-- SCREENSHOT + VALIDATION QUERIES
-- SpartanClubConnect
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

-- ==========================================
-- DAO REFERENCE QUERIES
-- These are used in backend prepared statements.
-- Replace ? values manually if testing in MySQL Workbench.
-- ==========================================

-- Insert a new club officer request
INSERT INTO ClubOfficerRequests
(sjsu_id, club_name, justification, status, created_at, user_id)
VALUES (?, ?, ?, 'Pending', NOW(), ?);

-- Check if user already has a pending request
SELECT 1
FROM ClubOfficerRequests
WHERE user_id = ? AND status = 'Pending'
    LIMIT 1;

-- Check if user already has Club Officer role
SELECT 1
FROM UserRoles ur
         JOIN Roles r ON ur.role_id = r.role_id
WHERE ur.user_id = ? AND r.role_name = 'Club Officer'
    LIMIT 1;

-- ==========================================
-- ADMIN OFFICER REQUEST REVIEW QUERIES
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

-- View all pending officer requests with requester info
SELECT
    cor.request_id,
    cor.sjsu_id,
    cor.club_name,
    cor.justification,
    cor.status,
    cor.created_at,
    cor.user_id,
    cor.reviewed_by,
    cor.reviewed_at,
    u.full_name,
    u.email
FROM ClubOfficerRequests cor
         JOIN Users u ON cor.user_id = u.user_id
WHERE cor.status = 'Pending'
ORDER BY cor.created_at ASC;

-- Approve a request
UPDATE ClubOfficerRequests
SET status = 'Approved',
    reviewed_by = ?,
    reviewed_at = NOW()
WHERE request_id = ? AND status = 'Pending';

-- Deny a request
UPDATE ClubOfficerRequests
SET status = 'Denied',
    reviewed_by = ?,
    reviewed_at = NOW()
WHERE request_id = ? AND status = 'Pending';

-- Find Club Officer role ID
SELECT role_id
FROM Roles
WHERE role_name = 'Club Officer'
    LIMIT 1;

-- Assign Club Officer role to user
INSERT INTO UserRoles (user_id, role_id, assigned_at)
VALUES (?, ?, NOW());

-- View reviewed officer requests with requester info
SELECT
    cor.request_id,
    cor.sjsu_id,
    cor.club_name,
    cor.justification,
    cor.status,
    cor.created_at,
    cor.user_id,
    cor.reviewed_by,
    cor.reviewed_at,
    u.full_name,
    u.email
FROM ClubOfficerRequests cor
         JOIN Users u ON cor.user_id = u.user_id
WHERE cor.status IN ('Approved', 'Denied')
ORDER BY cor.reviewed_at DESC, cor.created_at DESC;
