# Grails_WebSockets
Example of WebSockets usage in Grails using the grails-spring-websocket plugin, SockJS, and StompJS. This was done as a hobby project to get more familiar with WebSockets and the changes in Grails v3.

## Description
The basic premise of the application is a Stock Ticker and Chat Room (not very original, I know). Upon opening the webpage the browser attempts to establish a series of connections via WebSocket back to the server to listen for subscribed data. On startup the server component launches a Quartz job (background scheduling) to generate random (and complete gibberish) stock quotes. Each web client can subscribe or unsubscribe from these updates at-will. If any user sends a chat message it is routed via the server to any other open web clients to act as a chat room.

For more info take a look at the blog post this example was written for: https://objectpartners.com/2015/06/10/websockets-in-grails-3-0/

## Usage

1. Clone this repo
2. From project root, execute `./gradlew bootRun`
3. Navigate to `http://localhost:8080`.
4. Login either as `user/password`, or `user2/password`

The main page supplies options to subscribe to stock quotes (reminder - these are fake! I'm not responsible if you decide to believe them). Any number of browser tabs you open and subscribe will get the same data broadcast to them at the same time. There is also a chat option - any open browser tab will display the chat messages from any other client.

To exit, Ctrl-C in your command prompt (assuming you're in UNIX). It may take several seconds for grails to shut down.

### Private Messages
If you are logged in as `user` then you will see private messages sent to you by the server - `user2` will not see these. This is an example of secured WebSockets which is managed using SpringSecurity integration.

## Tools & Frameworks
### grails-spring-websocket
Brings Spring 4 WebSockets features into Grails. This exact same functionality is available in standalone Spring-Boot so the majority of the code in this repo can be ported over to a Spring-Boot app with minimal structural changes.

### Grails 3.2.x
I've updated the project to use Grails 3.2.9 (the latest as of 25 July 2017).

### Stomp
From the [Stomp docs](http://jmesnil.net/stomp-websocket/doc/):
>STOMP is a simple text-orientated messaging protocol. It defines an interoperable wire format so that any of the available STOMP clients can communicate with any STOMP message broker to provide easy and widespread messaging interoperability among languages and platforms

### SockJS
From the [SockJS docs](https://github.com/sockjs/sockjs-client):
>SockJS is a browser JavaScript library that provides a WebSocket-like object. SockJS gives you a coherent, cross-browser, Javascript API which creates a low latency, full duplex, cross-domain communication channel between the browser and the web server.

## Licensing
This code is provided under the terms of the MIT license: basically you're free to do whatever you want with it, but no guarantees are made to its validity, stability, or safety. All works referenced by or utilized by this project are the property of their respective copyright holders and retain licensing that may be more restrictive.
