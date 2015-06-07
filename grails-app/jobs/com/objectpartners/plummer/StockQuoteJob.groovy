package com.objectpartners.plummer

import org.springframework.messaging.simp.SimpMessagingTemplate
import groovy.json.JsonBuilder

class StockQuoteJob {
    static triggers = {
        simple repeatInterval: 2500L
    }

    SimpMessagingTemplate brokerMessagingTemplate

    def group = "StocksGroup"
    def description = "Publishes a random StockQuote every 10 seconds"

    def execute() {
        Random random = new Random();
        def generatedSymbol = '';
        (0..3).collect {
            generatedSymbol += (char) random.nextInt(26) + 65
        };

        def builder = new JsonBuilder()
        builder {
            symbol(generatedSymbol)
            price(random.nextDouble() * 100)
            timestamp(new Date())
        }

        brokerMessagingTemplate.convertAndSend "/topic/stockQuote", builder.toString()
    }
}
