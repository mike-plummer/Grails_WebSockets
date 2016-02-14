package com.objectpartners.plummer

import groovy.json.JsonBuilder
import org.springframework.messaging.simp.SimpMessagingTemplate

class FormMessageController {

    def SimpMessagingTemplate brokerMessagingTemplate

    def index() {
    }

    def String message() {
        def builder = new JsonBuilder()
        builder {
            message(params.message)
            timestamp(new Date().getTime())
        }
        brokerMessagingTemplate.convertAndSend("/topic/formMessage", builder.toString())
        println builder.toString()
        render(view: "index")
    }
}