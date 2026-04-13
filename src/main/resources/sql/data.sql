USE CS157SpartanClubConnect;

-- ==========================================
-- SAMPLE DATA FOR TESTING (10+ rows per table where practical)
-- ==========================================

-- USERS (30 rows)
INSERT INTO Users (full_name, email, password_hash, is_active) VALUES
    ('Carlos Ramirez', 'carlos.ramirez@sjsu.edu', 'hashed_password_1', TRUE),
    ('Priya Patel', 'priya.patel@sjsu.edu', 'hashed_password_2', TRUE),
    ('Kevin Nguyen', 'kevin.nguyen@sjsu.edu', 'hashed_password_3', TRUE),
    ('Sofia Hernandez', 'sofia.hernandez@sjsu.edu', 'hashed_password_4', TRUE),
    ('Marcus Lee', 'marcus.lee@sjsu.edu', 'hashed_password_5', TRUE),
    ('Emily Tran', 'emily.tran@sjsu.edu', 'hashed_password_6', TRUE),
    ('Daniel Kim', 'daniel.kim@sjsu.edu', 'hashed_password_7', TRUE),
    ('Aisha Khan', 'aisha.khan@sjsu.edu', 'hashed_password_8', TRUE),
    ('Noah Martinez', 'noah.martinez@sjsu.edu', 'hashed_password_9', TRUE),
    ('Maya Singh', 'maya.singh@sjsu.edu', 'hashed_password_10', TRUE),
    ('Olivia Park', 'olivia.park@sjsu.edu', 'hashed_password_11', TRUE),
    ('Ethan Wong', 'ethan.wong@sjsu.edu', 'hashed_password_12', TRUE),
    ('Hannah Davis', 'hannah.davis@sjsu.edu', 'hashed_password_13', TRUE),
    ('Adrian Lopez', 'adrian.lopez@sjsu.edu', 'hashed_password_14', TRUE),
    ('Chloe Nguyen', 'chloe.nguyen@sjsu.edu', 'hashed_password_15', TRUE),
    ('Samuel Ortiz', 'samuel.ortiz@sjsu.edu', 'hashed_password_16', TRUE),
    ('Natalie Rivera', 'natalie.rivera@sjsu.edu', 'hashed_password_17', TRUE),
    ('Jason Chen', 'jason.chen@sjsu.edu', 'hashed_password_18', TRUE),
    ('Lily Thompson', 'lily.thompson@sjsu.edu', 'hashed_password_19', TRUE),
    ('Omar Ali', 'omar.ali@sjsu.edu', 'hashed_password_20', TRUE),
    ('Mei Lin', 'mei.lin@sjsu.edu', 'hashed_password_21', TRUE),
    ('David Park', 'david.park@sjsu.edu', 'hashed_password_22', TRUE),
    ('Angela Ruiz', 'angela.ruiz@sjsu.edu', 'hashed_password_23', TRUE),
    ('Brian Johnson', 'brian.johnson@sjsu.edu', 'hashed_password_24', TRUE),
    ('Vanessa Flores', 'vanessa.flores@sjsu.edu', 'hashed_password_25', TRUE),
    ('Michael Torres', 'michael.torres@sjsu.edu', 'hashed_password_26', TRUE),
    ('Stephanie Wu', 'stephanie.wu@sjsu.edu', 'hashed_password_27', TRUE),
    ('Christopher Hall', 'christopher.hall@sjsu.edu', 'hashed_password_28', TRUE),
    ('Jasmine Reed', 'jasmine.reed@sjsu.edu', 'hashed_password_29', TRUE),
    ('Tyler Brooks', 'tyler.brooks@sjsu.edu', 'hashed_password_30', TRUE);

-- ROLES
INSERT INTO Roles (role_name) VALUES
    ('Student'),
    ('Club Officer'),
    ('Admin');

-- USER ROLES
-- Users 1-20 are students
INSERT INTO UserRoles (user_id, role_id) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1),
    (10, 1),
    (11, 1),
    (12, 1),
    (13, 1),
    (14, 1),
    (15, 1),
    (16, 1),
    (17, 1),
    (18, 1),
    (19, 1),
    (20, 1),
    -- Users 1-10 are also club officers
    (1, 2),
    (2, 2),
    (3, 2),
    (4, 2),
    (5, 2),
    (6, 2),
    (7, 2),
    (8, 2),
    (9, 2),
    (10, 2),
    -- Users 21-30 are admins
    (21, 3),
    (22, 3),
    (23, 3),
    (24, 3),
    (25, 3),
    (26, 3),
    (27, 3),
    (28, 3),
    (29, 3),
    (30, 3);

-- CLUB CATEGORIES (10 rows)
INSERT INTO ClubCategories (category_name) VALUES
    ('Academic'),
    ('Engineering'),
    ('Business'),
    ('Arts'),
    ('Cultural'),
    ('Technology'),
    ('Recreation & Sports'),
    ('Community Service'),
    ('Professional Development'),
    ('Media & Entertainment');

-- CLUBS (10 rows)
INSERT INTO Clubs (club_name, description, contact_email, meeting_info) VALUES
    ('Association for Computing Machinery', 'Student chapter focused on software development, technical interviews, and industry speakers.', 'acm@sjsu.edu', 'Mondays 6:00 PM - Engineering Building Room 285'),
    ('Society of Hispanic Professional Engineers', 'Professional development and community-building for Hispanic engineers and allies.', 'shpe@sjsu.edu', 'Tuesdays 6:00 PM - Engineering Building Room 189'),
    ('Spartan Debate Society', 'Public speaking, argumentation, and intercollegiate debate practice.', 'debate@sjsu.edu', 'Wednesdays 5:30 PM - Student Union Meeting Room B'),
    ('SJSU Photography Collective', 'Hands-on photography practice, editing workshops, and campus photo walks.', 'photography@sjsu.edu', 'Thursdays 4:30 PM - Art Building Lab 12'),
    ('Women in Business at SJSU', 'Networking, leadership, and career preparation for students interested in business.', 'womeninbusiness@sjsu.edu', 'Tuesdays 7:00 PM - Boccardo Business Center Room 150'),
    ('Anime and Manga Association', 'Weekly screenings and discussions centered on anime, manga, and Japanese pop culture.', 'anime@sjsu.edu', 'Fridays 6:30 PM - Student Union Room 3A'),
    ('Spartan Environmental Action Coalition', 'Sustainability projects, cleanups, and environmental awareness campaigns.', 'seac@sjsu.edu', 'Wednesdays 4:00 PM - Student Union Room 2B'),
    ('Intramural Soccer Club', 'Recreational and competitive soccer activities for students of all skill levels.', 'soccer@sjsu.edu', 'Sundays 2:00 PM - Spartan Recreation Field'),
    ('Chess and Strategy Club', 'Casual play, rated tournaments, and strategy training sessions.', 'chess@sjsu.edu', 'Thursdays 7:00 PM - Clark Hall Room 111'),
    ('Music Performance Society', 'Open rehearsals, student showcases, and collaborative performances.', 'music@sjsu.edu', 'Mondays 7:00 PM - Music Building Recital Room');

-- CLUB CATEGORY MAPS (10 rows)
INSERT INTO ClubCategoryMaps (club_id, category_id) VALUES
    (1, 6),
    (2, 2),
    (3, 9),
    (4, 4),
    (5, 3),
    (6, 10),
    (7, 8),
    (8, 7),
    (9, 1),
    (10, 4);

-- MANAGES RELATIONSHIP (10 rows)
INSERT INTO Manages (user_id, club_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

-- FOLLOWS RELATIONSHIP (10 rows)
INSERT INTO Follows (user_id, club_id) VALUES
    (11, 1),
    (12, 2),
    (13, 3),
    (14, 4),
    (15, 5),
    (16, 6),
    (17, 7),
    (18, 8),
    (19, 9),
    (20, 10);

-- EVENTS (10 rows)
INSERT INTO Events (title, description, date, start_time, end_time, location, category, capacity, image_url, is_active, club_id, created_by) VALUES
    ('ACM Technical Interview Prep', 'A workshop covering data structures, whiteboard practice, and internship interview strategies.', '2026-04-08', '18:00:00', '20:00:00', 'Engineering Building Room 189', 'Technology', 80, NULL, TRUE, 1, 1),
    ('SHPE Networking Night', 'Meet alumni and local professionals for career advice and internship networking.', '2026-04-10', '18:30:00', '20:30:00', 'Student Union Ballroom B', 'Professional Development', 120, NULL, TRUE, 2, 2),
    ('Spartan Debate Showcase', 'An exhibition round featuring current members and open audience Q&A.', '2026-04-12', '17:00:00', '19:00:00', 'Student Union Theater', 'Academic', 60, NULL, TRUE, 3, 3),
    ('Campus Golden Hour Photo Walk', 'Guided photo walk across campus with composition and lighting tips.', '2026-04-14', '17:30:00', '19:00:00', 'Tower Lawn', 'Arts', 35, NULL, TRUE, 4, 4),
    ('Women in Business Resume Review', 'Resume critique and LinkedIn profile workshop led by upperclassmen and alumni.', '2026-04-16', '18:00:00', '20:00:00', 'BBC Room 032', 'Business', 70, NULL, TRUE, 5, 5),
    ('Anime Screening Night', 'Club screening of a feature-length anime film followed by discussion.', '2026-04-18', '18:30:00', '21:00:00', 'Student Union Room 3A', 'Media & Entertainment', 90, NULL, TRUE, 6, 6),
    ('Earth Day Tree Planting', 'Volunteer event focused on planting and maintaining native trees near campus.', '2026-04-22', '09:00:00', '12:00:00', '7th Street Plaza', 'Community Service', 50, NULL, TRUE, 7, 7),
    ('Weekend Soccer Scrimmage', 'Friendly scrimmage open to all members with rotating teams and short matches.', '2026-04-25', '14:00:00', '16:00:00', 'Spartan Recreation Field', 'Recreation & Sports', 40, NULL, TRUE, 8, 8),
    ('Blitz Chess Tournament', 'Fast-paced campus chess tournament with a small prize for top finishers.', '2026-04-27', '18:00:00', '21:00:00', 'Clark Hall Room 111', 'Academic', 32, NULL, TRUE, 9, 9),
    ('Spring Open Mic Showcase', 'Student musicians perform solo and group sets in an open mic format.', '2026-04-30', '19:00:00', '21:30:00', 'Music Building Recital Room', 'Arts', 100, NULL, TRUE, 10, 10);

-- RSVPS (10 rows)
INSERT INTO RSVPs (user_id, event_id, status) VALUES
    (11, 1, 'Going'),
    (12, 2, 'Going'),
    (13, 3, 'Interested'),
    (14, 4, 'Going'),
    (15, 5, 'Going'),
    (16, 6, 'Interested'),
    (17, 7, 'Going'),
    (18, 8, 'Going'),
    (19, 9, 'Interested'),
    (20, 10, 'Going');

-- BOOKMARKS (10 rows)
INSERT INTO Bookmarks (user_id, event_id) VALUES
    (11, 2),
    (12, 3),
    (13, 4),
    (14, 5),
    (15, 6),
    (16, 7),
    (17, 8),
    (18, 9),
    (19, 10),
    (20, 1);

-- CLUB OFFICER REQUESTS (10 rows)
INSERT INTO ClubOfficerRequests (sjsu_id, justification, status, user_id, reviewed_by) VALUES
    ('016245781', 'I regularly attend ACM workshops and want to help organize technical practice sessions for new members.', 'Pending', 11, NULL),
    ('016245782', 'I have prior outreach experience and would like to help SHPE coordinate industry networking events.', 'Approved', 12, 21),
    ('016245783', 'I have been active in debate prep meetings and want to support tournament logistics and member onboarding.', 'Rejected', 13, 22),
    ('016245784', 'I am experienced with Lightroom and campus event coverage and would like to help run photo walk programming.', 'Pending', 14, NULL),
    ('016245785', 'I can help manage guest speakers and resume review events for Women in Business.', 'Approved', 15, 23),
    ('016245786', 'I have helped moderate screening discussions and want to serve as a programming officer for Anime Club.', 'Pending', 16, NULL),
    ('016245787', 'I volunteer regularly at sustainability events and would like to coordinate service activities for SEAC.', 'Approved', 17, 24),
    ('016245788', 'I have experience organizing recreational leagues and want to help schedule soccer scrimmages.', 'Rejected', 18, 25),
    ('016245789', 'I can help run beginner workshops and tournament check-ins for Chess and Strategy Club.', 'Approved', 19, 26),
    ('016245790', 'I want to support rehearsal planning and performer outreach for the Music Performance Society.', 'Pending', 20, NULL);
