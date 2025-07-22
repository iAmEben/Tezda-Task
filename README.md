# tezda_task

## TestMall

A Flutter e-commerce app with user login, registration, product listing, and profile display. Uses https://api.escuelajs.co for authentication and product data, with a Swift MethodChannel for iOS device info.


## Prerequisites:

Flutter SDK (>=3.0.0)
Dart (>=2.17.0)
Xcode (for iOS)
Android Studio (for Android)


### Setup:
git clone <repository-url>
cd testmall
flutter pub get
cd ios && pod install


### Generate Routes:
flutter pub run build_runner build --delete-conflicting-outputs


### Run:
flutter run


iOS: Use simulator or device (iOS 12.0+).
Android: Use emulator or device.



## Design Choices

Architecture: Uses Riverpod for state management, AutoRoute for navigation, and SharedPreferences for token storage. Profile data is fetched in ProfileScreen to ensure fresh data, reducing AuthState complexity.<br>
<br>
UI: Static styles (TextStyle, ElevatedButton.styleFrom) in ProfileScreen and ProductCard for consistency.<br>
<br>
Authentication: Tokens saved before navigating to ProductListScreen. 20-day token expiration checked in SplashScreen and AuthNotifier. Also, data is persistent, users do not have to sign in when they successfully sign in. <br>
<br>
Swift Integration: Need a few more hours to complete this as I spent time downloading required packages and my cocoapods seemed to to sync with flutter so import (flutter) statement is not recognised in AppDelegate. <br>
<br>
CFBundleIdentifier (com.iameben.testmall) across Info.plist and MethodChannel. Android fallback returns "Device info not available".



## Challenges:
I had time constraint so I was unable to use customwidgets across the app and could not completely  finish the task (EditProfileScreen and the AppDelegate file only).
<img width="1313" height="458" alt="Screenshot 2025-07-22 at 10 49 50" src="https://github.com/user-attachments/assets/1f4ddec4-76f8-4415-bb49-003162d8f112" />
The dummy api was a bit inconsistent (sometimes it populates data, other times it does not) so I wrote error handler to show a text in cases that it returns nothing.
Managing API timeouts and errors with fallbacks (John Williams, john.williams@gmail.com, https://picsum.photos/200).

Despite these limitations, the core authentication flow, routing, state management with Riverpod, and API integration were successfully implemented and demonstrate a solid foundation for further development.

Thank you and I look forward to learning and growing with you!


