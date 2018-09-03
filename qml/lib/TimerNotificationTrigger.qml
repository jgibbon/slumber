import QtQuick 2.0
import Nemo.Notifications 1.0


Item {
    id: root
    property bool isActive: false
    signal triggered()
    signal reset()
    signal start()
    onTriggered: {
        console.log('onTriggered direct')
        reset()
    }
    onReset: {
        if(isActive) {
            isActive = false;
            notificationComponent.close()
        }
    }
    onStart: {
        isActive = true;
    }

    Timer {
        id: stayVisibleTimer
        interval: 3000
        running: parent.isActive
        repeat: true
        function publish(){
            if(running) {
                notificationComponent.close() //shrinks notification a bit but does not blank the screen
                notificationComponent.publish()
            }
        }
        onTriggered: publish()
        onRunningChanged: publish()
    }
    Notification {
        id: notificationComponent
        appName: 'slumber'
        body: qsTr('Timer triggering soon')
        expireTimeout: 10000
        category: "x-nemo.example"
        replacesId: 1
        summary: 'slumber'
        urgency: Notification.Critical //wake display
        itemCount: 1
        maxContentLines: 3
        previewSummary: 'slumber'
        previewBody: qsTr('Timer triggering soon')
//        onClicked: {
//            console.log('noti clicked')
//            root.triggered()
//        }
    }
    Component.onDestruction: notificationComponent.close()
}
