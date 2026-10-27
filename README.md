# Aira Lite

AI-native stress-management prototype — the **core-loop cut** of the Aira T0 app.
SwiftUI, built with plain `swiftc` (no Xcode project needed), runs in the iOS Simulator.

## ▶ Try it in the browser

**https://ginasiyuan.github.io/aira-lite/** — the current HTML prototype, with
onboarding, first-read and T0 reports, a plan, and Aira chat. Tap through it like
a real user; the demo control is hidden in this version. All data is mock and
interaction state resets on reload.

The web entry is `index.html`, using `app.js`, `first-read.html`, `report.html`
and the existing `Assets/` images. These files preserve the supplied standalone
HTML's interface without duplicating its embedded images. GitHub Pages already
publishes from `main`; after merging and a successful Pages deployment, the URL
above serves this version. No JavaScript build or Xcode build is required.

For local preview, run `python3 -m http.server 8000 --bind 127.0.0.1` in the
repository and open `http://127.0.0.1:8000/`. Serve over HTTP so the parent page
can control the report iframes; opening these split files via `file://` is not
supported.

The SwiftUI app in `Sources/` is a separate prototype and is unchanged by this
web update. Running `build.sh` still opens that native version. Sharing the HTML
with iOS would require a bundled `WKWebView` integration; this PR does not add it.

## Native app core loop

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
