import QtQuick 2.0

Item {
    id:actionNetwork

    property string user
    property string password
    property string host
    property bool useHttps
    property bool enabled
    property string httpAction:'GET'

    property string pathPing
    property string pathAction

    property string pingExpectedSubstr
    property string actionExpectedSubstr

    property string urlbase: 'http'+(useHttps?'s':'')+'://'
                             + (!!user || !!password ? (user + (password?(':'+ password):'') +'@') : '')
                             + host
                             + '';
    property var action: _action
    function _action(callback){
        if(enabled){
            request(urlbase + pathAction, function(o){
                if(callback){

                    callback(o, actionExpectedSubstr ? (o.responseText.indexOf(actionExpectedSubstr) > -1) : true);
                }
            });
        }
    }

    function ping(callback){
        request(urlbase + pathPing, function(o){
            if(callback){
                callback(o, actionExpectedSubstr ? (o.responseText.indexOf(pingExpectedSubstr) > -1) : true);
            }
        });
    }


    function request(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(myxhr.readyState === XMLHttpRequest.DONE) {
                    callback(myxhr);
                }
            }
        })(xhr);
        xhr.open(httpAction, url, true);
        xhr.send('');
    }

}
