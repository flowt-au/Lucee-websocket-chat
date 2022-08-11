<!--- index.cfm --->
<html>
    <head><style type="text/css">#inputfield{position:fixed;top: 0; left:0;margin:30px;} #texttosend{width:100%;} #chatcontent{margin-top: 60px;}</style></head>
<cfscript>
    /** ensure that we have Session.username and set a default channel */

    if (!isNull(URL.username))
        Session.username = URL.username;

    if (isEmpty(Session.username ?: "")){

        echo("<p>Session.username is not defined. Set it using the URL parameter username, e.g. ?username=Lucy");
        abort;
    }

    param name="channel" default="default";
</cfscript>


<cfoutput>
    <!--- JavaScript follows !--->
    <script>
        function sendText(){
            var texttosend=document.getElementById("texttosend").value;
            wschat.send(texttosend);
            document.getElementById("texttosend").value='';
        }

        function sendOnEnter(evt) {
            if (evt.keyCode === 13) {
                this.sendText()
            }
        }

        var channel  = "#channel#";
        var endpoint = "/ws/chat/" + channel;
        var protocol = (document.location.protocol == "https:") ? "wss://" : "ws://";

        var wschat   = new WebSocket(protocol + document.location.host + endpoint);

        var log = function(evt){
            console.log(evt.data ? JSON.parse(evt.data) : evt);
        };

        var writemessage=function(evt){
            console.log(evt.data ? JSON.parse(evt.data) : evt);
            if(evt.data){
                // Set the JSON keys to UPPER case.
                // This is needed so the message inserted below will have the correct properties in `res`,
                // irrespective of the different Lucee Admin Key Case settings (Upper case or Preserve case)
                // which affects JSONSerialize()
                res = JSON.parse(evt.data, function (key, value) {
                    if (value && typeof value === 'object') {
                        for (var k in value) {
                            var newKey = k.toUpperCase()

                            // If not already upper case, make upper case...
                            if (k !== newKey) {
                                value[newKey] = value[k];
                                delete value[k];
                            }
                        }

                        // Format the timestamp
                        if (value['TIMESTAMP']) {
                            var ts = value['TIMESTAMP']
                            var dt = new Date(ts)
                            value['TIMESTAMP'] = `${dt.getHours()}:${dt.getMinutes()}:${dt.getSeconds()}`
                        }

                        return value;
                    }
                    return value;
                });

                var msg = `<p><i>${res.TIMESTAMP}</i> `;

                if (res.FROM === '<server>') {
                    msg += `Server event: <b>${res.MESSAGE}</b></p>`;
                } else {
                    msg += `User ${res.FROM} said: <b>${res.MESSAGE}</b></p>`;
                }

                document.getElementById("chatcontent").insertAdjacentHTML("beforeend", msg);
            }
        };

        wschat.onopen    = log;
        wschat.onmessage = writemessage;
        wschat.onerror   = log;
        wschat.onclose   = log;

        document.title   = `#Session.username# on ${channel}`;
        document.write(`<p>[wschat] connected to "${channel}" as "#Session.username#"`);
    </script>
</cfoutput>

<body>
    <div id="inputfield">
        <input type="text" id="texttosend" onkeypress="sendOnEnter(event);">
        <button onClick="sendText();">Send</button>
    </div>
    <div id="chatcontent"></div>
</body>
</html>
