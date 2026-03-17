CREATE DATABASE IF NOT EXISTS CS157SpartanClubConnect;
USE CS157SpartanClubConnect;
-- USERS (superclass)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN
);

-- STUDENTS (subclass of Users)
CREATE TABLE Students (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ADMIN (subclass of Users)
CREATE TABLE Admin (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- CLUB OFFICERS (subclass of Students)
CREATE TABLE ClubOfficers (
    user_id INT PRIMARY KEY,
    role VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Students(user_id)
);

-- CLUBS
CREATE TABLE Clubs (
    club_id INT AUTO_INCREMENT PRIMARY KEY,
    club_name VARCHAR(100),
    description TEXT,
    contact_email VARCHAR(100),
    meeting_info TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CLUB CATEGORIES
CREATE TABLE ClubCategories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- EVENTS
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    date DATE,
    start_time TIME,
    end_time TIME,
    location VARCHAR(200),
    capacity INT,
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN,
    club_id INT,
    created_by INT,
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id),
    FOREIGN KEY (created_by) REFERENCES ClubOfficers(user_id)
);

-- EVENT SESSIONS (weak entity)
CREATE TABLE EventSessions (
    event_id INT,
    session_number INT,
    PRIMARY KEY (event_id, session_number),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- CLUB OFFICER REQUESTS
CREATE TABLE ClubOfficerRequests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    sjsu_id VARCHAR(50),
    justification TEXT,
    status VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    reviewed_by INT,
    FOREIGN KEY (user_id) REFERENCES Students(user_id),
    FOREIGN KEY (reviewed_by) REFERENCES Admin(user_id)
);

-- MANAGES RELATIONSHIP
CREATE TABLE Manages (
    user_id INT,
    club_id INT,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, club_id),
    FOREIGN KEY (user_id) REFERENCES ClubOfficers(user_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id)
);

-- FOLLOWS RELATIONSHIP
CREATE TABLE Follows (
    user_id INT,
    club_id INT,
    followed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, club_id),
    FOREIGN KEY (user_id) REFERENCES Students(user_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id)
);

-- BOOKMARKS RELATIONSHIP
CREATE TABLE Bookmarks (
    user_id INT,
    event_id INT,
    saved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES Students(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- RSVPS RELATIONSHIP
CREATE TABLE RSVPs (
    user_id INT,
    event_id INT,
    rsvp_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES Students(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- CLUB CATEGORY MAPS
CREATE TABLE ClubCategoryMaps (
    club_id INT,
    category_id INT,
    PRIMARY KEY (club_id, category_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id),
    FOREIGN KEY (category_id) REFERENCES ClubCategories(category_id)
);