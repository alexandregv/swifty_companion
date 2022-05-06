# swifty_companion

Mobile initiation at 42.  
The goal is to create a mobile app for the intra, allowing to search for a login, get its profile informations, projects, and skills/experiences.  
The user first has to login through OAuth2, with his own intra account.  
The app handles light and dark themes, and is responsive.  

### Screenshots
![Search view](./docs/images/search_dark.jpg "Search view [dark theme]")
![User view 1](./docs/images/user1_dark.jpg "A student view [dark theme]")
![User view 2](./docs/images/user2_dark.jpg "An anonymized student view [dark theme]")
![User projects view](./docs/images/projects_dark.jpg "Projects view [dark theme]")
![User experiences view](./docs/images/experiences_dark.jpg "Experiences view [dark theme]")
![User not found](./docs/images/user_not_found_dark.jpg "User not found [dark theme]")
![About view](./docs/images/about_dark.jpg "About view [dark theme]")
![Search view light theme](./docs/images/search_light.jpg "Search view [light theme]")
![User view light theme](./docs/images/user_light.jpg "User view [light theme]")


### Build and run

You will need the Android and Flutter SDKs, plus an API app of 42's intranet.  
Fill you app credentials in `lib/intra_http_service.dart`, and then build with `flutter build`.
