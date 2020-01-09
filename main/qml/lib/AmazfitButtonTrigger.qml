import QtQuick 2.0
import Nemo.DBus 2.0

Item {
    id: trigger
    property bool enabled: true
    signal buttonPressed(int presses)
    Loader {
        active: trigger.enabled
        sourceComponent: Component {
            Item {

                DBusInterface {
                    id: pre1 // pre amazfish 1.0

                    service: 'uk.co.piggz.amazfish'
                    iface: 'uk.co.piggz.amazfish'
                    path: '/'

                    signalsEnabled: true

                    function buttonPressed(presses) {
                        if(trigger.enabled) {
                            trigger.buttonPressed(presses);
                        }
                    }
                }

                DBusInterface {
                    id: amazfish1 // amazfish 1.0

                    service: 'uk.co.piggz.amazfish'
                    iface: 'uk.co.piggz.amazfish'
                    path: '/application'

                    signalsEnabled: true

                    function buttonPressed(presses) {
                        if(trigger.enabled) {
                            trigger.buttonPressed(presses);
                        }
                    }
                }
            }

        }
    }
}
