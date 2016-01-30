<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>WebSockets Example</title>
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
                      console.log(message)
                        var chatMsg = JSON.parse(JSON.parse(message.body))
                        var time = '<strong>' + new Date(chatMsg.timestamp).toLocaleTimeString() + '</strong>'
                        $("#chatDiv").append(time + ': ' + chatMsg.message + "<br/>");
                    });
                });
                //When the user clicks the 'subscribe' button...
                $("#startButton").click(function(){
                    //Toggle button states
                    $("#stopButton").prop('disabled', false);
                    $("#startButton").prop('disabled', true);
                    //Initiate a subscription to stockQuote messages.
                    quoteSubscription = client.subscribe("/topic/stockQuote", function(message) {
                        var quote = JSON.parse(message.body).content;
                        $("#symbol").text(quote.symbol);
                        $("#price").text(quote.price.toFixed(2));
                        $("#timestamp").text(new Date(quote.timestamp).toLocaleString());
                    });
                    //Since the user could subscribe between quotes put up 'waiting'
                    //to indicate the subscription succeeded and we're just waiting for the
                    //first message.
                    $("#symbol").text('Waiting...');
                });

                //When the user clicks the 'unsubscribe' button...
                $("#stopButton").click(function(){
                    //Toggle button states
                    $("#stopButton").prop('disabled', true);
                    $("#startButton").prop('disabled', false);
                    //Unsubscribe so we don't get any more messages
                    quoteSubscription.unsubscribe();
                    quoteSubscription = null;
                    $("#symbol").text('Unsubscribed');
                    $("#price").text('');
                    $("#timestamp").text('');
                });

                //When the user sends a chat message publish it to the chat topic
                $("#sendButton").click(function() {
                    client.send("/app/chat", {}, JSON.stringify($("#chatMessage").val()));
                });
            });
        </script>
    </head>
    <body>
        <header role="banner">
            <h1>Stock Ticker and Chat</h1>
        </header>
        <noscript><h2 style="color: #FF0000">Your browser either can't or won't execute JavaScript, unable to use WebSockets!</h2></noscript>
        <section>
            <h2>Stock Quotes</h2>
            <button id="startButton">Subscibe</button>
            <button id="stopButton" disabled="true">Unsubscribe</button>
            <div id="quoteDiv">
                <p id="symbol">Unsubscribed</p>
                <p id="price"></p>
                <p id="timestamp"></p>
            </div>
        </section>
        <hr class="sectionDivider"/>
        <section>
            <h2>Chat</h2>
            <input id="chatMessage" type="text" />
            <button id="sendButton">Send</button>
            <div id="chatDiv"></div>
        </section>
        <footer class="footer" role="contentinfo"></footer>
    </body>
</html>
