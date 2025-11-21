📽️


<a href="https://github.com/user-attachments/assets/628aaa47-66a5-4976-91f8-4e5214ff4acb">
  <img src="https://github.com/user-attachments/assets/628aaa47-66a5-4976-91f8-4e5214ff4acb" width="260" />
</a>





📱 Lead Management App (Flutter)
📌 App Overview

A simple and modern Lead Management App built with Flutter.
It allows users to:

Add, edit, delete leads

Search and filter leads

View complete lead details

Manage status (New, Contacted, Converted, Lost)

Store all data offline using SQLite

Export all leads as a JSON file

Enjoy smooth animations and pagination

Switch between light/dark mode

The app follows clean UI/UX and performs fully offline.


▶️ How to Run the App
1. Install dependencies
flutter pub get

2. Run the app
flutter run

3. Build release APK
flutter build apk

🏗️ Architecture

lib/
 │── data/
 │     └── db_helper.dart          → SQLite storage
 │
 │── models/
 │     └── lead.dart               → Lead model + mapping
 │
 │── providers/
 │     ├── lead_provider.dart      → CRUD, pagination, search, filters
 │     └── theme_provider.dart     → Light/Dark theme
 │
 │── screens/
 │     ├── lead_list_screen.dart   → Home with list, search, filters, pagination
 │     ├── lead_form_screen.dart   → Add/Edit lead form
 │     └── lead_detail_screen.dart → Lead detail view
 │
 │── widgets/
 │     └── lead_card.dart          → Animated modern lead card
 │
 └── main.dart                     → App entry + providers + theme config



📦 Packages Used

Package	                     Purpose
provider	               State management
sqflite	                 Local database (SQLite)
path_provider	           Get device paths
share_plus	             Export JSON file
provider                 State management
uuid                     Generate unique IDs for leads
intl                     Date formatting

