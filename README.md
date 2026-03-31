# DOGESH 🐾

DOGESH is a comprehensive, all-in-one digital ecosystem built to revolutionize pet care. Designed with love for pet owners and focused on creating a trusted community, DOGESH connects users with verified, reliable service providers for all their pet care needs. 

Whether it's finding the perfect dog walker, booking a trusted pet sitter, or scheduling a grooming session, DOGESH ensures safe, structured, and seamless service delivery.

## 🌟 Key Features

* **Dual User Roles**: Seamless login for both Pet Owners and Service Providers.
* **Location-Based Discovery**: Interactive maps to discover nearby services and navigate with ease.
* **Real-Time Booking**: Instantly schedule, modify, and track service appointments.
* **Secure Payments**: Integrated Razorpay gateway to ensure safe and smooth digital transactions.
* **Review & Ratings**: A community-driven rating system to ensure quality and trust for all services.
* **Verified Providers**: A stringent vetting process prioritizing the safety and well-being of your pets.

## 🛠 Technology Stack

* **Frontend**: [Flutter](https://flutter.dev/) (Dart) 
* **Backend**: [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore)
* **Location Services**: Google Maps Platform 
* **Payments**: [Razorpay](https://razorpay.com/)

## 🚀 Getting Started

If you want to run this project locally, follow the steps below.

### Prerequisites

* Flutter SDK (Version 3.11.0 or higher)
* Dart SDK
* Android Studio / VS Code
* Firebase Account (for setting up backend services)
* Google Maps API Key
* Razorpay Test/Live Keys

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Yuvraj-Basu/dogesh_app.git
   cd dogesh_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   * Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   * Register your Android/iOS apps within the console (using `com.example.dogesh_app` or your specific package name).
   * Download the `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) and place them in their respective directories.
   * Run the flutterfire CLI to ensure initialization files are up to date.

4. **API Keys:**
   * Insert your Google Maps API key into the `AndroidManifest.xml` and `AppDelegate.swift`.
   * Add your Razorpay keys into the relevant environment or constant files.

5. **Run the App:**
   ```bash
   flutter run
   ```

## 📱 Screenshots

*(Add your app screenshots here to showcase the beautiful UI!)*

## 🤝 Contributing

We welcome community contributions! Please feel free to submit a Pull Request or open an Issue to improve the application.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
