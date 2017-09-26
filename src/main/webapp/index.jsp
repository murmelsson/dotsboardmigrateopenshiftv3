<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>DotsBoardWS1</title>
    </head>
    <body style="font-family:arial">
        <h2 style="font-family:arial">Murmelssonic DotsBoard - semiBeta version</h2>
        <a href="<c:url value="/dotsBoardWSS" />">DotsBoard WebSocketised</a>
        <br>
        <br>
        <p>Rules: the players take turns to fill in a box edge. <br>
        When a player completes the 4th side of any box, they gain a point for that box, AND their turn continues (until they fail to complete a box with a move). <br>
        Most boxes filled wins.</p>
        <p style="font-size:10px">by Murmelssonic, 2014. Based on a TicTacToe example by Nicholas Williams in "Professional Java for Web Applications" (Wrox/Wiley, 2014).</p>
    </body>
</html>
