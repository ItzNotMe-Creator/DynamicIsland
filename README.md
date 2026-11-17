# NOEL ISLAND 🎄 - Christmas for the iPhone 15 Dynamic Island

A native SwiftUI iPhone app + WidgetKit Live Activity for Dynamic Island.

## What is included
- Four themes: Santa, Rudolph, Snowman, Gingerbread
- Compact Island displays a character, days remaining, snowflake
- Long-press Island to reveal festive expanded card
- Lock Screen Live Activity with Christmas countdown
- Festive app with falling snow animation and Christmas countdown
- Start / restart / stop controls
- No server, account, personal data collection, or paid subscription in the app

## IMPORTANT limitations
- This ZIP contains **source code**, not a ready-to-install IPA. A compiler must build it.
- No Mac is needed if you use the GitHub Actions cloud build below, but you need a GitHub account and a Windows computer to sideload.
- GitHub compiles an **unsigned IPA**. Sideloadly can attempt to sign/install it with your own Apple ID. Free Apple IDs generally need a refresh every 7 days.
- **Live Activities require the embedded widget extension. DO NOT choose to remove app extensions / plugins in Sideloadly.** Apple and the free signing process may restrict whether the extension works; this route is not guaranteed.
- Apple's iOS Live Activities have an ~8-hour active limit. They are **not** permanent Dynamic Island decorations.
- The animated snow is inside the main app; iOS does not allow permanent snow outside the Island.
- Not tested on a physical device; check GitHub build logs and iPhone behavior. This is a personal learning/demo project, not a published App Store app.

## Build on Windows without a Mac

### A: Upload the project to GitHub
1. Download this ZIP and extract it on Windows.
2. Install GitHub Desktop from https://desktop.github.com/ and sign in.
3. File → Add Local Repository, pick `NoelIsland`.
4. If asked, choose **Create a Repository Here**; repository name `NoelIsland`.
5. Publish repository. A private repository is fine if your account has GitHub Actions minutes. Keep the `.github` hidden folder intact.
6. On GitHub website: your repository → **Actions** → **Build Noel Island for iPhone** → **Run workflow**.
   (A push to `main` also triggers the build.)
7. When build succeeds, click that run → **Artifacts** → **NoelIsland-iPhone-IPA** and download/unzip it. Inside is `NoelIsland-unsigned.ipa`.

### B: Install with Windows
1. Get Sideloadly from its official website: https://sideloadly.io/
2. Connect your iPhone 15 using USB, unlock it, and choose **Trust** if prompted.
3. Drag `NoelIsland-unsigned.ipa` into Sideloadly. Select your iPhone, and follow Sideloadly's Apple ID signing steps. Do not share Apple ID credentials in a chat.
4. **Keep app extensions / PlugIns enabled**, or the Dynamic Island will not work.
5. Depending on iOS, enable Developer Mode via Settings → Privacy & Security → Developer Mode, and trust the developer profile in Settings → General → VPN & Device Management if asked.
6. Launch **Noel Island**. Allow Live Activities if prompted (or enable in Settings → Apps → Noel Island). Select a theme and press **START CHRISTMAS ISLAND**.
7. Go Home and long-press the Dynamic Island.

## Common issues
- GitHub shows no workflow: make sure you included `.github/workflows/build-ipa.yml` and that it is committed to the `main` branch.
- No IPA artifact: check **Actions** for build errors; it's a source project and the cloud toolchain evolves.
- App installs but the Island is empty: check Live Activities permission, ensure you kept the widget extension when signing, and start a Live Activity inside the app.
- "Maximum app IDs" or extension signing failure: free Apple ID provisioning has limits. This cannot always be fixed without different signing.
- App stops opening after 7 days: re-sign using Sideloadly.

## Developer info
- iOS deployment target: 17.0+
- SwiftUI + ActivityKit + WidgetKit
- XcodeGen: `project.yml`
- Workflow: `.github/workflows/build-ipa.yml`
- Main App ID: `app.noelisland.christmas`
- Widget ID: `app.noelisland.christmas.widget`
