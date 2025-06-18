# faceit

For the initial version of this application we will just have Bancolombia support. If you wish to add support for other banks, please open an issue or a pull request.

---

## Project Overview

The technology decisions for the mobile app look something like this:
- **Mobile App Framework:** Flutter
- **UI Library:** Forui (https://forui.dev/)
- **Local Database:** SQLite or Brick
- **State Management:** Cubit (Note: We want simplicity thats why we are not just using Bloc)

Additionally, we will use the following project structure:

```
faceit/
├── lib/
│   ├── app/
│   │   ├── cubit/
│   │   │   └── app_cubit.dart
│   │   │   └── app_state.dart
│   │   └── view/
│   │       └── app.dart
│   │
│   ├── core/
│   │   ├── api/
│   │   │   └── supabase_client.dart
│   │   ├── db/
│   │   │   └── sqlite_client.dart
│   │   ├── di/
│   │   │   └── injection.dart
│   │   ├── models/
│   │   │   └── transaction_model.dart
│   │   │   └── user_model.dart
│   │   ├── routing/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   ├── utils/
│   │   │   └── constants.dart
│   │   │   └── formatters.dart
│   │   └── widgets/
│   │       └── loading_indicator.dart
│   │       └── custom_scaffold.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── dashboard/
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   └── transactions/
│   │       ├── cubit/
│   │       │   ├── transactions_cubit.dart
│   │       │   └── transactions_state.dart
│   │       ├── data/
│   │       │   ├── data_sources/
│   │       │   │   ├── transactions_local_data_source.dart
│   │       │   │   └── transactions_remote_data_source.dart
│   │       │   └── repository/
│   │       │       └── transactions_repository.dart
│   │       └── presentation/
│   │           ├── screens/
│   │           │   └── transactions_screen.dart
│   │           └── widgets/
│   │               └── transaction_list_item.dart
│   │               └── filter_chip_bar.dart
│   │
│   └── main.dart
│
├── pubspec.yaml
├── test/
└── ... (otros archivos del proyecto)
```


---

## System Architecture

This document outlines the architecture of the expense tracking application. The system is designed to be event-driven, scalable, and real-time, providing a seamless offline-first experience for the end-user.

### High-Level Goal

The primary goal is to automatically capture financial transactions by parsing notification emails from a specific bank sender (`sender@bb.com`). This data is then stored centrally and synchronized in real-time with a Flutter mobile application, which remains fully functional even without an internet connection.

### Architectural Diagram

The architecture is split into two main flows: a **Data Ingestion Flow** (backend) responsible for capturing and processing emails, and a **Data Synchronization Flow** (client-side) responsible for keeping the mobile app's data current.

```
      +---------------------------------------------------------------------------------+
      | DATA INGESTION FLOW (BACKEND)                                                   |
      +---------------------------------------------------------------------------------+
      |                                                                                 |
[1. Gmail] --(Push Notification via Users.watch)--> [2. Google Cloud Pub/Sub]
      |                                                        |
      |                                                        | (Triggers)
      |                                                        V
      |                                             [3. Google Cloud Function]
      |                                                 - Fetches email via Gmail API
      |                                                 - Parses content for transaction data
      |                                                 - Inserts data into the database
      |                                                        |
      |                                                        V
      +--------------------------------------------> [4. Supabase PostgreSQL DB] <-------+
                                                                 ^                       |
                                                                 | (Logical Replication) |
                                                                 |                       |
                                                     [5. Supabase Realtime Server]       |
                                                                 |                       |
                                                                 | (WebSocket Message)   |
      +----------------------------------------------------------------------------------+
      | DATA SYNCHRONIZATION FLOW (CLIENT)                                               |
      +----------------------------------------------------------------------------------+
      |                                                                                  |
      |                                                                                  |
      +--------------------------------------------> [6. Flutter Application] <----------+
                                                         |       ^
                                                         |       | (API Calls for local changes)
                                                         V       |
                                                 [7. Local SQLite Database]
```

### Component Breakdown

#### 1. Gmail API
*   **Role:** The entry point for all automated transaction data.
*   **Function:** We use the Gmail API's `Users.watch()` method to subscribe to push notifications. This allows our system to be notified in real-time whenever a new email arrives that matches our filter (`from:sender@bb.com`).
*   **Justification:** This event-driven approach is vastly more efficient and scalable than traditional polling (checking for new emails every few minutes), and it avoids hitting API rate limits.

#### 2. Google Cloud Pub/Sub
*   **Role:** A reliable, high-throughput message broker.
*   **Function:** It acts as the destination for the push notifications sent by the Gmail API. When Gmail detects a new email, it publishes a small message to a specific Pub/Sub topic.
*   **Justification:** The use of Google Cloud Pub/Sub is a **mandatory requirement** of the Gmail API's `watch` feature. It effectively decouples the email source (Gmail) from our processing logic, ensuring that notifications are not lost even if our backend is temporarily down.

#### 3. Google Cloud Function
*   **Role:** The serverless data processor.
*   **Function:** This function is configured to trigger whenever a new message appears in our Pub/Sub topic. Its responsibilities are:
    1.  Receive the notification message.
    2.  Use the user's stored OAuth 2.0 token to securely call the Gmail API and fetch the full content of the new email.
    3.  Parse the email body to extract structured transaction data (e.g., amount, date, merchant).
    4.  Connect to our central database and insert the new transaction as a new row.
*   **Justification:** A serverless function is perfect for this task. It's cost-effective (pay-per-use), scales automatically, and integrates natively with Pub/Sub.

#### 4. Supabase: PostgreSQL Database
*   **Role:** The central, authoritative source of truth for all user data.
*   **Function:** A standard, robust PostgreSQL database that stores all transaction records, user information, and other application data.
*   **Justification:** PostgreSQL is a powerful, open-source, and highly reliable relational database. Using it via Supabase gives us the benefits of a standard technology while also enabling the real-time capabilities described next.

#### 5. Supabase: Realtime Server
*   **Role:** The real-time data synchronization engine.
*   **Function:** This server listens directly to changes in the PostgreSQL database via logical replication. When it detects an `INSERT`, `UPDATE`, or `DELETE` on a tracked table (e.g., `transactions`), it broadcasts a message with the new data over a persistent WebSocket connection to any subscribed clients.
*   **Justification:** This is the key component that enables real-time functionality in the app without any custom backend code. It turns our database into a real-time API.

#### 6. Flutter Application
*   **Role:** The user-facing client.
*   **Function:** The mobile app, built with Flutter. It subscribes to the Supabase Realtime server to receive live updates. It also handles user-initiated actions, such as adding a transaction manually.
*   **Justification:** Flutter allows for cross-platform development from a single codebase.

#### 7. Local SQLite Database
*   **Role:** The client-side cache and offline data store.
*   **Function:** The Flutter app maintains a local SQLite database. All data displayed in the UI is read from this local database, ensuring the app is always fast and functional, even without an internet connection.
*   **Justification:** This provides a true **offline-first** experience. The app is not dependent on network latency for its core functionality. When online, this local database is kept in sync with the central PostgreSQL database via the Supabase Realtime listener. When local changes are made offline, they are queued and sent to the server once connectivity is restored.
