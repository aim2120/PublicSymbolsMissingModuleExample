# Public Symbols Missing Module Example

This project reproduces an issue with the `swift api-digester` command when using a Tuist-generated project with external frameworks.

## Local Workstation

- Tuist version (repros with both)
  - 4.33.0
  - 4.49.1
- MacOS version: 15.3.2
- Xcode version: 16.1

## Repro Steps

1. Clone the repo
```sh
git clone https://github.com/aim2120/PublicSymbolsMissingModuleExample
cd PublicSymbolsMissingModuleExample
```
2. Install Package.swift dependencies with Tuist
```sh
tuist install
```
3. Generate the project
```sh
tuist generate --no-open
```
4. Build the framework target, preparing to dump public symbols (the `-sdk` flag is required for this)
```sh
xcodebuild -sdk $(xcrun --show-sdk-path --sdk iphonesimulator) \
-scheme PublicSymbolsMissingModuleExample \
-derivedDataPath .build \
-destination "platform=iOS Simulator,name=iPhone 15 Pro" \
-workspace PublicSymbolsMissingModuleExample.xcworkspace build | xcbeautify
```
5. Attempt to dump public symbols
```sh
swift api-digester -dump-sdk \
-module PublicSymbolsMissingModuleExample \
-o sdk-dump.json \
-F .build/Build/Products/Debug-iphonesimulator/ \
-sdk $(xcrun --show-sdk-path --sdk iphonesimulator) \
-target arm64-apple-ios18.1-simulator \
-abort-on-module-fail \
-v
```
6. Observe the following error occurs
```sh
Loading module: PublicSymbolsMissingModuleExample...
<unknown>:0: error: missing required module 'Adjust'
Failed to load module: PublicSymbolsMissingModuleExample
```

## Notes

- The `missing required module` error occurs when a public symbol in `PackageA` comes from the `Adjust` package. It does NOT occur if there are no public symbols in `PackageA` that come from `Adjust`.
- The `missing required module` error does not occur for the PackageB module, which also has symbols exposed publicly via `PackageA`.
- The following manual steps can remediate the error, but are very hacky:
  1. `mkdir -p .build/Build/Products/Debug-iphonesimulator/Adjust.framework/Modules`
  2. `cp Tuist/.build/tuist-derived/Adjust/Adjust.modulemap .build/Build/Products/Debug-iphonesimulator/Adjust.framework/Modules/module.modulemap`
  3. Run the same `swift api-digester` command as above and observe success

## Links

- [PackageA](https://github.com/aim2120/PublicSymbolsMissingModuleExample-PackageA)
- [PackageB](https://github.com/aim2120/PublicSymbolsMissingModuleExample-PackageB)
- [Adjust (v4.38.4)](https://github.com/adjust/ios_sdk/tree/v4.38.4)
