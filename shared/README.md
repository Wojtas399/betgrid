# betgrid_shared

## To run emulators with cached data use:

```
firebase emulators:start --import=./firebase_functions/emulators_data --export-on-exit=./firebase_functions/emulators_data
```

## To deploy functions use:

```
firebase deploy --only functions
```