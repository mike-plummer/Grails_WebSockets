package com.objectpartners.plummer

import org.springframework.messaging.handler.annotation.MessageMapping
import org.springframework.messaging.handler.annotation.SendTo
import groovy.json.JsonBuilder

class ChatController {

    @MessageMapping("/chat")
    @SendTo("/topic/chat")
    protected String chat(String chatMsg) {
        def builder = new JsonBuilder()
        builder {
            message(chatMsg)
            timestamp(new Date())
        }
        builder.toString()
    }
}
