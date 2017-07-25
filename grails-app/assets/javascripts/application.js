// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//
//= require jquery-2.2.0.min
//= require_tree .
//= require_self

var GrailsWS = function ($) {
  // SockJS socket that connects to the server (preferably using a WebSocket)
  var _socket = null;
  // Stomp client that handles sending messages over the WebSocket
  var _client = null;
  //Track the subscription so we can unsubscribe later.
  var _quoteSubscription = null;

  var handleChatMessage = function (message) {
    var chatMsg = JSON.parse(message.body);
    var time = '<strong>' + new Date(chatMsg.timestamp).toLocaleTimeString() + '</strong>';
    $("#chatDiv").append(time + ': ' + chatMsg.message + '<br/>');
  };

  var handlePrivateChatMessage = function (message) {
    var chatMsg = JSON.parse(message.body);
    var time = '<strong>' + new Date(chatMsg.content.timestamp).toLocaleTimeString() + '</strong>';
    $("#chatDiv").append(time + ': (PRIVATE) ' + chatMsg.content.message + '<br/>');
  };

  var connect = function () {
    //Create a new SockJS socket - this is what connects to the server
    //(preferably using WebSockets).
    _socket = new SockJS('/stomp');
    //Build a Stomp client to send messages over the socket we built.
    _client = Stomp.over(_socket);

    //Have SockJS connect to the server.
    _client.connect({}, function () {
      //Subscribe to the 'chat' topic and define a function that is executed
      //anytime a message is published to that topic by the server or another client.
      _client.subscribe("/topic/chat", handleChatMessage);

      //Subscribe to the 'private' chat topic and define a function that is executed
      //anytime a message is published to that topic by the server or another client.
      //Any chat message sent by 'user' will be seen by any other sessions logged in as
      //'user' but not 'user2'
      _client.subscribe("/user/topic/chat", handlePrivateChatMessage);
    });
  };

  var updateQuote = function (symbol, price, time) {
    $("#symbol").text(symbol);
    $("#price").text(price);
    $("#timestamp").text(time);
  };

  var setButtonStates = function (startEnabled, stopEnabled) {
    $("#stopButton").prop('disabled', startEnabled);
    $("#startButton").prop('disabled', stopEnabled);
  };

  var subscribe = function () {
    _quoteSubscription = _client.subscribe("/topic/stockQuote", function (message) {
      var quote = JSON.parse(message.body).content;

      updateQuote(quote['symbol'], quote['price'].toFixed(2), new Date(quote.timestamp).toLocaleString());
    });
  };

  var unsubscribe = function () {
    _quoteSubscription.unsubscribe();
    _quoteSubscription = null;
  };

  var initButtonHandlers = function () {
    //When the user clicks the 'subscribe' button...
    $("#startButton").click(function () {
      //Toggle button states
      setButtonStates(false, true);

      //Initiate a subscription to stockQuote messages.
      subscribe();

      //Since the user could subscribe between quotes put up 'waiting'
      //to indicate the subscription succeeded and we're just waiting for the
      //first message.
      updateQuote('Waiting...', '', '');
    });

    //When the user clicks the 'unsubscribe' button...
    $("#stopButton").click(function () {
      //Toggle button states
      setButtonStates(true, false);

      //Unsubscribe so we don't get any more messages
      unsubscribe();

      updateQuote('Unsubscribed', '', '');
    });

    //When the user sends a chat message publish it to the chat topic
    $("#sendButton").click(function () {
      _client.send("/app/chat", {}, JSON.stringify($("#chatMessage").val()));
    });
  };

  return {
    init: function() {
      connect();
      initButtonHandlers();
    }
  }
};
