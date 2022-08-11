component {

    this.name = "websocket_chat";

    function onApplicationStart(){
        // This must be called only ONCE, so we do it here.
        WebsocketServer("/ws/chat/{channel}", new ChatListener());
    }
}