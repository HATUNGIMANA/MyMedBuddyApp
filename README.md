# MyMedBuddyApp

MyMedBuddy is a Flutter-based mobile application that helps users manage their personal health records in a simple, intuitive way. The app allows users to log in, keep track of medications, monitor health logs, manage appointments, and update their profile — all from one place.

## Features

### Authentication
- Login and registration functionality with hardcoded user data (for prototype/demo purposes).
- User full name is stored using SharedPreferences.
- Session state is preserved across app restarts.

### Dashboard
- Greets the logged-in user by name.
- Displays summary cards for:
  - Next Medication
  - Missed Doses
  - Weekly Appointments
- Includes quick navigation grid to:
  - Medication Schedule
  - Health Logs
  - Appointments
  - Profile

### Medication Schedule
- Displays default medication list on first launch.
- Users can add new medications (name, dosage, and time).
- Data is stored persistently using SharedPreferences.

### Health Logs
- Users can record health status logs including date, summary, and notes.
- Logs persist between sessions.
- Ability to export all logs into a downloadable PDF file.

### Appointments
- Allows users to view upcoming appointments.
- Users can add new appointments including hospital, doctor, date, and time.
- Data is stored locally via SharedPreferences.

### Profile Management
- Displays full name, username, and profile photo.
- Allows editing of full name, age, condition, and medication reminders.
- Profile picture is selectable and saved persistently.
- Includes logout functionality that clears data and returns to login screen.

### Health Tips API Integration
- Retrieves a random health-related quote using a public API.
- Displayed on the dashboard.
- Shows loading spinner while fetching.
- Handles connection failure gracefully.

### Theme Management
- Light/Dark mode toggle built into dashboard.
- Theme choice is saved using SharedPreferences.

## Technologies Used

- **Flutter** (UI Framework)
- **Dart** (Programming Language)
- **SharedPreferences** (Local persistent storage)
- **ImagePicker** (Profile image selection)
- **PathProvider** (Persistent file paths)
- **PDF & Printing** (Export health logs as PDF)
- **HTTP** (API integration)
