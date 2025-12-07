# Symmetry Applicant Showcase App

A production-ready News Application developed as part of the Symmetry selection process. This project demonstrates the implementation of a robust, scalable mobile application using **Flutter** and **Clean Architecture**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Clean%20Architecture-Success?style=for-the-badge)

## 📱 Project Overview

This application goes beyond a simple news reader. It implements a modern, social-media-style experience for consuming content, featuring a vertical "TikTok-style" feed, real-time search, and content creation capabilities.

**[🎥 Watch the Demo Videos (Google Drive)](https://drive.google.com/drive/folders/1YtIU8I4XEX1ui7eoLc0T9qgHSYPbB5gx?usp=sharing)**

**[📄 Read the Full Development Report](./docs/REPORT.md)**

## ✨ Key Features

*   **Vertical News Feed:** Immersive, full-screen scrolling experience for discovering news.
*   **Real-time Search:** Instant search functionality with chronological ordering.
*   **Content Creation:** Journalists can create articles with images (uploaded to Firebase Storage) and external URLs.
*   **Optimistic UI:** Instant feedback on interactions like "Liking" an article, ensuring a snappy user experience.
*   **Interactive Animations:** "Double-tap to like" with heart animation and shimmer loading effects.
*   **Profile Management:** Secure profile editing with local storage persistence.
*   **Smart Dates:** Relative time formatting (e.g., "5 mins ago") for better context.

## 🛠️ Tech Stack & Architecture

The project adheres to strict **Clean Architecture** principles to ensure separation of concerns and testability.

*   **Presentation Layer:** Flutter BLoC (Cubits) for state management.
*   **Domain Layer:** Pure Dart entities and use cases (Business Logic).
*   **Data Layer:** Repository implementations, Remote Data Sources (Retrofit/Dio), and Firebase integration.
*   **Backend:** Firebase Firestore (NoSQL Database) & Firebase Storage.
*   **Dependency Injection:** `get_it` for service location.

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/symmetry-applicant-showcase.git
    ```

2.  **Install dependencies:**
    ```bash
    cd frontend
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## 📂 Documentation

*   [**Development Report**](./docs/REPORT.md): Detailed breakdown of the development process, challenges, and solutions.
*   [**App Architecture**](./docs/APP_ARCHITECTURE.md): Explanation of the architectural decisions.
*   [**Database Schema**](./backend/docs/DB_SCHEMA.md): Structure of the Firestore database.

---
*Developed by Jesus Beleno for Symmetry.*
