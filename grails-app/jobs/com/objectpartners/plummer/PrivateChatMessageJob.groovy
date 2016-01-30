package com.objectpartners.plummer

import org.springframework.messaging.simp.SimpMessagingTemplate
import groovy.json.JsonBuilder

/**
 * Quartz job that kicks off at Grails startup. This job executes every 10
 * seconds to generate a message sent to the "user" user - these messages
 * will not be seen by other or anonymous users
**/
class PrivateChatMessageJob {

    static triggers = {
        simple repeatInterval: 10000L
    }

    /**
     * Inject the messenger that accepts Stomp messages.
    **/
    SimpMessagingTemplate brokerMessagingTemplate

    /**
     * Basic info about this Quartz job.
    **/
    def group = "ChatGroup"
    def description = "Publishes a private chat message every 10 seconds"

    /**
     * What actually gets executed as the job.
    **/
    def execute() {
        def builder = new JsonBuilder()
        builder {
            message("Hello, user!")
            timestamp(new Date())
        }
        
        //Note the lack of the leading /user compared to what the webpage subscribes to
        // - this is added automatically
        brokerMessagingTemplate.convertAndSendToUser "user", "/topic/chat", builder

        println "Sent private message"
    }
}
