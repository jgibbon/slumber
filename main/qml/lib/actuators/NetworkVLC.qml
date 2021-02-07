import QtQuick 2.0

NetworkBase {

    pathPing: '/requests/status.xml'
    pingExpectedSubstr: '<state>'
    pathAction: '/requests/status.xml?command=pl_pause'
    actionExpectedSubstr: '<state>paused</state>'

    function _action(callback){
        if(!enabled){
            return;
        }

        ping(function(o){
            if(o.responseText.indexOf('<state>playing</state>') > -1){
                request(urlbase + pathAction, function(o){
                    if(callback){

                        callback(o, actionExpectedSubstr ? (o.responseText.indexOf(actionExpectedSubstr) > -1) : true);
                    }
                });
            } else {
                console.log('vlc not playing');
            }
        })
    }
}
