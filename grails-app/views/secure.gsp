<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>WebSockets Example - Private Messages</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <asset:stylesheet src="application.css"/>
        <asset:javascript src="application.js"/>
        <asset:javascript src="jquery" />
        <asset:javascript src="spring-websocket" />

        <script defer type="text/javascript">
            $(function() {
                //Create a new SockJS socket - this is what connects to the server
                //(preferably using WebSockets).
                var socket = new SockJS("${createLink(uri: '/stomp')}");
                //Build a Stomp client to send messages over the socket we built.
                var client = Stomp.over(socket);
                //Track the subscription so we can unsubscribe later.
                var quoteSubscription;

                //Have SockJS connect to the server.
                client.connect({}, function() {
                    //Subscribe to the 'chat' topic and define a function that is executed
                    //anytime a message is published to that topic by the server or another client.
                    client.subscribe("/topic/chat", function(message) {
                        var message = JSON.parse(message.body)
                        var chatMsg = message.content
                        var time = '<strong>' + new Date(chatMsg.timestamp).toLocaleTimeString() + '</strong>'
                        $("#chatDiv").append(time + ': ' + chatMsg.message + "<br/>");
                    });

                    //Subscribe to a user-specific chat topic - messages sent to this user
                    //will be received by this and labelled appropriately
                    client.subscribe("/user/topic/chat", function(message) {
                        var message = JSON.parse(message.body)
                        var chatMsg = message.content
                        var time = '<strong>(PRIVATE) ' + new Date(chatMsg.timestamp).toLocaleTimeString() + '</strong>'
                        $("#chatDiv").append(time + ': ' + chatMsg.message + "<br/>");
                    });
                });
            });
        </script>
    </head>
    <body>
        <header role="banner">
            <h1>Private Messages</h1>
        </header>
        <noscript><h2 style="color: #FF0000">Your browser either can't or won't execute JavaScript, unable to use WebSockets!</h2></noscript>
        <section>
            <p>Wait here for private messages, assuming you're logged in as "user"...</p>
            <div id="chatDiv"></div>
        </section>
        <footer class="footer" role="contentinfo"></footer>
    </body>
</html>
