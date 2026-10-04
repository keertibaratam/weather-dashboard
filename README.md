# Weatherly

Weatherly is a production-quality Flutter weather dashboard built with clean
architecture and feature-first organization.

## Features

- **Current weather** — temperature, feels-like, humidity, wind, precipitation, sunrise/sunset
- **Hourly & daily forecasts** — next 24 hours and a 7-day outlook from Open-Meteo
- **Location search** — debounced city search with geocoding
- **Favorites** — save and quickly switch between saved places
- **Offline caching** — Hive-based cache with a "Last updated" banner when serving cached data
- **Settings** — Celsius/Fahrenheit toggle and Light/Dark/System theming

## Architecture

Each feature (`weather`, `location`, `favorites`, `settings`) is self-contained with
`data` / `domain` / `presentation` layers, sharing cross-cutting concerns from `core`
(constants, failures, network client, storage helpers, theme).

| Layer       | Responsibility                                                              |
| ----------- | --------------------------------------------------------------------------- |
| Presentation| Widgets and Riverpod notifiers/state                                        |
| Domain      | Entities and repository contracts (no Flutter/Dio/Hive dependencies)        |
| Data        | Repositories, data sources, DTOs and mappers — implements domain contracts  |
| Core        | Shared constants, failures, Dio client, Hive/SharedPreferences, theme       |

## Data flow

Online: `UI → Repository → Remote DataSource → Open-Meteo API` and the result is
cached locally. Offline: repositories fall back to the Hive cache so the last
known forecast is still shown.

## Getting started

```sh
flutter pub get
flutter run
```

To verify the project:

```sh
flutter analyze
flutter test
```
