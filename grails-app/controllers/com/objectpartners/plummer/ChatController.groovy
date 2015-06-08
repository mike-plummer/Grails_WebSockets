package com.objectpartners.plummer

import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.SendTo
import groovy.json.JsonBuilder

class ChatController {

    /**
     * Accepts incoming chat messages sent by browsers and routes them
     * to the 'chat' topic that all browser clients are subscribed to.
    **/
    @MessageMapping("/chat")
    @SendTo("/topic/chat")
    protected String chat(String chatMsg) {
        /**
         * Use the awesome Groovy JsonBuilder to convert a dynamically-defined
         * data structure to JSON.
        **/
        def builder = new JsonBuilder()
        builder {
            message(chatMsg)
            timestamp(new Date())
        }
        builder.toString()
    }
}
