# SpartanClubConnect
CS157A Sec 1 Team 1 Project

SpartanClubConnect is a full-stack web application designed to help San José State University (SJSU) students discover, manage, and engage with campus clubs and events in a centralized platform.

---

## 🚀 Overview
This project provides a modern, Instagram-style interface where:
- Students can explore clubs and events
- Club officers can manage clubs and publish events
- Administrators can moderate content and manage users
The goal is to improve student engagement by replacing scattered platforms with a single, organized system.

---

## ✨ Features
### 👤 User Authentication
- User registration and login with secure password hashing
- Role-based access (Student, Club Officer, Admin)
- Session management and logout functionality

### 🏫 Club Management
- Create and edit club profiles
- Browse and search clubs by name or category
- Assign club officers to manage clubs

### 📅 Event Management
- Create, edit, and delete event posts
- View event feed and event details
- Events include title, date, location, and optional images

### ⭐ Student Engagement
- Follow/unfollow clubs
- Bookmark events
- Personalized event feed based on followed clubs

### 📝 RSVP System
- RSVP to events with capacity handling
- Cancel RSVP
- View registered events
 
### 🛠️ Admin Controls
- Approve/deny club officer requests
- Moderate or remove events
- Manage user accounts and roles

---

## 🧱 Tech Stack
Frontend
- HTML, CSS, JavaScript

Backend
- Java (JSP, JDBC)
- Apache Tomcat

Database
- MySQL

Tools
- MySQL Workbench
- IntelliJ IDEA / Eclipse

---

## 🗄️ Database Design
The system uses a relational database with key entities such as:
- Users (Students, Club Officers, Admins)
- Clubs
- Events
- RSVPs
- Bookmarks
- Follows

Relationships include many-to-many mappings like:
- Students ↔ Events (RSVPs)
- Students ↔ Clubs (Follows)
- Clubs ↔ ClubCategories (ClubCategoryMaps)

(See ERD diagram in /docs for full schema.)

---

## 🔐 Access Control
Role-Based Access Control (RBAC):
- Student: browse, follow, bookmark, RSVP
- Club Officer: manage clubs and events
- Admin: moderate content and manage users

---

## ⚙️ Setup Instructions
1. Clone the repository
```bash
git clone https://github.com/ObviousYordle/CS157A-S1-Team-1.git
cd SpartanClubConnect
```

2. Set up MySQL database
- Import schema from provided SQL files
- Configure database connection

3. Run the backend
- Deploy on Apache Tomcat

4. Open the app
- Navigate to `http://localhost:8080`

---

## 📈 Future Improvements
- Waitlist system for full events
- Enhanced UI/UX
- Notifications system
- Mobile responsiveness

---

## 👥 Team
- Anh Tran
- Trista Chen
- Alex Xavier

---

## 📄 License
This project is for academic purposes (CS157A - SJSU).
