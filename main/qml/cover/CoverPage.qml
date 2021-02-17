/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.6
import Sailfish.Silica 1.0
import '../lib'
CoverBackground {
    Image {
        opacity: 0.2
        source: '../assets/moon.png'
        width: 243 / 2
        height: 256 / 2
//        scale: 0.5
//        y: 0
        anchors.centerIn: parent;
//        x:0
    }
    TimerProgressIndicator {
        anchors.centerIn: parent;
        width: parent.width - Theme.paddingMedium * 2
        textcolor: Theme.primaryColor
        secondarytextcolor: Theme.secondaryColor
        viewActiveIndicatorEnabled: false

        animationDuration: Qt.application.state === Qt.ApplicationActive ? 0 : 200
    }

    CoverActionList {
        id: coverActionIdle

        enabled: !SleepTimer.running

        CoverAction {
            iconSource: 'image://theme/icon-cover-play'
            onTriggered: {
                SleepTimer.start()
            }
        }

    }
    CoverActionList {
        id: coverActionRunning

        enabled: SleepTimer.running

        CoverAction {
            iconSource: 'image://theme/icon-cover-refresh'
            onTriggered: {
                SleepTimer.start()
            }
        }

        CoverAction {
            iconSource: 'image://theme/icon-cover-cancel'
            onTriggered: {
                SleepTimer.stop()
            }
        }
    }
}


