## 📽️ Demo Video
<p align="center">
  <video src="https://github.com/user-attachments/assets/7d4bb80a-3153-4d20-928b-1ca58e466a57"
         width="250"
         autoplay
         loop
         muted
         playsinline>
  </video>
</p>





### 📱 Lead Management App (Flutter)

## 📌 App Overview

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



## ▶️ How to Run the App
1. Install dependencies
flutter pub get

2. Run the app
flutter run

3. Build release APK
flutter build apk

## 🏗️ Architecture

```text
lib/
│── data/
│     └── db_helper.dart            → SQLite database operations
│
│── models/
│     └── lead.dart                 → Lead model with map/json support
│
│── providers/
│     ├── lead_provider.dart        → CRUD, pagination, search, filters
│     └── theme_provider.dart       → Light/Dark mode switch
│
│── screens/
│     ├── lead_list_screen.dart     → Lead list with filter + pagination
│     ├── lead_form_screen.dart     → Add/Edit lead form
│     └── lead_detail_screen.dart   → Lead details & delete
│
│── widgets/
│     └── lead_card.dart            → Animated modern lead card
│
└── main.dart                       → App entry, providers, themes

```




## 📦 Packages Used

| Package        | Purpose                               |
|----------------|----------------------------------------|
| provider       | State management                       |
| sqflite        | Local SQLite database                  |
| path_provider  | Access device file paths               |
| share_plus     | Export / share JSON files              |
| uuid           | Generate unique Lead IDs               |
| intl           | Date & time formatting                 |

