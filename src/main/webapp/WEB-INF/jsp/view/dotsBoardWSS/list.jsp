<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="pendingGames" type="java.util.Map<long, java.Lang.String>"--%>
<!DOCTYPE html>
<html>
    <head>
        <title>DotsBoardWS1 :: murmelssonic</title>
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    </head>
    <body style="font-family:arial">
        <h2>DotsBoard WS1</h2>
        <a href="javascript:void 0;" onclick="startGame();">Start a new Game and wait for / inform an opponent</a><br />
        <br />
        <c:choose>
            <c:when test="${fn:length(pendingGames) == 0}">
                <i>There are no existing games to join.</i>
            </c:when>
            <c:otherwise>
                Join a game waiting for an opponent:<br />
                <c:forEach items="${pendingGames}" var="e">
                    <a href="javascript:void 0;"
                       onclick="joinGame(${e.key});">User: ${e.value}</a><br />
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <script type="text/javascript" >
            var startGame, joinGame;
            $(document).ready(function() {
                var url = '<c:url value="/dotsBoardWSS" />';

                startGame = function() {
                    var username = prompt('Enter your playerName (Western letters and numbers or underscore only, no spaces):', '');
                    if(username != null && username.trim().length > 0 &&
                            validateUsername(username))
                        post({action: 'start', username: username});
                };

                joinGame = function(gameId) {
                    var username =
                            prompt('Enter your playerName (Western letters and numbers or underscore only, no spaces):', '');
                    if(username != null && username.trim().length > 0 &&
                            validateUsername(username))
                        post({action: 'join', username: username, gameId: gameId});
                };

                var validateUsername = function(username) {
                    var valid = username.match(/^[a-zA-Z0-9_]+$/) != null;
                    if(!valid)
                        alert('User names can only contain letters, numbers ' +
                                'and underscores.' + 'No umlauts, just bogstandard English alphabetary');
                    return valid;
                };

                var post = function(fields) {
                    var form = $('<form id="mapForm" method="post"></form>')
                            .attr({ action: url, style: 'display: none;' });
                    for(var key in fields) {
                        if(fields.hasOwnProperty(key))
                            form.append($('<input type="hidden">').attr({
                                name: key, value: fields[key]
                            }));
                    }
                    $('body').append(form);
                    form.submit();
                };
            });
        </script>
    </body>
</html>
