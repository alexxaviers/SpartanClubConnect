USE CS157SpartanClubConnect;

-- ==========================================
-- SAMPLE DATA FOR TESTING (10+ rows per table)
-- ==========================================

-- USERS (12 rows) - Superclass with different roles
INSERT INTO Users (full_name, email, password_hash, is_active) VALUES
('Admin User', 'admin@sjsu.edu', 'hashed_password_1', TRUE),
('John Smith', 'john.smith@sjsu.edu', 'hashed_password_2', TRUE),
('Jane Doe', 'jane.doe@sjsu.edu', 'hashed_password_3', TRUE),
('Bob Johnson', 'bob.johnson@sjsu.edu', 'hashed_password_4', TRUE),
('Alice Williams', 'alice.williams@sjsu.edu', 'hashed_password_5', TRUE),
('Charlie Brown', 'charlie.brown@sjsu.edu', 'hashed_password_6', TRUE),
('Diana Prince', 'diana.prince@sjsu.edu', 'hashed_password_7', TRUE),
('Eve Martinez', 'eve.martinez@sjsu.edu', 'hashed_password_8', TRUE),
('Frank Thompson', 'frank.thompson@sjsu.edu', 'hashed_password_9', TRUE),
('Grace Lee', 'grace.lee@sjsu.edu', 'hashed_password_10', TRUE),
('Henry Davis', 'henry.davis@sjsu.edu', 'hashed_password_11', TRUE),
('Iris Wilson', 'iris.wilson@sjsu.edu', 'hashed_password_12', TRUE);

-- ADMIN (3 rows for diversity)
INSERT INTO Admin (user_id) VALUES
(1),
(11),
(12);

-- STUDENTS (10 rows)
INSERT INTO Students (user_id) VALUES
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11);

-- CLUB OFFICERS (10 rows - students with officer roles)
INSERT INTO ClubOfficers (user_id, role) VALUES
(2, 'President'),
(3, 'Vice President'),
(4, 'Treasurer'),
(5, 'Secretary'),
(6, 'Event Lead'),
(7, 'Membership Lead'),
(8, 'President'),
(9, 'Vice President'),
(10, 'Treasurer'),
(11, 'Secretary');

-- CLUB CATEGORIES (10 rows)
INSERT INTO ClubCategories (category_name) VALUES
('Academic'),
('Sports'),
('Arts'),
('Technology'),
('Social'),
('Professional'),
('Cultural'),
('Health & Wellness'),
('Service & Community'),
('Religious & Spiritual');

-- CLUBS (10 rows)
INSERT INTO Clubs (club_name, description, contact_email, meeting_info) VALUES
('Computer Science Club', 'For students interested in computer science and programming', 'csclub@sjsu.edu', 'Mondays 5PM - Engineering Building Room 101'),
('Debate Club', 'Competitive debate and public speaking', 'debate@sjsu.edu', 'Wednesdays 6PM - Student Center'),
('Photography Club', 'Photography enthusiasts and professionals', 'photo@sjsu.edu', 'Thursdays 4PM - Campus Center'),
('Business Club', 'Students interested in business and entrepreneurship', 'business@sjsu.edu', 'Tuesdays 5:30PM - Business Building'),
('Anime Club', 'Fans of anime, manga, and Japanese culture', 'anime@sjsu.edu', 'Fridays 6PM - Student Union'),
('Environmental Club', 'Sustainability and environmental advocacy', 'eco@sjsu.edu', 'Saturdays 10AM - Student Center'),
('Soccer Club', 'Campus soccer league and recreational play', 'soccer@sjsu.edu', 'Sundays 2PM - Field 1'),
('Chess Club', 'Strategic board games and tournaments', 'chess@sjsu.edu', 'Thursdays 7PM - Student Center Room 102'),
('Music Club', 'Musicians of all genres and skill levels welcome', 'music@sjsu.edu', 'Wednesdays 7PM - Music Building Studio 1'),
('Coding Competition Club', 'Prepare for programming competitions and hackathons', 'coding@sjsu.edu', 'Fridays 5PM - Engineering Building Lab');

-- CLUB CATEGORY MAPS (10 rows)
INSERT INTO ClubCategoryMaps (club_id, category_id) VALUES
(1, 4),
(2, 6),
(3, 3),
(4, 6),
(5, 7),
(6, 9),
(7, 2),
(8, 4),
(9, 3),
(10, 4);

-- MANAGES RELATIONSHIP (10 rows)
INSERT INTO Manages (user_id, club_id) VALUES
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9),
(11, 10);

-- FOLLOWS RELATIONSHIP (10 rows)
INSERT INTO Follows (user_id, club_id) VALUES
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 5),
(10, 6),
(11, 7),
(5, 8),
(6, 9),
(7, 10);

-- EVENTS (10 rows)
INSERT INTO Events (title, description, date, start_time, end_time, location, capacity, is_active, club_id, created_by) VALUES
('Python Workshop', 'Learn Python basics and coding fundamentals', '2026-04-15', '14:00:00', '16:00:00', 'Engineering Building 101', 50, TRUE, 1, 2),
('Weekly Debate Session', 'Practice debate skills in a competitive environment', '2026-04-10', '18:00:00', '20:00:00', 'Student Center Room 205', 30, TRUE, 2, 3),
('Photo Walk Around Campus', 'Explore and photograph beautiful campus locations', '2026-04-20', '10:00:00', '12:00:00', 'Campus Bell Tower', 25, TRUE, 3, 4),
('Entrepreneurship Panel', 'Talk with successful entrepreneurs about starting businesses', '2026-04-22', '16:00:00', '18:00:00', 'Business Building Auditorium', 100, TRUE, 4, 5),
('Anime Movie Night', 'Watch and discuss latest anime releases', '2026-04-25', '19:00:00', '21:30:00', 'Student Union Theater', 80, TRUE, 5, 6),
('Beach Cleanup Drive', 'Community service: clean up local beaches', '2026-05-01', '08:00:00', '11:00:00', 'Santa Cruz Beach', 40, TRUE, 6, 7),
('Friday Soccer Match', 'Friendly soccer match against other campus clubs', '2026-05-03', '15:00:00', '17:00:00', 'Soccer Field 1', 60, TRUE, 7, 8),
('Chess Tournament', 'Annual campus chess tournament with prizes', '2026-05-10', '10:00:00', '16:00:00', 'Student Center Room 102', 32, TRUE, 8, 9),
('Open Mic Night', 'Musicians perform original and cover songs', '2026-05-12', '19:00:00', '22:00:00', 'Student Center Auditorium', 200, TRUE, 9, 10),
('Hackathon 2026', 'Build innovative tech projects in 24 hours', '2026-05-15', '09:00:00', '09:00:00', 'Engineering Building', 150, TRUE, 10, 11);

-- EVENT SESSIONS (10 rows - weak entity)
INSERT INTO EventSessions (event_id, session_number) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1);

-- RSVPS (10 rows)
INSERT INTO RSVPs (user_id, event_id, status) VALUES
(5, 1, 'Confirmed'),
(6, 1, 'Interested'),
(7, 2, 'Confirmed'),
(8, 3, 'Confirmed'),
(9, 4, 'Confirmed'),
(10, 5, 'Confirmed'),
(11, 6, 'Confirmed'),
(5, 7, 'Interested'),
(6, 8, 'Confirmed'),
(7, 9, 'Interested');

-- BOOKMARKS (10 rows)
INSERT INTO Bookmarks (user_id, event_id) VALUES
(5, 1),
(5, 4),
(6, 2),
(6, 5),
(7, 3),
(7, 6),
(8, 1),
(9, 4),
(10, 7),
(11, 10);

-- CLUB OFFICER REQUESTS (10 rows)
INSERT INTO ClubOfficerRequests (sjsu_id, justification, status, user_id, reviewed_by) VALUES
('1234567', 'I have been an active member for 2 years and want to help lead the club', 'Pending', 5, NULL),
('1234568', 'I have strong organizational skills and leadership experience', 'Approved', 6, 1),
('1234569', 'I am passionate about the club mission and can commit to leadership', 'Rejected', 7, 1),
('1234570', 'I want to contribute to the club as an officer', 'Pending', 8, NULL),
('1234571', 'I have event planning experience and leadership skills', 'Approved', 9, 1),
('1234572', 'I can help manage club finances and operations', 'Pending', 10, NULL),
('1234573', 'I am interested in joining the leadership team', 'Approved', 2, 12),
('1234574', 'I have relevant experience and time commitment', 'Rejected', 3, 1),
('1234575', 'I want to make a difference in the club', 'Approved', 4, 12),
('1234576', 'Leadership opportunity to serve members better', 'Pending', 11, NULL);
