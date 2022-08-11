/** ChatListener.cfc
 *
 * From https://github.com/isapir/lucee-websocket/wiki/Example-Chat
 * No changes.
*/
component {

    /**
    * Ensures that we have a valid Session.username, and notifies the channel
    * subscribers that the user connected
    */
    function onOpen(websocket, endpointConfig, sessionScope, applicationScope){

        if (isEmpty(arguments.sessionScope.username ?: ""))
            return false;        // returing false will reject the connection

        this.notifyChannel(
             arguments.websocket
            ,{
                 from   : "<server>"
                ,message: "#arguments.sessionScope.username# connected"
            }
        );
    }

    /**
    * Notifies the channel subscribers to the channel that the user has disconnected
    */
    function onClose(websocket, closeReason, sessionSCope, applicationScope){

        this.notifyChannel(
             arguments.websocket
            ,{
                 from   : "<server>"
                ,message: "#arguments.sessionScope.username# disconnected"
            }
        );
    }

    /**
    * Broadcasts the message to the channel's subscribers
    */
    function onMessage(websocket, message, sessionScope, applicationScope){

        this.notifyChannel(
             arguments.websocket
            ,{
                 from   : arguments.sessionScope.username
                ,message: arguments.message
            }
        );
    }

    /**
    * This is a helper method that adds a timestamp to the data, serializes
    * it as JSON, and broadcasts it to all of the subscribers to the channel
    * of this websocket connection
    */
    private function notifyChannel(websocket, data){

        var chanId  = arguments.websocket.getPathParameters().channel;
        var connMgr = arguments.websocket.getConnectionManager();
        arguments.data.channel   = chanId;
        arguments.data.timestamp = getTickCount();

        connMgr.broadcast(chanId, serializeJson(arguments.data));
    }
}