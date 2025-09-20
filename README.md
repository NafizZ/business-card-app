"# Business Card App" 

A Flutter application that showcases a list of businesses and their contact information. This project is built with a focus on clean architecture, testability, and best practices.

## Features

- **Business Discovery:** View a list of businesses fetched from a remote API.
- **Offline Support:** Caches data locally using SharedPreferences to provide offline access.
- **Detailed View:** Tap on a business to see more details.
- **Error Handling:** Gracefully handles network errors and falls back to cached data.

## Tech Stack & Architecture

This project follows a clean architecture pattern, separating concerns into distinct layers:

- **Presentation:** Contains the UI (Widgets/Screens) and state management (Providers).
- **Domain:** (Implicit) Contains the business logic and entities.
- **Data:** Contains repositories and data sources (API and local cache).

### Key Dependencies
- **State Management:** `provider`
- **Networking:** `dio`
- **Service Locator:** `get_it`
- **Routing:** `go_router`
- **Local Storage:** `shared_preferences`
- **Value Equality:** `equatable`
- **Testing:** `flutter_test`, `mockito`
- **Linting:** `flutter_lints`

## Getting Started

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed.
- An editor like VS Code or Android Studio.

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/NafizZ/business-card-app.git
   ```
2. **Navigate to the project directory:**
    ```sh
    cd business-card-app
    ```
3. **Install dependencies:**
    ```sh
    flutter pub get
    ```
4. **Run the app:**
    ```sh
    flutter run
    ```

## Testing

This project includes unit and widget tests. To run the tests, execute the following command:

```sh
flutter test
```

