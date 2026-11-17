# Example app

Run this example from the monorepo after generating the complete icon catalog:

```sh
node scripts/build-flutter.mjs
cd packages/flutter/example
flutter pub get
flutter run
```

The gallery can search the icon catalog and switch between all upstream styles
and corner treatments. Its app theme follows the system light/dark setting.
