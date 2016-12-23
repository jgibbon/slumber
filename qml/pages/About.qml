import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0


import "../lib/"


Page {
    id: page
    property var options
    property var appstate
    property var firstPage


    property int infocount: 1
    property var infos: ['Slumber is a sleep timer program.','You can set a Time and it tries to pause your <i>other</i> media players.', 'You can use your Device\'s Accelerometer to reset the timer.']

    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation


    SilicaFlickable {
        id: listView

        anchors.fill: parent
        contentHeight: mainColumn.height

        VerticalScrollDecorator{

        }
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView

        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: "About slumber" }

            SectionHeader {
                text: qsTr( "/ˈslʌmbə/")
//                color: Theme.secondaryColor
            }

            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                Label {
                    id: helpTextLabel
                    text:qsTr('Slumber is a sleep timer program to help you doze off without much hassle while listening to stuff.')
//                    color: Theme.secondaryColor

//                    font.pixelSize: Theme.fontSizeExtraSmall
                    verticalAlignment: Text.AlignBottom


                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.paddingLarge * 2)
                    x: Theme.paddingLarge
                }
                Label {
                    id: tmoLabel
                    text:qsTr('If you need a feature or found something that is not working, feel free to post at TMO:') + '<br />'
//                    color: Theme.secondaryColor

//                    font.pixelSize: Theme.fontSizeExtraSmall
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
    //                color: Theme.secondaryColor
                }
                Label {
                    id: thanksLabel
                    text: qsTr('Thanks to all users suggesting things and everyone helping me out, especially:')
                          +'<br>'
                          +'<br>CepiPerez (i18n es)'
                          +'<br>eson (i18n se)'
                          +'<br>ria88 (i18n fi)'
                          +'<br>atlochowski (i18n pl)'
                          +'<br>coderus'
                    verticalAlignment: Text.AlignBottom

                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    width: parent.width - (Theme.paddingLarge * 2)
                    x: Theme.paddingLarge
                }
//                Label {
//                    text: qsTr("Was this helpful?")
////                    color: Theme.secondaryColor

////                    font.pixelSize: Theme.fontSizeExtraSmall
//                    verticalAlignment: Text.AlignBottom


//                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
//                    width: parent.width - (Theme.paddingLarge * 2)
//                    x: Theme.paddingLarge
//                }
//                Row {

//                    spacing: Theme.paddingMedium
//                    x: Theme.paddingLarge

//                    width: parent.width - (Theme.paddingLarge * 2)

//                    Button {
//                        text: "yes"
//                        width: parent.width/2 - (Theme.paddingMedium /3)
//                    }
//                    Button {
//                        id: noButton
//                        text: "no"
//                        onClicked:{
//                            console.log('no')
//                            page.infocount++;
//                            console.log(page.infocount, page.infos.slice(0, page.infocount))
//                            helpTextLabel.text =  page.infos.slice(0, page.infocount).join(' ')
//                            if(page.infocount == page.infos.length){
//                                noButton.visible = false
//                            }
//                        }
//                        x: Theme.paddingLarge
//                        width: parent.width/2 - (Theme.paddingMedium/3)
//                    }
//                }
            }

        }
    }
}
