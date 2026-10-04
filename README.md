# Weatherly 🌤️

[![CI](https://github.com/keertibaratam/weather-dashboard/actions/workflows/ci.yml/badge.svg)](https://github.com/keertibaratam/weather-dashboard/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/keertibaratam/weather-dashboard)](LICENSE)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue)

A production-quality Flutter weather dashboard built with **clean architecture** and
**feature-first organization**. Real weather data and city search come from the free,
open [Open-Meteo](https://open-meteo.com/) API — **no API keys required**.

## ✨ Features

- **Current weather** - temperature, feels-like, humidity, wind, precipitation, sunrise/sunset
- **Hourly & daily forecasts** - next 24 hours and a 7-day outlook from Open-Meteo
- **Location search** - debounced city search with geocoding
- **Favorites** - save and quickly switch between saved places
- **Offline caching** - Hive-based cache with a *"Last updated"* banner when serving cached data
- **Settings** - Celsius/Fahrenheit toggle and Light/Dark/System theming
- **Deep-linkable screens** - named routes keep navigation reflected in the browser URL on web

## 🧰 Tech stack

| Area                  | Choice                                              |
| --------------------- | --------------------------------------------------- |
| UI framework          | [Flutter](https://flutter.dev) (Material 3)         |
| State management      | [Riverpod](https://riverpod.dev) 2.x                |
| Networking            | [Dio](https://pub.dev/packages/dio) 5.x             |
| Offline cache         | [Hive CE](https://pub.dev/packages/hive_ce)         |
| Settings persistence  | [SharedPreferences](https://pub.dev/packages/shared_preferences) |
| Data source           | [Open-Meteo](https://open-meteo.com/) (weather + geocoding, keyless) |
| Formatting            | [intl](https://pub.dev/packages/intl)               |
| Code quality          | `flutter_lints` 6 + `flutter analyze`               |

## 🏗️ Architecture

Each feature (`weather`, `location`, `favorites`, `settings`) is self-contained with
`data` / `domain` / `presentation` layers, sharing cross-cutting concerns from `core`
(constants, failures, network client, storage helpers, theme).

| Layer          | Responsibility                                                               |
| -------------- | ---------------------------------------------------------------------------- |
| **Presentation** | Widgets and Riverpod notifiers/state                                        |
| **Domain**       | Entities and repository contracts (no Flutter/Dio/Hive dependencies)        |
| **Data**         | Repositories, data sources, DTOs and mappers - implements domain contracts  |
| **Core**         | Shared constants, failures, Dio client, Hive/SharedPreferences, theme       |

### Project structure

```text
lib/
├── main.dart                       # Entry point — initializes storage, providers & router
├── core/
│   ├── constants/                  # App-wide constants
│   ├── error/                      # Failures & exceptions
│   ├── network/                    # Dio HTTP client
│   ├── routing/                    # Named routes + router (web-aware URL strategy)
│   ├── storage/                    # Hive & SharedPreferences wrappers
│   └── theme/                      # App theme
└── features/
    ├── weather/                    # Dashboard + hourly/daily forecasts
    ├── location/                   # City search & geocoding
    ├── favorites/                  # Saved places
    └── settings/                   # Temperature unit & theme preferences

    # Each feature follows the same internal layout:
    #   data/         datasources · models · mappers · providers · repositories
    #   domain/       entities · repository contracts · use cases
    #   presentation/ screens · notifiers · widgets
```

## 🔀 Data flow

**Online:** `UI → Repository → Remote DataSource → Open-Meteo API`, and the result is
cached locally.

**Offline:** Repositories fall back to the Hive cache, so the last known forecast is
still shown - with a *"Last updated"* banner so users know they're viewing cached data.

## 🚀 Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — any stable release
  bundling Dart ≥ 3.12 (the project's `pubspec.yaml` requires `sdk: ^3.12.2`)
- A device or emulator for your target platform

### Install & run

```sh
# 1. Fetch dependencies
flutter pub get

# 2. Run on your platform of choice
flutter run                      # auto-selects a connected device
flutter run -d windows           # Windows desktop
flutter run -d chrome            # Web (browser)
flutter run -d macos             # macOS desktop
flutter run -d linux             # Linux desktop
flutter run -d <android-device>  # Android emulator/device
flutter run -d <ios-simulator>   # iOS simulator
```

### Verify

```sh
flutter analyze    # static analysis — must report no issues
flutter test       # widget & routing tests
```

## 📱 Supported platforms

| Platform | Notes                                  |
| -------- | -------------------------------------- |
| Android  | ✅                                      |
| iOS      | ✅                                      |
| Web      | ✅ Browser URL reflects current screen  |
| Windows  | ✅                                      |
| macOS    | ✅                                      |
| Linux    | ✅                                      |

## 🤖 Continuous integration

A [GitHub Actions workflow](.github/workflows/ci.yml) runs on every push and pull
request to `main`:

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`

The current status is shown in the badge at the top of this README.

## 📄 License

Distributed under the [MIT License](LICENSE).
