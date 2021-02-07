import QtQuick 2.6

ActuatorBase {

    property int totalRetries: 4
    property int doneRetries: 0
    property string user
    property string password
    property string host
    property bool useHttps
    property string httpAction:'GET'
    property string httpPostActionMimeType: 'application/x-www-form-urlencoded'

    property string pathPing
    property string pathAction
    property string paramsAction //post for kodi…

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
            console.log(JSON.stringify(o));
            if(callback){
                callback(o, actionExpectedSubstr ? (o.responseText.indexOf(pingExpectedSubstr) > -1) : true);
            }
        });
    }


    function request(url, callback, forceAction, forceParams) {
        var xhr = new XMLHttpRequest();
        var action = forceAction || httpAction
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(myxhr.readyState === XMLHttpRequest.DONE) {
                    console.log('response', myxhr.responseText);

                    console.log('--> headers', myxhr.getAllResponseHeaders());
                    console.log('--> status', myxhr.status, myxhr.statusText);
                    if(myxhr.status === 0 && doneRetries < totalRetries) {
                        doneRetries = doneRetries + 1;
                        console.log('oh, brute force resend!');
                        request(url, callback, forceAction, forceParams);
                    } else {
                        doneRetries = 0;
                        callback(myxhr);
                    }
                }
            }
        })(xhr);
        console.log('request', forceAction||httpAction, url, forceParams || '');
        xhr.open(action, url, true);
        if(action === 'POST') {
            xhr.setRequestHeader('Content-Type', httpPostActionMimeType);
        }

        xhr.send(forceParams || '');
    }
    function run() {
        action(function(o, success){
                   console.log('network: success', success)
               });
        done()
    }
}
