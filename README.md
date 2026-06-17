# Pulse

A real-time macOS system monitor built with Flutter Desktop.

![Dashboard screenshot](assets/screenshots/dashboard.png)

## Features

- **Dashboard** — real-time CPU load (circular gauge), memory usage (horizontal bar + breakdown), storage info, and temperature with sparkline history
- **Sidebar navigation** — switch between Dashboard, Processes, Thermal, and Cleaner views with animated transitions
- **Live polling** — all system metrics refresh every second via native macOS APIs through Flutter MethodChannels
- **Dark theme** — glassmorphism cards with custom gradient background

### Planned

- Processes view (running process list)
- Thermal view (throttling state)
- Cleaner view (cache and temp file cleanup)

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter Desktop (macOS) |
| **State management** | flutter_bloc (Bloc pattern) |
| **Architecture** | Clean Architecture (data / domain / ui) |
| **Dependency injection** | get_it (lazy singletons + factories) |
| **Localization** | easy_localization (English) |
| **Icons** | flutter_svg (custom SVG set) |
| **Native bridge** | Flutter MethodChannel (Swift) |
| **Target** | macOS 10.15+ (sandboxed) |

## Architecture

```
lib/
├── core/                     # Shared across features
│   ├── dependency_injection/ # GetIt registrations
│   ├── domain/enums/         # Cross-cutting enums
│   ├── extensions/           # doublex, widgetx
│   ├── theme/                # Colors, fonts, ThemeData
│   └── ui/widgets/           # Reusable widgets
│
└── features/
    ├── dashboard/            # Fully implemented
    │   ├── data/             # Datasources, models, repos
    │   ├── domain/           # Entities, use cases, repo interfaces
    │   └── ui/               # Bloc, view, parts, widgets
    │
    ├── main/                 # Navigation shell
    │   └── ui/               # Bloc, page, sidebar
    │
    ├── cleaner/              # Stub
    ├── processes/            # Stub
    └── thermal/              # Stub
```

Each feature follows the same data flow: **UI → Bloc → UseCase → Repository → DataSource → MethodChannel → macOS**.

## Requirements

- macOS 10.15 or later
- Flutter SDK 3.11+
- Xcode 15+

## Getting Started

```bash
# Clone the repository
git clone https://github.com/your-username/pulse.git
cd pulse

# Install dependencies
flutter pub get

# Run on macOS
flutter run -d macos
```

## Build

```bash
flutter build macos
```

The app is sandboxed by default (`com.apple.security.app-sandbox`) and does not require extra entitlements.

## Project Status

**Active development.** The Dashboard feature is complete and functional. Processes, Thermal, and Cleaner views are stubs awaiting implementation.
