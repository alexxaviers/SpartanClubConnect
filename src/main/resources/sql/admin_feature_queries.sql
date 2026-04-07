USE CS157SpartanClubConnect;

-- ==========================================
-- ADMIN USER MANAGEMENT
-- ==========================================

SELECT
    u.user_id,
    u.full_name,
    u.email,
    u.is_active,
    GROUP_CONCAT(r.role_name ORDER BY r.role_name SEPARATOR ', ') AS roles
FROM Users u
         LEFT JOIN UserRoles ur ON u.user_id = ur.user_id
         LEFT JOIN Roles r ON ur.role_id = r.role_id
GROUP BY u.user_id, u.full_name, u.email, u.is_active
ORDER BY u.user_id;

UPDATE Users
SET is_active = FALSE
WHERE user_id = 11;

UPDATE Users
SET is_active = TRUE
WHERE user_id = 11;

INSERT INTO UserRoles (user_id, role_id, assigned_at)
SELECT 11, role_id, NOW()
FROM Roles
WHERE role_name = 'Club Officer';

DELETE ur
FROM UserRoles ur
JOIN Roles r ON ur.role_id = r.role_id
WHERE ur.user_id = 11
  AND r.role_name = 'Club Officer';

SELECT
    u.user_id,
    u.full_name,
    r.role_name,
    ur.assigned_at
FROM Users u
         JOIN UserRoles ur ON u.user_id = ur.user_id
         JOIN Roles r ON ur.role_id = r.role_id
WHERE u.user_id = 11
ORDER BY r.role_name;

-- ==========================================
-- ADMIN EVENT MODERATION
-- ==========================================

SELECT
    e.event_id,
    e.title,
    e.date,
    e.location,
    e.is_active,
    c.club_name,
    u.full_name AS creator_name
FROM Events e
         JOIN Clubs c ON e.club_id = c.club_id
         JOIN Users u ON e.created_by = u.user_id
ORDER BY e.date, e.start_time;

UPDATE Events
SET is_active = FALSE
WHERE event_id = 3;

UPDATE Events
SET is_active = TRUE
WHERE event_id = 3;

SELECT *
FROM Events
WHERE is_active = TRUE
ORDER BY date, start_time;

SELECT *
FROM Events
WHERE is_active = FALSE
ORDER BY date, start_time;
