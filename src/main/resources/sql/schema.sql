CREATE DATABASE IF NOT EXISTS CS157SpartanClubConnect;
USE CS157SpartanClubConnect;

-- USERS
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN,
    deactivated_by INT NULL,
    deactivated_at DATETIME NULL,
    deactivation_reason VARCHAR(255) NULL,
    FOREIGN KEY (deactivated_by) REFERENCES Users(user_id)
);

-- ROLES
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE
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
    category VARCHAR(100),
    capacity INT,
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN,
    club_id INT,
    created_by INT,
    moderated_by INT NULL,
    moderated_at DATETIME NULL,
    moderation_reason VARCHAR(255) NULL,
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (moderated_by) REFERENCES Users(user_id)
);

-- CLUB OFFICER REQUESTS
CREATE TABLE ClubOfficerRequests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    sjsu_id VARCHAR(9) NOT NULL,
    club_name VARCHAR(255) NOT NULL,
    justification TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    reviewed_by INT NULL,
    reviewed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (reviewed_by) REFERENCES Users(user_id)
);

-- USER ROLES
CREATE TABLE UserRoles (
    user_id INT,
    role_id INT,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- FOLLOWS
CREATE TABLE Follows (
    user_id INT,
    club_id INT,
    followed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, club_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id)
);

-- BOOKMARKS
CREATE TABLE Bookmarks (
    user_id INT,
    event_id INT,
    saved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- RSVPS
CREATE TABLE RSVPs (
    user_id INT,
    event_id INT,
    rsvp_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- MANAGES
CREATE TABLE Manages (
    user_id INT,
    club_id INT,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, club_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id)
);

-- CLUB CATEGORY MAPS
CREATE TABLE ClubCategoryMaps (
    club_id INT,
    category_id INT,
    PRIMARY KEY (club_id, category_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id),
    FOREIGN KEY (category_id) REFERENCES ClubCategories(category_id)
);
