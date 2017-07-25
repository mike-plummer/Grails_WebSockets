<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>WebSockets Example</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <asset:javascript src="application.js"/>
        <asset:stylesheet src="application.css"/>
        <asset:javascript src="spring-websocket" />

        <script defer type="text/javascript">
          $(function () {
            var app = GrailsWS($);
            app.init();
          });
        </script>
    </head>
    <body>
        <header>
            <h1>Stock Ticker and Chat</h1>
        </header>
        <noscript><h2 style="color: #FF0000">Your browser either can't or won't execute JavaScript, unable to use WebSockets!</h2></noscript>
        <section>
            <h2>Stock Quotes</h2>
            <button id="startButton">Subscribe</button>
            <button id="stopButton" disabled>Unsubscribe</button>
            <div id="quoteDiv">
                <p id="symbol">Unsubscribed</p>
                <p id="price"></p>
                <p id="timestamp"></p>
            </div>
        </section>
        <hr class="sectionDivider"/>
        <section>
            <h2>Chat</h2>
            <input id="chatMessage" title="Enter chat message"/>
            <button id="sendButton">Send</button>
            <div id="chatDiv"></div>
        </section>
        <footer class="footer"></footer>
    </body>
</html>
