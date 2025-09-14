# TECH_NOTES.md

## Architecture Overview

The application follows a clean, layered architecture designed for scalability and testability.

1.  **State Management (Provider):** `provider` is used for state management due to its simplicity and effectiveness for this scale of application. `BusinessProvider` acts as the ViewModel, holding the UI state and business logic, and notifying listeners of any changes.

2.  **Repository Pattern:** A `BusinessRepository` is used to abstract the data sources. The UI (via the Provider) requests data from the repository, which is responsible for deciding where to get it from—either the network (`ApiService`) or the local cache (`PersistenceService`). This decouples the UI from the data implementation details.

3.  **Service Layer:**
    *   `ApiService`: Handles network requests using the `dio` package. For this project, it simulates a network call by fetching data from a local JSON asset.
    *   `PersistenceService`: Manages local data storage using `shared_preferences` for offline caching.

4.  **Model Layer:**
    *   The `Business` model is a clean domain object with validation in its `fromJson` factory. It throws an error if the incoming data is incomplete, ensuring data integrity.
    *   The `CardViewModel` is an abstract class that defines a contract for any data that can be displayed in `ReusableCard`. The `Business` model implements this, promoting a compositional and reusable UI.

5.  **UI Layer:**
    *   **Screens:** `BusinessListScreen` displays the list and handles all UI states (loading, success, error, empty). `BusinessDetailScreen` shows the details of a selected business.
    *   **Widgets:** `ReusableCard` is a generic widget that accepts any object implementing `CardViewModel`. This makes it easy to render different types of data (e.g., `Service`, `Product`) with the same card widget in the future.