# swifty_companion

Mobile initiation at 42.  
The goal is to create a mobile app for the intra, allowing to search for a login, get its profile informations, projects, and skills/experiences.  
The user first has to login through OAuth2, with his own intra account.  
The app handles light and dark themes, and is responsive.  

### Screenshots
<p float="left">
  <img src="./docs/images/search_dark.jpg" alt="Search view in dark theme" width="270" height="585">
  <img src="./docs/images/user1_dark.jpg" alt="Anonymized student view in dark theme" width="270" height="585">
  <img src="./docs/images/user2_dark.jpg" alt="Anonymized student view in dark theme" width="270" height="585">
  <img src="./docs/images/projects_dark.jpg" alt="Experiences view in dark theme" width="270" height="585">
  <img src="./docs/images/experiences_dark.jpg" alt="Projects view in dark theme" width="270" height="585">
  <img src="./docs/images/user_not_found_dark.jpg" alt="User not found in dark theme" width="270" height="585">
  <img src="./docs/images/about_dark.jpg" alt="About view in dark theme" width="270" height="585">
  <img src="./docs/images/search_light.jpg" alt="Search view in light theme" width="270" height="585">
  <img src="./docs/images/user_light.jpg" alt="Search view in light theme" width="270" height="585">
</p>

### Build and run
You will need the Android and Flutter SDKs, plus an API app of 42's intranet.  
Fill your app credentials in `lib/intra_http_service.dart`, and then build with `flutter build`.  
You can run it on a usb-connected mobile with `flutter run` or `flutter run -d '<device-name>'`.  
