import QtQuick 2.0
import Sailfish.Silica 1.0

import "../lib/"

Page {
    id: page
    property var options
    property var appstate
    property var firstPage

    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation

    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{}
        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: "About slumber" }

            SectionHeader {
                text: qsTr( "/ˈslʌmbə/")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                Label {
                    id: helpTextLabel
                    text:qsTr('Slumber is a sleep timer program to help you doze off without much hassle while listening to stuff.')
                    verticalAlignment: Text.AlignBottom
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.paddingLarge * 2)
                    x: Theme.paddingLarge
                }
                Label {
                    id: tmoLabel
                    text:qsTr('If you need a feature or found something that is not working, feel free to post at TMO:') + '<br />'
                    verticalAlignment: Text.AlignBottom


                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.paddingLarge * 2)
                    x: Theme.paddingLarge
                }
                Button {
                    text: qsTr("TMO Thread for slumber")
                    onClicked: Qt.openUrlExternally('http://talk.maemo.org/showthread.php?p=1486493&goto=newpost')
                    x: Theme.paddingLarge
                }

                SectionHeader {
                    text: qsTr( "Thanks!")
                }
                Label {
                    id: thanksLabel
                    text: qsTr('Thanks to all users suggesting things and everyone helping me out, especially:')
                          +'<br>'
                          +'<br>CepiPerez/carmenfdezb (i18n es)'
                          +'<br>eson (i18n se)'
                          +'<br>ria88 (i18n fi)'
                          +'<br>atlochowski (i18n pl)'
                          +'<br>ancelad (i18n ru)'
                          +'<br>sponka (i18n sl)'
                          +'<br>pljmn (i18n nl)'
                          +'<br>fravaccaro (i18n it)'
                          +'<br>lutinotmalin (i18n fr)'
                          +'<br>rui kon (i18n cn)'
                          +'<br>coderus'
                    verticalAlignment: Text.AlignBottom

                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.paddingLarge * 2)
                    x: Theme.paddingLarge
                }
            }
        }
    }
}
