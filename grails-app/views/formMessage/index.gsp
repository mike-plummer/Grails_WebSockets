<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
</head>

<body>
    Example of submitting a message using a Grails form. This gets routed to FormMessageController which dispatches it to a websocket topic.
    Subscribing to that topic and displaying output is left as an exercise for the user.
    <g:form action="message">
        <g:textField name="message" value="${message}" />
        <g:submitButton name="sendMessage" value="Send Message" />
    </g:form>
</body>
</html>