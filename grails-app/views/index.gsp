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
                var socket = new SockJS("${createLink(uri: '/stomp')}");
                var client = Stomp.over(socket);
                var quoteSubscription;

                client.connect({}, function() {
                    client.subscribe("/topic/chat", function(message) {
                        var chatMsg = JSON.parse(message.body)
                        var time = '<strong>' + new Date(chatMsg.timestamp).toLocaleTimeString() + '</strong>'
                        $("#chatDiv").append(time + ': ' + chatMsg.message + "<br/>");
                    });
                });

                $("#startButton").click(function(){
                    $("#stopButton").prop('disabled', false);
                    $("#startButton").prop('disabled', true);
                    quoteSubscription = client.subscribe("/topic/stockQuote", function(message) {
                        var quote = JSON.parse(message.body);
                        $("#symbol").text(quote.symbol);
                        $("#price").text(quote.price.toFixed(2));
                        $("#timestamp").text(new Date(quote.timestamp).toLocaleString());
                    });
                    $("#symbol").text('Waiting...');
                });

                $("#stopButton").click(function(){
                    $("#stopButton").prop('disabled', true);
                    $("#startButton").prop('disabled', false);
                    quoteSubscription.unsubscribe();
                    quoteSubscription = null;
                    $("#symbol").text('Unsubscribed');
                    $("#price").text('');
                    $("#timestamp").text('');
                });

                $("#sendButton").click(function() {
                    client.send("/app/chat", {}, $("#chatMessage").val());
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
