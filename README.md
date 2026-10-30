# Betgrid

Monorepo with the `client` app, the `admin` app, and the `shared` package.

## Firebase environments

Both apps have two flavors:

| Flavor | Firebase project | Bundle ID suffix |
| ------ | ---------------- | ---------------- |
| `dev` (default) | `betgrid-dev` | `.dev` |
| `prod` | `betgrid-9c57d` | none |

The Firebase config files are gitignored. Pull them for both flavors with the Firebase CLI logged in:

```sh
python3 tool/firebase_config.py
```

Then run or build from an app directory:

```sh
fvm flutter run                     # dev
fvm flutter run --flavor prod
fvm flutter build ipa --flavor prod
```

The admin app is iOS only.
