# personnel_appraisal

A Flutter frontend for the Personnel Appraisal Module.

To run the app and point it to the local backend, set the API base via `--dart-define`:

```bash
flutter run --dart-define=API_BASE=http://127.0.0.1:8000
```

The frontend uses `dio` (see `lib/core/api_service.dart`) to call the backend endpoints.
