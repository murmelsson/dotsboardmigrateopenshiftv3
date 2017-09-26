<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="action" type="java.lang.String"--%>
<%--@elvariable id="gameId" type="long"--%>
<%--@elvariable id="username" type="java.lang.String"--%>
<!DOCTYPE html>
<html>
    <head>
        <title>DotsBoardWS1 Gameboard :: murmelssonic</title>
        <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.1/css/bootstrap.min.css" />
        <link rel="stylesheet" href="<c:url value="/resource/stylesheet/DotsBoardWSS.css" />" />
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
    </head>
    <body style="font-family:arial">
        <h2>DotsBoardWS1</h2>
        <span class="player-label">You:</span> ${username}<br />
        <span class="player-label">Opponent:</span>
        <span id="opponent"><i>Waiting</i></span>
        <div id="status">&nbsp;</div>
        <div id="gameContainer">
            <div class="row">
                   <span id="crnr00" class="non-game-cell-corner">&nbsp;</span><!--
                --><span id="r0c0t0" class="game-cell-row" onclick="movehorv(0, 0, 0);">&nbsp;</span><!-- 
                --><span id="crnr01" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r0c1t0" class="game-cell-row" onclick="movehorv(0, 1, 0);">&nbsp;</span><!-- 
                --><span id="crnr02" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r0c2t0" class="game-cell-row" onclick="movehorv(0, 2, 0);">&nbsp;</span><!-- 
                --><span id="crnr03" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r0c3t0" class="game-cell-row" onclick="movehorv(0, 3, 0);">&nbsp;</span><!-- 
                --><span id="crnr04" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r0c4t0" class="game-cell-row" onclick="movehorv(0, 4, 0);">&nbsp;</span><!-- 
                --><span id="crnr05" class="non-game-cell-corner">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="r0c0t1" class="game-cell-column" onclick="movehorv(0, 0, 1);">&nbsp;</span><!-- 
                --><span id="box0c0" class="game-box">&nbsp;</span><!--
                --><span id="r0c1t1" class="game-cell-column" onclick="movehorv(0, 1, 1);">&nbsp;</span><!-- 
                --><span id="box0c1" class="game-box">&nbsp;</span><!--
                --><span id="r0c2t1" class="game-cell-column" onclick="movehorv(0, 2, 1);">&nbsp;</span><!-- 
                --><span id="box0c2" class="game-box">&nbsp;</span><!--
                --><span id="r0c3t1" class="game-cell-column" onclick="movehorv(0, 3, 1);">&nbsp;</span><!-- 
                --><span id="box0c3" class="game-box">&nbsp;</span><!--
                --><span id="r0c4t1" class="game-cell-column" onclick="movehorv(0, 4, 1);">&nbsp;</span><!-- 
                --><span id="box0c4" class="game-box">&nbsp;</span><!--
                --><span id="r0c5t1" class="game-cell-column" onclick="movehorv(0, 5, 1);">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="crnr10" class="non-game-cell-corner">&nbsp;</span><!--
                --><span id="r1c0t0" class="game-cell-row" onclick="movehorv(1, 0, 0);">&nbsp;</span><!-- 
                --><span id="crnr11" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r1c1t0" class="game-cell-row" onclick="movehorv(1, 1, 0);">&nbsp;</span><!-- 
                --><span id="crnr12" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r1c2t0" class="game-cell-row" onclick="movehorv(1, 2, 0);">&nbsp;</span><!-- 
                --><span id="crnr13" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r1c3t0" class="game-cell-row" onclick="movehorv(1, 3, 0);">&nbsp;</span><!-- 
                --><span id="crnr14" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r1c4t0" class="game-cell-row" onclick="movehorv(1, 4, 0);">&nbsp;</span><!-- 
                --><span id="crnr15" class="non-game-cell-corner">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="r1c0t1" class="game-cell-column" onclick="movehorv(1, 0, 1);">&nbsp;</span><!-- 
                --><span id="box1c0" class="game-box">&nbsp;</span><!--
                --><span id="r1c1t1" class="game-cell-column" onclick="movehorv(1, 1, 1);">&nbsp;</span><!-- 
                --><span id="box1c1" class="game-box">&nbsp;</span><!--
                --><span id="r1c2t1" class="game-cell-column" onclick="movehorv(1, 2, 1);">&nbsp;</span><!-- 
                --><span id="box1c2" class="game-box">&nbsp;</span><!--
                --><span id="r1c3t1" class="game-cell-column" onclick="movehorv(1, 3, 1);">&nbsp;</span><!-- 
                --><span id="box1c3" class="game-box">&nbsp;</span><!--
                --><span id="r1c4t1" class="game-cell-column" onclick="movehorv(1, 4, 1);">&nbsp;</span><!-- 
                --><span id="box1c4" class="game-box">&nbsp;</span><!--
                --><span id="r1c5t1" class="game-cell-column" onclick="movehorv(1, 5, 1);">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="crnr20" class="non-game-cell-corner">&nbsp;</span><!--
                --><span id="r2c0t0" class="game-cell-row" onclick="movehorv(2, 0, 0);">&nbsp;</span><!-- 
                --><span id="crnr21" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r2c1t0" class="game-cell-row" onclick="movehorv(2, 1, 0);">&nbsp;</span><!-- 
                --><span id="crnr22" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r2c2t0" class="game-cell-row" onclick="movehorv(2, 2, 0);">&nbsp;</span><!-- 
                --><span id="crnr23" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r2c3t0" class="game-cell-row" onclick="movehorv(2, 3, 0);">&nbsp;</span><!-- 
                --><span id="crnr24" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r2c4t0" class="game-cell-row" onclick="movehorv(2, 4, 0);">&nbsp;</span><!-- 
                --><span id="crnr25" class="non-game-cell-corner">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="r2c0t1" class="game-cell-column" onclick="movehorv(2, 0, 1);">&nbsp;</span><!-- 
                --><span id="box2c0" class="game-box">&nbsp;</span><!--
                --><span id="r2c1t1" class="game-cell-column" onclick="movehorv(2, 1, 1);">&nbsp;</span><!-- 
                --><span id="box2c1" class="game-box">&nbsp;</span><!--
                --><span id="r2c2t1" class="game-cell-column" onclick="movehorv(2, 2, 1);">&nbsp;</span><!-- 
                --><span id="box2c2" class="game-box">&nbsp;</span><!--
                --><span id="r2c3t1" class="game-cell-column" onclick="movehorv(2, 3, 1);">&nbsp;</span><!-- 
                --><span id="box2c3" class="game-box">&nbsp;</span><!--
                --><span id="r2c4t1" class="game-cell-column" onclick="movehorv(2, 4, 1);">&nbsp;</span><!-- 
                --><span id="box2c4" class="game-box">&nbsp;</span><!--
                --><span id="r2c5t1" class="game-cell-column" onclick="movehorv(2, 5, 1);">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="crnr30" class="non-game-cell-corner">&nbsp;</span><!--
                --><span id="r3c0t0" class="game-cell-row" onclick="movehorv(3, 0, 0);">&nbsp;</span><!-- 
                --><span id="crnr31" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r3c1t0" class="game-cell-row" onclick="movehorv(3, 1, 0);">&nbsp;</span><!-- 
                --><span id="crnr32" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r3c2t0" class="game-cell-row" onclick="movehorv(3, 2, 0);">&nbsp;</span><!-- 
                --><span id="crnr33" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r3c3t0" class="game-cell-row" onclick="movehorv(3, 3, 0);">&nbsp;</span><!-- 
                --><span id="crnr34" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r3c4t0" class="game-cell-row" onclick="movehorv(3, 4, 0);">&nbsp;</span><!-- 
                --><span id="crnr35" class="non-game-cell-corner">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="r3c0t1" class="game-cell-column" onclick="movehorv(3, 0, 1);">&nbsp;</span><!-- 
                --><span id="box3c0" class="game-box">&nbsp;</span><!--
                --><span id="r3c1t1" class="game-cell-column" onclick="movehorv(3, 1, 1);">&nbsp;</span><!-- 
                --><span id="box3c1" class="game-box">&nbsp;</span><!--
                --><span id="r3c2t1" class="game-cell-column" onclick="movehorv(3, 2, 1);">&nbsp;</span><!-- 
                --><span id="box3c2" class="game-box">&nbsp;</span><!--
                --><span id="r3c3t1" class="game-cell-column" onclick="movehorv(3, 3, 1);">&nbsp;</span><!-- 
                --><span id="box3c3" class="game-box">&nbsp;</span><!--
                --><span id="r3c4t1" class="game-cell-column" onclick="movehorv(3, 4, 1);">&nbsp;</span><!-- 
                --><span id="box3c4" class="game-box">&nbsp;</span><!--
                --><span id="r3c5t1" class="game-cell-column" onclick="movehorv(3, 5, 1);">&nbsp;</span>
            </div>
            <div class="row">
                   <span id="crnr40" class="non-game-cell-corner">&nbsp;</span><!--
                --><span id="r4c0t0" class="game-cell-row" onclick="movehorv(4, 0, 0);">&nbsp;</span><!-- 
                --><span id="crnr41" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r4c1t0" class="game-cell-row" onclick="movehorv(4, 1, 0);">&nbsp;</span><!-- 
                --><span id="crnr42" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r4c2t0" class="game-cell-row" onclick="movehorv(4, 2, 0);">&nbsp;</span><!-- 
                --><span id="crnr43" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r4c3t0" class="game-cell-row" onclick="movehorv(4, 3, 0);">&nbsp;</span><!-- 
                --><span id="crnr44" class="non-game-cell-corner">&nbsp;</span><!-- 
                --><span id="r4c4t0" class="game-cell-row" onclick="movehorv(4, 4, 0);">&nbsp;</span><!-- 
                --><span id="crnr45" class="non-game-cell-corner">&nbsp;</span>
            </div>

        </div>
        <div id="modalWaiting" class="modal hide fade">
            <div class="modal-header"><h3>Wait around a bit...life is waiting, mostly...</h3></div>
            <div class="modal-body" id="modalWaitingBody">&nbsp;</div>
        </div>
        <div id="modalError" class="modal hide fade">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;
                </button>
                <h3>Error</h3>
            </div>
            <div class="modal-body" id="modalErrorBody">a whatever error occurred.
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-dismiss="modal">OK</button>
            </div>
        </div>
        <div id="modalGameOver" class="modal hide fade">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;
                </button>
                <h3>Game Over</h3>
            </div>
            <div class="modal-body" id="modalGameOverBody">&nbsp;</div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-dismiss="modal">OK</button>
            </div>
        </div>
        <script type="text/javascript" >
            var movehorv;
            $(document).ready(function() {
                var modalError = $("#modalError");
                var modalErrorBody = $("#modalErrorBody");
                var modalWaiting = $("#modalWaiting");
                var modalWaitingBody = $("#modalWaitingBody");
                var modalGameOver = $("#modalGameOver");
                var modalGameOverBody = $("#modalGameOverBody");
                var opponent = $("#opponent");
                var status = $("#status");
                var opponentUsername;
                var username = '<c:out value="${username}" />';
                var myTurn = false;
                
                
				//if browser doesn't support WebSockets, inform user:
                if(!("WebSocket" in window))
                {
                    modalErrorBody.text('WebSockets are not supported in this ' +
                            'browser. Recommend you try again using the latest ' +
                            'versions of Mozilla Firefox or Google Chrome. And remember to enable javascript :)');
                    modalError.modal('show');
                    return;
                }

                modalWaitingBody.text('Connecting to the server.');
                modalWaiting.modal({ keyboard: false, show: true });

                var server;
                try {    // for openshift, the ws:// protocol goes via port 8000. It just does.
				         // openshiftv3: try not specifying a port...
                    //server = new WebSocket('ws://' + window.location.host + ':8000' +
					server = new WebSocket('ws://' + window.location.host +
                    '<c:url value="/dotsBoardWSS/${gameId}/${username}"> <c:param name="action" value="${action}" /></c:url>');
                } catch(error) {
                    modalWaiting.modal('hide');
                    modalErrorBody.text(error);
                    modalError.modal('show');
                    return;
                }

                server.onopen = function(event) {
                    modalWaitingBody
                            .text('Waiting for some opponent to join the game.');
                    modalWaiting.modal({ keyboard: false, show: true });
                };

                window.onbeforeunload = function() {
                    server.close();
                };

                server.onclose = function(event) {
                    if(!event.wasClean || event.code != 1000) {
                        toggleTurn(false, 'Game over due to some strange error!');
                        modalWaiting.modal('hide');
                        modalErrorBody.text('Code ' + event.code + ': ' +
                                event.reason);
                        modalError.modal('show');
                    }
                };

                server.onerror = function(event) {
                    modalWaiting.modal('hide');
                    modalErrorBody.text(event.data);
                    modalError.modal('show');
                };

                server.onmessage = function(event) {
                    var message = JSON.parse(event.data);
                    if(message.action == 'gameStarted') {
                        if(message.game.player1 == username)
                            opponentUsername = message.game.player2;
                        else
                            opponentUsername = message.game.player1;
                        opponent.text(opponentUsername);
                        toggleTurn(message.game.nextMoveBy == username);
                        modalWaiting.modal('hide');
                    } else if(message.action == 'opponentMadeMove') {
                        $('#r' + message.move.row + 'c' + message.move.column + 't' + message.move.horv)
                                .unbind('click')
                                .removeClass('game-cell-selectable')
                                .addClass('game-cell-opponent game-cell-taken');
                        for (i = 0; i < 4; i++) {
                        	for (j = 0; j < 5; j++) {
                        if (message.move.newlyFilledBoxes[i][j] == 1)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player1');
                        if (message.move.newlyFilledBoxes[i][j] == 2)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player2');
                       		}
                        }
                        toggleTurn(true);
                    } else if(message.action == 'opponentsTurnContinues') {
                        $('#r' + message.move.row + 'c' + message.move.column + 't' + message.move.horv)
                                .unbind('click')
                                .removeClass('game-cell-selectable')
                                .addClass('game-cell-opponent game-cell-taken');
                        for (i = 0; i < 4; i++) {
                        	for (j = 0; j < 5; j++) {
                        if (message.move.newlyFilledBoxes[i][j] == 1)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player1');
                        if (message.move.newlyFilledBoxes[i][j] == 2)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player2');
                       		}
                        }
                        toggleTurn(false, 'The opponent scores, so their turn continues');
                    } else if(message.action == 'yourTurnContinues') {
                        $('#r' + message.move.row + 'c' + message.move.column + 't' + message.move.horv)
                                .unbind('click')
                                .removeClass('game-cell-selectable')
                                .addClass('game-cell-player game-cell-taken');
                        for (i = 0; i < 4; i++) {
                        	for (j = 0; j < 5; j++) {
                        if (message.move.newlyFilledBoxes[i][j] == 1)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player1');
                        if (message.move.newlyFilledBoxes[i][j] == 2)
                        	$('#box' + i + 'c' + j)
                        	    .addClass('box-taken-player2');
                       		}
                        }
                        toggleTurn(true);
                    } else if(message.action == 'illegalMove') {
                    	//modalErrorBody.text('Illegal Move therr!!');
                    	modalErrorBody.text('Illegal move therr: ' + message.move.row + ',' + message.move.column + ';' + message.move.horv);
                        modalError.modal('show');
                        toggleTurn(true);
                    } else if(message.action == 'gameOver') {
                        toggleTurn(false, 'Game Over!');
                        if(message.winner) {
                            modalGameOverBody.text('Congratulations, you won! Think you\'re cool now eh? Yeh!');
                        } else {
                            modalGameOverBody.text('User "' + opponentUsername +
                                    '" won the game. Whereas you are currently such a Loser.');
                        }
                        modalGameOver.modal('show');
                        server.close();
                        server = null;
                    } else if(message.action == 'gameIsDraw') {
                        toggleTurn(false, 'A bore draw. ' +
                                'There is no winner. Only losers.');
                        modalGameOverBody.text('The game ended in a draw. ' +
                                'Stalemate, rubbish!');
                        modalGameOver.modal('show');
                        server.close();
                        server = null;
                    } else if(message.action == 'gameForfeited') {
                        toggleTurn(false, 'Your opponent forfeited!');
                        modalGameOverBody.text('User "' + opponentUsername +
                                '" forfeited the game. You win!');
                        modalGameOver.modal('show');
                        server.close();
                        server = null;
                    }
                };

                var toggleTurn = function(isMyTurn, message) {
                    myTurn = isMyTurn;
                    if(myTurn) {
                        status.text(message || 'It\'s your move!');
                        $('.game-cell:not(.game-cell-taken)')
                                .addClass('game-cell-selectable');
                        $('.game-cell-row:not(.game-cell-taken)')
                        .addClass('game-cell-selectable');
                        $('.game-cell-column:not(.game-cell-taken)')
                        .addClass('game-cell-selectable');
                    } else {
                        status.text(message ||'Waiting on your opponent to move.');
                        $('.game-cell-selectable')
                                .removeClass('game-cell-selectable');                        
                    }
                };

                movehorv = function(row, column, horv) {
                    if(!myTurn) {
                    	if(server != null) {
                       		modalErrorBody.text('It\'s not your turn, ya numpty!');
                        	modalError.modal('show');
                           	} else {
                    		modalErrorBody.text('This game instance is so over!');
                            modalError.modal('show');
                    	}
                    	return;
                    }
                    if(server != null) {
                        server.send(JSON.stringify({row: row, column: column, horv: horv })); //sends horv-move to the server.
                        $('#r' + row + 'c' + column + 't' + horv).unbind('click')
                                .removeClass('game-cell-selectable')
                                .addClass('game-cell-player game-cell-taken');
                        toggleTurn(false);
                    } else {
                        modalErrorBody.text('Not connected to game server.');
                        modalError.modal('show');
                    }
                };
            });
        </script>
        <br>
        <br>
        <a href="<c:url value="/dotsBoardWSS" />">Exit this.game (back outtae the list a' games)</a>
    </body>
</html>
