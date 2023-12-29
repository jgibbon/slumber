# slumber
## a shakeable sleep timer for media players on SailfishOS
Slumber is a sleep timer program for SailfishOS with sensors support.

This means you can use the accelerometer or proximity sensor to reset the timer if the display is lit: Just place your device on your bed and slap the mattress in it's general direction to reset the timer. If the display is off, tapping the screen thrice to "wake up and reset" in one go works reasonably good as well.

It's designed to pause local media players or Kodi/VLC via network.
If your device supports it (Jolla1 does not), aliendalvik/android media players shown on the lock screen should work, too.
Optionally, an audible notification plays for the last few seconds before pausing your media.


Note: Sounds are CC0, not GPL. [Click here for Details.](main/qml/assets/sound/LICENSE.txt)

[Screenshots:<br />![screenshots](https://i.imgur.com/od8Bfx4m.png)](http://i.imgur.com/od8Bfx4.png)

## Known restrictions:
- Does not work with Android media players on jolla1 phone.
- Does not work in Sailfish Browser (working alternative: WebPirate Browser)
- Sensors won't work when Display is off. But there is an option to keep it on while the timer runs. (If you know how to fix: please tell me!)
- Phone Vibration might trigger Accelerometer. (Well…)

## Install
- https://openrepos.net/content/velox/slumber or warehouse (recent builds)
- from Jolla Store (0.4-2, no i468 build)
- build it yourself from here

## Want to help?
### talk
Please let me know if it works for your favourite player and feel free to discuss: http://talk.maemo.org/showthread.php?p=1486493.
### code
You can send bug reports & pull requests right here on github!
### translate
Help me translate slumber to your language at https://www.transifex.com/velocode/slumber/
