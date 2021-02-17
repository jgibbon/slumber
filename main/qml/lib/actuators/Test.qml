import QtQuick 2.6

ActuatorBase {
    function run() {
        console.log('overloaded');
        done()
    }
}
