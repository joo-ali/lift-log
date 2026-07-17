# Lift Log — Yousef Part Only

This is the original Lift Log Flutter structure reduced to Yousef's assignment:

- Splash → Login flow
- `login_screen.dart`
- `auth_cubit.dart` + `auth_state.dart`
- `firebase_auth_service.dart`
- `app_router.dart`
- `auth_header.dart`

No register, home, workout, progress, profile, or invented login-success screen is included.
A successful Firebase login is confirmed with a green SnackBar on the Login screen.

## Run

```bash
flutter pub get
flutter run -d chrome
```
