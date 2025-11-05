<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Jenkins CI/CD App</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 100px; }
        h1 { color: #2e8b57; }
    </style>
</head>
<body>
    <h1><%= "Hello World from Tomcat!" %></h1>
    <p>Deployed by <strong>Jenkins Pipeline</strong></p>
    <p>Build #${BUILD_NUMBER} - ${BUILD_ID}</p>
</body>
</html>