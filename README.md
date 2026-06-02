# 📚 Open Library App

A feature-rich Flutter application integrated with the **Open Library API** for book discovery and **Firebase Realtime Database** for user management and book borrowing.

## 🚀 Key Features

### **🔍 Book Discovery**
*   **Global Search**: Search for any book by title or author using the Open Library API.
*   **Rich Details**: Deep-dive into book information, including high-resolution covers, full descriptions, and subject tags.
*   **Author Profiles**: View biographies and background information for your favorite authors.
*   **Trending & Subjects**: Discover what's popular or browse books by categories like Science Fiction.

### **🔐 Authentication & User Profiles**
*   **Firebase Auth**: Secure Email and Password registration and login.
*   **Profile Sync**: User names and emails are automatically mirrored in the Realtime Database upon registration.
*   **Persistence**: The app maintains your login session using a reactive Auth Wrapper.

### **📖 Library Management (Realtime)**
*   **Borrowing System**: Checkout books with a 7-day due date automatically calculated.
*   **My Borrowed Books**: A live list of your current checkouts with the ability to return books instantly.
*   **Availability Status**: Real-time tracking of whether a book is available for borrowing or currently checked out.
*   **Favorites**: One-tap bookmarking to save books to your personal cloud collection.

---

## 📁 Folder Structure

```text
lib/
├── auth/           # Firebase Auth logic and Login/Register screens
├── config/         # App constants, themes, and API endpoints
├── firebase/       # Realtime Database service for Favorites
├── models/         # Data structures (BookModel)
├── screens/        # Primary UI views (Search, Details, Trending, etc.)
├── services/       # API integration and Library borrowing logic
├── utils/          # Helper functions and formatters
└── widgets/        # Reusable UI components (BookCard, Loading, etc.)
```

---

## 🛠️ Setup & Installation

### **1. Firebase Setup**
*   **Create Project**: Start a project on the [Firebase Console](https://console.firebase.google.com/).
*   **Enable Auth**: Turn on **Email/Password** in the Authentication tab.
*   **Realtime Database**: Create a database (US or Singapore region) and set rules to:
    ```json
    { "rules": { ".read": "true", ".write": "true" } }
    ```
*   **Web Support**: Add a **Web App** to get your `apiKey` and `appId` for Chrome.

### **2. App Configuration**
*   Update `lib/main.dart` with your specific Firebase Web Options.
*   Ensure `android/app/google-services.json` is present for Android devices.

### **3. Launch**
```bash
flutter pub get
flutter run
```

---

## 🔗 Powered By
*   **Open Library API**: [openlibrary.org](https://openlibrary.org/dev/docs/api/)
*   **Firebase Realtime Database**
*   **Flutter & Dart**
