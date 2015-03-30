# mobile-init
Bootstrap setup for building chrome apps, for Desktop and Mobile.

## Dependencies
* Node.js

## Install

```
npm install
npm install -g cca
cca checkenv
```

## Desktop
```
git clone https://github.com/topless/mobile-init.git
gulp
```
Visit [chrome://extensions](chrome://extensions) in your google chrome.
Load unpacked extension and point it in the `build` directory


## Mobile
### https://github.com/MobileChromeApps/mobile-chrome-apps/
Follow carefully the instructions above and make sure your android phone
is connected and recognized properly with `adb`
It will wrap the app with cordova and put it in the `mobile` directory.
Let gulp running from Desktop and in a new terminal paste.
```
cca create mobile --link-to=build/manifest.json

cd mobile
cca push --watch --target=your.phone.ip:port
```
