import QtQuick 2.0

ActionNetwork {
    id:actionPauseKodi
    property int activePlayer: 0
    property string pathGetPlayer: '/jsonrpc?request={%22jsonrpc%22:%222.0%22,%22method%22:%22Player.GetActivePlayers%22,%22id%22:1}'
    pathPing: '/jsonrpc?request={%22jsonrpc%22:%20%222.0%22,%20%22method%22:%20%22JSONRPC.Ping%22,%20%22id%22:%201}'
    pathAction: '/jsonrpc'
    //paramsAction: 'request={%22jsonrpc%22:%20%222.0%22,%20%22method%22:%20%22Player.PlayPause%22,%20%22params%22:%20{%20%22playerid%22:$PLAYERID$,%22play%22:false},%20%22id%22:%201}'
    paramsAction: '[{"jsonrpc":"2.0","method":"Player.PlayPause","params":[$PLAYERID$,false],"id":1}]'
    property string secondaryCommand: ''
    property string paramsShutdownAction: '[{"jsonrpc":"2.0","method":"'+secondaryCommand+'","id":1}]'
//    property bool doShutdown: false
    actionExpectedSubstr:'"speed":0'
    httpAction:'POST'
    httpPostActionMimeType: 'application/json'

    function ping(callback){
        request(urlbase + pathPing, function(o){
            console.log(JSON.stringify(o));
            if(callback){
                callback(o, actionExpectedSubstr ? (o.responseText.indexOf(pingExpectedSubstr) > -1) : true);
            }
        }, 'GET');
    }

    function _action(callback){
        if(!enabled){
            return;
        }

        //get active player
        request(urlbase + pathGetPlayer, function(o){
            if(!o.responseText){
                console.log('response from kodi empty. wrong host/port/user? kodi switched off?',o.responseText);
                return;
            }

            var players = JSON.parse(o.responseText);
            if(players.result){
                    players.result.forEach(function(el,i){
                        //pause player
                        request(urlbase + pathAction, function(o){
                            if(callback){
                                callback(o, actionExpectedSubstr ? (o.responseText.indexOf(actionExpectedSubstr) > -1) : true);
                            }
                            if(actionPauseKodi.secondaryCommand !== '') {
                                secondaryActionTimer.start();
                            }
                        }, actionPauseKodi.httpAction, actionPauseKodi.paramsAction.replace('$PLAYERID$', el.playerid));
                    })
                }

            if(!players.result || !players.result.length){
                console.log('no player active');
            }

         }, 'GET');

    }
    Timer { // lazy "callback after all other responses"; we'd really want a promise here…
        id: secondaryActionTimer
        interval: 900
        onTriggered: {
            //only do shutdown if a player was active ;)
            if(actionPauseKodi.secondaryCommand !== '') {
                request(urlbase + pathAction, function(o) {
                    console.log('shutdown kodi machine', o.responseText);
                }, actionPauseKodi.httpAction, actionPauseKodi.paramsShutdownAction);
                return;
            }
        }
    }
}
