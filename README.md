🚗 Renting Car – Mobile Car Rental App

A modern and scalable Car Rental Mobile Application built with Flutter and powered by Firebase.

This app allows users to browse available cars, view details, check locations on map, and manage bookings efficiently with a clean architecture and scalable state management.

✨ Features

🔍 Browse available rental cars

📄 View detailed car information

🗺 View car locations using interactive maps

🔥 Firebase Firestore integration

📡 Internet connection handling

💾 Local storage with Shared Preferences

🧠 Scalable state management using BLoC

🌐 API integration support

🖼 Cached network images

🏗 Architecture

The project follows Clean Architecture principles with:

flutter_bloc for state management

get_it for dependency injection

dartz for functional programming (Either, Failure handling)

Repository pattern

Separation of Presentation, Domain, and Data layers

🛠 Tech Stack

Flutter (SDK ^3.8.1)

Firebase Core

Cloud Firestore

Flutter Map + LatLong2

Cached Network Image

BLoC & Equatable

HTTP

Connectivity Plus

Shared Preferences

📦 Dependencies
firebase_core
cloud_firestore
flutter_bloc
get_it
dartz
cached_network_image
flutter_map
latlong2
connectivity_plus
internet_connection_checker
shared_preferences
http
url_launcher

🚀 Getting Started
1️⃣ Clone the repository
git clone https://github.com/yobernu/renting_car.git
cd renting_car

2️⃣ Install dependencies
flutter pub get

3️⃣ Run the app
flutter run

🔥 Firebase Setup

Create a Firebase project.

Enable Cloud Firestore.

Add Android/iOS app to Firebase.

Download and configure:

google-services.json (Android)

GoogleService-Info.plist (iOS)

Run:

flutterfire configure

📁 Assets

All app assets are located inside:

assets/

📄 License

This project is private and not published to pub.dev.
