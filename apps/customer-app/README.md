# ParkEase Customer App

The customer-facing Flutter app for ParkEase — QR entry, destination selection, slot assignment, payment, and receipt.

This is currently a **click-through prototype**: all data is hardcoded in [lib/models.dart](lib/models.dart) and there are no network calls yet. It's meant to demonstrate the full customer flow while the backend (`apps/backend`) is built out separately.

## Screen flow

```
Login → QR Scan → Destination → Slot → Payment → Receipt → (back to Login)
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- A Chromium-based browser — this app is only built to run as a web app in Chrome

Check your setup with:

```bash
flutter doctor
```

## Running it

From this directory (`apps/customer-app`):

```bash
flutter pub get
flutter run -d chrome
```

If `chrome` isn't listed when you run `flutter devices`, make sure Chrome is installed and Flutter can find it — see [Flutter's web setup docs](https://docs.flutter.dev/platform-integration/web/building).

## Project structure

```
lib/
  main.dart        entry point — sets up MaterialApp + PhoneFrame
  models.dart       hardcoded demo data
  theme.dart        app-wide theme
  screens/          one file per screen (login, scan, destination, slot, payment, receipt)
  widgets/          shared UI (brand header, facility map, phone frame)
  utils/            page transition helper
```

There's no `android/` or `ios/` here on purpose — the app only ever runs on localhost via `flutter run -d chrome`, so native platform scaffolding isn't needed.
