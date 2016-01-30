package com.objectpartners.plummer

import org.springframework.messaging.simp.SimpMessagingTemplate
import groovy.json.JsonBuilder

/**
 * Quartz job that kicks off at Grails startup. This job executes every 2.5
 * seconds to generate a fake stock quote, convert it to JSON, and publish
 * it to the optionally-subscribed-to stockQuote topic. Any browser clients
 * subscribed to the topic will receive it.
**/
class StockQuoteJob {
    /**
     * Tell Quartz how to schedule this job. You can optionally define
     * an initial delay, number of executions, or repeatDelay (as opposed
     * to repeatInterval).
    **/
    static triggers = {
        simple repeatInterval: 2500L
    }

    /**
     * Inject the messenger that accepts Stomp messages.
    **/
    SimpMessagingTemplate brokerMessagingTemplate

    /**
     * Basic info about this Quartz job.
    **/
    def group = "StocksGroup"
    def description = "Publishes a random StockQuote every 10 seconds"

    /**
     * What actually gets executed as the job.
    **/
    def execute() {
        Random random = new Random();
        /**
         * Generate a random 4 character uppercase String using ASCII values.
        **/
        def generatedSymbol = '';
        (0..3).collect {
            generatedSymbol += (char) random.nextInt(26) + 65
        };

        /**
         * Use the awesome Groovy JsonBuilder to convert a dynamically-defined
         * data structure to JSON.
        **/
        def builder = new JsonBuilder()
        builder {
            symbol(generatedSymbol)
            price(random.nextDouble() * 100)
            timestamp(new Date())
        }

        //Publish the new quote
        brokerMessagingTemplate.convertAndSend "/topic/stockQuote", builder
    }
}
