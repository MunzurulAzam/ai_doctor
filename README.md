# Dr. AI - Your Medical Assistant

Dr. AI is an advanced, Flutter-based mobile application developed to act as your personal medical assistant. It combines state-of-the-art technology with medical expertise to provide users with a comprehensive healthcare companion right on their smartphones. The application offers a range of features designed to make healthcare information and services easily accessible, ensuring users can manage their medical needs effectively and promptly.

## Key Capabilities

- **`Medical Queries`:** Users can ask medical questions and receive accurate, timely responses. This feature is powered by a robust backend that sources information from reliable medical databases and expert systems, ensuring the advice and information provided are trustworthy and up-to-date.

- **`Hospital Locator`:** In case of emergencies, users can leverage the integrated Google Maps functionality to search for hospitals. The app provides real-time data on the nearest hospitals, helping users navigate quickly to the closest medical facility when every second counts.


- **`Emergency Support`:** The application features an emergency support system that allows users to initiate a chat with a medical assistant or call emergency services directly from the app. This ensures that users can get immediate help in critical situations.

- **`Data Privacy and Control`:** Users have full control over their personal data. The app includes options to show or hide specific information, ensuring that users can manage their privacy preferences according to their comfort level. All data is securely stored in Firebase, adhering to best practices in data security and privacy.

## Technical Stack

- **`App`:** Developed using Flutter, the app boasts a responsive and intuitive user interface.

- **`Backend`:** Firebase serves as the backbone for data storage, authentication, and real-time database management, ensuring reliable and secure data handling.

- **`APIs and Integrations`**: The app integrates various third-party APIs such as ChatGPT 4 & Gemini-1.5-flash for medical assistant, Google Maps for location services.
- **`Data Storage`**: Hive database is used for storing chat messages locally, providing fast and efficient data retrieval.

## Installation

To get started with the Dr. AI mobile application, follow these steps:

- **`Step 1`:** Clone the Repository
First, you'll need to clone the repository from GitHub. Open your terminal and run the following command:
```
git clone https://github.com/MAHMOUDELSAYED7/DR-AI.git
```
Replace <repository-url> with the actual URL of your repository if it was changed.

- **`Step 2`:** Install Dependencies
After navigating to the project directory, you need to install all the necessary dependencies. Run:
```
flutter pub get
```
This command fetches all the dependencies listed in the `pubspec.yaml` file.

- **`Step 3`:** Set Up Firebase
Dr. AI uses Firebase for authentication, data storage, and other backend services. Follow these steps to set up Firebase:

1. Add `Firebase` to Your Project:

- Go to the `Firebase Console`.

- Create a new project or select an existing one.

- Add an Android to your Firebase project.

2. Download Configuration Files:

- Download the google-services.json file and place it in the android/app directory.
 
3. Initialize Firebase in Your Project:

- Open main.dart and initialize Firebase by adding the following code:

```
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

- **`Step 4`:** Configure the App
Ensure all necessary configurations are done. This includes adding your assets and setting up environment variables if needed. Verify that your `pubspec.yaml` file includes all required `assets` and `fonts`.

- **`Step 5`:** Run the Application
Finally, run the application on your desired device using the following command:
`
```
flutter run
```
This command compiles your Flutter app and deploys it to the connected device or simulator.

Additional Tips
`Updating Dependencies:` If there are any updates to the dependencies, you can update them using:
```
flutter pub upgrade --major-versions
```
Flutter Doctor: Run flutter doctor to ensure that your development environment is set up correctly.
```
flutter doctor
```
This command checks your environment and displays a report of the status of your Flutter installation, dependencies, and connected devices.

By following these steps, you'll have the Dr. AI app up and running on your device, ready to serve as your personal medical assistant. If you encounter any issues during installation, please refer to the Flutter documentation or the Firebase setup guide for additional help.

