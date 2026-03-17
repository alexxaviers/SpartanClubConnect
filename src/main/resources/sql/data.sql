USE CS157SpartanClubConnect;

-- ==========================================
-- SAMPLE DATA FOR TESTING
-- ==========================================

-- USERS - Superclass with different roles
INSERT INTO Users (full_name, email, password_hash, is_active) VALUES
('Admin User', 'admin@sjsu.edu', 'hashed_password_1', TRUE),
('John Smith', 'john.smith@sjsu.edu', 'hashed_password_2', TRUE),
('Jane Doe', 'jane.doe@sjsu.edu', 'hashed_password_3', TRUE),
('Bob Johnson', 'bob.johnson@sjsu.edu', 'hashed_password_4', TRUE),
('Alice Williams', 'alice.williams@sjsu.edu', 'hashed_password_5', TRUE),
('Charlie Brown', 'charlie.brown@sjsu.edu', 'hashed_password_6', TRUE),
('Diana Prince', 'diana.prince@sjsu.edu', 'hashed_password_7', TRUE),
('Eve Martinez', 'eve.martinez@sjsu.edu', 'hashed_password_8', TRUE);

-- ADMIN
INSERT INTO Admin (user_id) VALUES
(1);

-- STUDENTS
INSERT INTO Students (user_id) VALUES
(2),
(3),
(4),
(5),
(6),
(7),
(8);

-- CLUB OFFICERS (students with officer roles)
INSERT INTO ClubOfficers (user_id, role) VALUES
(2, 'President'),
(3, 'Vice President'),
(4, 'Treasurer');

-- CLUB CATEGORIES
INSERT INTO ClubCategories (category_name) VALUES
('Academic'),
('Sports'),
('Arts'),
('Technology'),
('Social'),
('Professional');

-- CLUBS
INSERT INTO Clubs (club_name, description, contact_email, meeting_info) VALUES
('Computer Science Club', 'For students interested in computer science and programming', 'csclub@sjsu.edu', 'Mondays 5PM - Engineering Building Room 101'),
('Debate Club', 'Competitive debate and public speaking', 'debate@sjsu.edu', 'Wednesdays 6PM - Student Center'),
('Photography Club', 'Photography enthusiasts and professionals', 'photo@sjsu.edu', 'Thursdays 4PM - Campus Center'),
('Business Club', 'Students interested in business and entrepreneurship', 'business@sjsu.edu', 'Tuesdays 5:30PM - Business Building'),
('Anime Club', 'Fans of anime, manga, and Japanese culture', 'anime@sjsu.edu', 'Fridays 6PM - Student Union'),
('Environmental Club', 'Sustainability and environmental advocacy', 'eco@sjsu.edu', 'Saturdays 10AM - Student Center');

-- CLUB CATEGORY MAPS
INSERT INTO ClubCategoryMaps (club_id, category_id) VALUES
(1, 4),
(2, 6),
(3, 3),
(4, 6),
(5, 5),
(6, 5);

-- MANAGES RELATIONSHIP
INSERT INTO Manages (user_id, club_id) VALUES
(2, 1),
(3, 2),
(4, 3);

-- FOLLOWS RELATIONSHIP
INSERT INTO Follows (user_id, club_id) VALUES
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(5, 5),
(6, 6);

-- EVENTS
INSERT INTO Events (title, description, date, start_time, end_time, location, capacity, is_active, club_id, created_by) VALUES
('Python Workshop', 'Learn Python basics and coding fundamentals', '2026-04-15', '14:00:00', '16:00:00', 'Engineering Building 101', 50, TRUE, 1, 2),
('Weekly Debate Session', 'Practice debate skills in a competitive environment', '2026-04-10', '18:00:00', '20:00:00', 'Student Center Room 205', 30, TRUE, 2, 3),
('Photo Walk Around Campus', 'Explore and photograph beautiful campus locations', '2026-04-20', '10:00:00', '12:00:00', 'Campus Bell Tower', 25, TRUE, 3, 4),
('Entrepreneurship Panel', 'Talk with successful entrepreneurs about starting businesses', '2026-04-22', '16:00:00', '18:00:00', 'Business Building Auditorium', 100, TRUE, 4, 2),
('Anime Movie Night', 'Watch and discuss latest anime releases', '2026-04-25', '19:00:00', '21:30:00', 'Student Union Theater', 80, TRUE, 5, 3),
('Beach Cleanup Drive', 'Community service: clean up local beaches', '2026-05-01', '08:00:00', '11:00:00', 'Santa Cruz Beach', 40, TRUE, 6, 4);

-- EVENT SESSIONS
INSERT INTO EventSessions (event_id, session_number) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1);

-- RSVPS
INSERT INTO RSVPs (user_id, event_id, status) VALUES
(5, 1, 'Confirmed'),
(6, 1, 'Interested'),
(7, 2, 'Confirmed'),
(8, 3, 'Confirmed'),
(5, 4, 'Confirmed'),
(6, 5, 'Confirmed'),
(7, 6, 'Confirmed'),
(8, 1, 'Interested');

-- BOOKMARKS
INSERT INTO Bookmarks (user_id, event_id) VALUES
(5, 1),
(5, 4),
(6, 2),
(6, 5),
(7, 3),
(8, 6);

-- CLUB OFFICER REQUESTS
INSERT INTO ClubOfficerRequests (sjsu_id, justification, status, user_id, reviewed_by) VALUES
('1234567', 'I have been an active member for 2 years and want to help lead the club', 'Pending', 5, NULL),
('1234568', 'I have strong organizational skills and leadership experience', 'Approved', 6, 1),
('1234569', 'I am passionate about the club mission and can commit to leadership', 'Rejected', 7, 1);
