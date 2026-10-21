# Aira Lite

AI-native stress-management prototype — the **core-loop cut** of the Aira T0 app.
SwiftUI, built with plain `swiftc` (no Xcode project needed), runs in the iOS Simulator.

## The core loop (all that's included)

Welcome → Connect data (Apple Health, 30-day backfill) → First read
→ About you (name / age / sex) → Do you train? → Health background (injuries & meds)
→ Home (daily loop) → **Aira drives saliva collection in chat**
→ guided collection steps → full-screen joint analysis → report → plan deck.

Cut relative to the full build: notifications page, sampling-preview page,
first-check-in page, proactive signal scenarios, settings.

## Run

```bash
# needs a booted iOS simulator (iOS 17+ target)
xcrun simctl boot "iPhone Air"   # or any booted device
./build.sh                       # build + install + launch from Welcome
./build.sh home                  # jump straight to any screen
```

Useful `-start` ids: `welcome connect recap profile medical home agent
testing collect guide1..guide5 analyzing report plan`.
The floating **DEMO ▶** handle on the right edge auto-plays the whole loop (17 steps).

## Notes

- Sources are compiled with `-D LITE`; the same tree also builds the full app
  in the parent project (this repo ships the snapshot that Lite was cut from).
- All data is mocked and internally consistent (same numbers flow through
  recap → report → plan). Not a medical device.
