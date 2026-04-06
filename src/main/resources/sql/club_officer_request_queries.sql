USE CS157SpartanClubConnect;

-- ==========================================
-- CLUB OFFICER REQUEST FEATURE QUERIES
-- Feature: 1.1.3 Club Officer Role Request
-- For validation, screenshots, and manual testing
-- ==========================================


-- ==========================================
-- 1. VIEW ALL OFFICER REQUESTS
-- ==========================================

SELECT *
FROM ClubOfficerRequests
ORDER BY created_at DESC;


-- ==========================================
-- 2. VIEW PENDING OFFICER REQUESTS
-- ==========================================

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
    requester.full_name AS requester_name,
    requester.email AS requester_email
FROM ClubOfficerRequests cor
         JOIN Users requester ON cor.user_id = requester.user_id
WHERE cor.status = 'Pending'
ORDER BY cor.created_at ASC;


-- ==========================================
-- 3. VIEW REVIEWED OFFICER REQUESTS
-- ==========================================

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
    requester.full_name AS requester_name,
    requester.email AS requester_email,
    reviewer.full_name AS reviewer_name
FROM ClubOfficerRequests cor
         JOIN Users requester ON cor.user_id = requester.user_id
         LEFT JOIN Users reviewer ON cor.reviewed_by = reviewer.user_id
WHERE cor.status IN ('Approved', 'Denied')
ORDER BY cor.reviewed_at DESC, cor.created_at DESC;


-- ==========================================
-- 4. VIEW USER ROLES
-- Useful for verifying role assignment
-- ==========================================

SELECT
    u.user_id,
    u.full_name,
    u.email,
    r.role_name,
    ur.assigned_at
FROM Users u
         JOIN UserRoles ur ON u.user_id = ur.user_id
         JOIN Roles r ON ur.role_id = r.role_id
ORDER BY u.user_id, r.role_name;


-- ==========================================
-- 5. CHECK WHETHER A USER HAS A PENDING REQUEST
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

SELECT 1
FROM ClubOfficerRequests
WHERE user_id = ? AND status = 'Pending'
    LIMIT 1;


-- ==========================================
-- 6. CHECK WHETHER A USER ALREADY HAS CLUB OFFICER ROLE
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

SELECT 1
FROM UserRoles ur
         JOIN Roles r ON ur.role_id = r.role_id
WHERE ur.user_id = ? AND r.role_name = 'Club Officer'
    LIMIT 1;


-- ==========================================
-- 7. CREATE A CLUB OFFICER REQUEST (DAO REFERENCE)
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

INSERT INTO ClubOfficerRequests
(sjsu_id, club_name, justification, status, created_at, user_id)
VALUES (?, ?, ?, 'Pending', NOW(), ?);


-- ==========================================
-- 8. FIND CLUB OFFICER ROLE ID
-- ==========================================

SELECT role_id
FROM Roles
WHERE role_name = 'Club Officer'
    LIMIT 1;


-- ==========================================
-- 9. APPROVE A REQUEST (MANUAL TESTING)
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

UPDATE ClubOfficerRequests
SET status = 'Approved',
    reviewed_by = ?,
    reviewed_at = NOW()
WHERE request_id = ? AND status = 'Pending';


-- ==========================================
-- 10. DENY A REQUEST (MANUAL TESTING)
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

UPDATE ClubOfficerRequests
SET status = 'Denied',
    reviewed_by = ?,
    reviewed_at = NOW()
WHERE request_id = ? AND status = 'Pending';


-- ==========================================
-- 11. ASSIGN CLUB OFFICER ROLE TO USER (MANUAL TESTING)
-- Replace ? manually if testing in MySQL Workbench
-- ==========================================

INSERT INTO UserRoles (user_id, role_id, assigned_at)
VALUES (?, ?, NOW());


-- ==========================================
-- 12. FEATURE VALIDATION FOR DEMO ACCOUNTS
-- Adjust values if needed
-- ==========================================

-- Approved club officer account
SELECT
    u.user_id,
    u.full_name,
    u.email,
    r.role_name
FROM Users u
         JOIN UserRoles ur ON u.user_id = ur.user_id
         JOIN Roles r ON ur.role_id = r.role_id
WHERE u.email = 'first.last@sjsu.edu';

-- Admin account
SELECT
    u.user_id,
    u.full_name,
    u.email,
    r.role_name
FROM Users u
         JOIN UserRoles ur ON u.user_id = ur.user_id
         JOIN Roles r ON ur.role_id = r.role_id
WHERE u.email = 'admin.one@sjsu.edu';

-- Pending applicant account
SELECT *
FROM ClubOfficerRequests cor
         JOIN Users u ON cor.user_id = u.user_id
WHERE u.email = 'officer.one@sjsu.edu'
ORDER BY cor.created_at DESC;