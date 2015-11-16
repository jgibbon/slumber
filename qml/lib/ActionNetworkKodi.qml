import QtQuick 2.0

ActionNetwork {
    id:actionPauseKodi
    property int activePlayer: 0
    property string pathGetPlayer: '/jsonrpc?request={%22jsonrpc%22:%222.0%22,%22method%22:%22Player.GetActivePlayers%22,%22id%22:1}'
    pathPing: '/jsonrpc?request={%22jsonrpc%22:%20%222.0%22,%20%22method%22:%20%22JSONRPC.Ping%22,%20%22id%22:%201}'
    pathAction: '/jsonrpc?request={%22jsonrpc%22:%20%222.0%22,%20%22method%22:%20%22Player.PlayPause%22,%20%22params%22:%20{%20%22playerid%22:$PLAYERID$,%22play%22:false},%20%22id%22:%201}'
    actionExpectedSubstr:'"speed":0'
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
                    request(urlbase + pathAction.replace('$PLAYERID$', el.playerid), function(o){
                        if(callback){
                            callback(o, actionExpectedSubstr ? (o.responseText.indexOf(actionExpectedSubstr) > -1) : true);
                        }
                    });
                })
            }
            if(!players.result || !players.result.length){
                console.log('no player active');
            }

         });

    }
}
