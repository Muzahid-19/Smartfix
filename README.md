# SmartFix — Smart Complaint & Service Management System

SmartFix is a web-based complaint and service management application designed to help apartments, colleges, offices, and hostels manage maintenance complaints efficiently. It provides a centralized platform for users to submit complaints and for administrators and staff to manage and track their resolution.

## Features

- **User Management:** User registration, login, and role-based access.
- **Complaint Management:** Submit and manage service complaints.
- **Complaint Categories:** Electrical, Plumbing, Internet, and Cleaning.
- **Priority Management:** Set complaint priorities to Low, Medium, or High.
- **Status Tracking:** Track complaints through Pending, Assigned, In Progress, and Resolved.
- **Staff Assignment:** Administrators can assign complaints to staff members.
- **Complaint Updates:** Staff can update complaint progress.
- **Comments and Feedback:** Support communication and ratings for completed services.
- **Password Management:** Password reset and change-password functionality.
- **Admin Dashboard:** Manage complaints, staff assignments, and service progress.

## Technology Stack

| Layer | Technologies |
|---|---|
| Frontend | HTML, CSS, JSP |
| Backend | Java, Java Servlets |
| Database Connectivity | JDBC |
| Database | MySQL |
| Server | Apache Tomcat 10.1 |
| Development Environment | Eclipse IDE |

## Application Workflow

1. Users log in and submit service complaints.
2. Users select a complaint category and priority.
3. Administrators review complaints and assign them to staff.
4. Staff members work on assigned complaints and update their status.
5. Users can track complaint progress and provide feedback after resolution.

## User Roles

- **User:** Submits complaints, tracks progress, and provides feedback.
- **Admin:** Manages complaints and staff assignments.
- **Staff:** Views assigned complaints and updates service status.

## Database

SmartFix uses MySQL to store application data. The database supports user and staff accounts, complaints, complaint history, comments, notifications, password-reset OTPs, and ratings, depending on the tables configured in the project.

## Getting Started

### Prerequisites

Install the following software:

- Java JDK compatible with your project configuration
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 10.1
- MySQL Server
- MySQL Workbench (optional, for database management)

### Installation

1. Clone or download this repository.
2. Import the project into Eclipse.
3. Create the SmartFix database in MySQL.
4. Configure the database connection settings in the project.
5. Verify that the required database tables exist.
6. Configure Apache Tomcat in Eclipse.
7. Add the project to the Tomcat server.
8. Run the application on the server.

> **Note:** Database setup scripts and connection configuration should be provided separately if they are not included in this repository. Do not commit real database passwords or email credentials.

## Project Objectives

- Simplify maintenance complaint registration and tracking.
- Improve coordination between users, administrators, and service staff.
- Make complaint assignment and resolution progress easier to monitor.
- Maintain centralized records of service requests and their status.

## Future Enhancements

- Email and real-time status notifications.
- Improved analytics and reporting dashboards.
- Mobile-responsive interface improvements.
- Advanced complaint filtering and search.
- Integration with additional notification services.

## Author

**Muzahid Ali Baig**

GitHub: [@Muzahid-19](https://github.com/Muzahid-19)

## License

A license has not yet been specified for this project.
