import QtQuick 2.6

Item {
    property int currentIndex: -1
    function next() {
        currentIndex += 1;
        if(children[currentIndex]) {
            if(children[currentIndex].enabled) {
                console.log('running actuator', currentIndex);
                children[currentIndex].run();
            } else {
                next()
            }
        } else {
            console.log('no more actuators found');
            currentIndex = -1;
        }
    }
    function run() {
        next()
    }
}
