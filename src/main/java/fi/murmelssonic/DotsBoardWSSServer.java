package fi.murmelssonic;

import com.fasterxml.jackson.databind.ObjectMapper;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.websocket.CloseReason;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;


import java.io.IOException;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;



@ServerEndpoint("/dotsBoardWSS/{gameId}/{username}")
public class DotsBoardWSSServer
{
    private static Map<Long, Game> games = new Hashtable<>();  //the Hashtable stores the list of game instances
    private static ObjectMapper mapper = new ObjectMapper();  //the ObjectMapper is for the JSON de/serialisations

    @OnOpen
    public void onOpen(Session session, @PathParam("gameId") long gameId,
                       @PathParam("username") String username)
    {
        try
        {
            DotsBoardWSSGame dotsBoardWSSGame = DotsBoardWSSGame.getActiveGame(gameId);
            if(dotsBoardWSSGame != null)    //unexpected, since here we are expecting to create(activate) the POJO-game instance in onOpen()
            {
                session.close(new CloseReason(
                        CloseReason.CloseCodes.UNEXPECTED_CONDITION,
                        "This game has already started."
                ));
            }

            List<String> actions = session.getRequestParameterMap().get("action");
            if(actions != null && actions.size() == 1)
            {
                String action = actions.get(0);
                if("start".equalsIgnoreCase(action))
                {
                    Game game = new Game();
                    game.gameId = gameId;
                    game.player1 = session;
                    DotsBoardWSSServer.games.put(gameId, game);
                }
                else if("join".equalsIgnoreCase(action))
                {
                    Game game = DotsBoardWSSServer.games.get(gameId);
                    game.player2 = session;
                    game.dotsBoardWSSGame = DotsBoardWSSGame.startGame(gameId, username);
                    this.sendJsonMessage(game.player1, game,
                            new GameStartedMessage(game.dotsBoardWSSGame));
                    this.sendJsonMessage(game.player2, game,
                            new GameStartedMessage(game.dotsBoardWSSGame));
                    sendEmail("A game instance started!!", game.dotsBoardWSSGame);
                }
            }
        }
        catch(IOException e)
        {
            e.printStackTrace();
            try
            {
                session.close(new CloseReason(
                        CloseReason.CloseCodes.UNEXPECTED_CONDITION, e.toString()
                ));
            }
            catch(IOException ignore) { }
        }
    }

    @OnMessage
    public void onMessage(Session session, String message,
                          @PathParam("gameId") long gameId)
    {
        Game game = DotsBoardWSSServer.games.get(gameId);
        boolean isPlayer1 = session == game.player1;

        try
        {
        	// dd the following line is where the jackson ObjectMapper converts the
        	// json message (a String) into a Java object (of the Move class):
            Move move = DotsBoardWSSServer.mapper.readValue(message, Move.class);
            
            //dd remember to catch the IllegalArgumentException if thrown by DotsBoardWSSGame-
            //instance dotsBoardWSSGame's move method. So first try the move:
            try
            {
            game.dotsBoardWSSGame.move(
                    isPlayer1 ? DotsBoardWSSGame.Player.PLAYER1 :
                            DotsBoardWSSGame.Player.PLAYER2,
                    move.getRow(),
                    move.getColumn(),
                    move.getHorv()
            );
            } 
            catch (IllegalArgumentException e)  //dd and catching the Illegal move here
            {
            	this.handleIllegalMoveException(move, game, isPlayer1);
            	return;
            }
            
            //assuming the move was legal, return also the info on filled boxes, by adding it to the Move object:
            move.setNewlyFilledBoxes(game.dotsBoardWSSGame.getBoxGridint());
            
            //call the method that stringifies the java object for output to the JS ClientEndpoint:
            //which JSON message(s) we send depends on whether the current player turn continues:
            if (game.dotsBoardWSSGame.getTurnContinues() == false)
            {
            	this.sendJsonMessage((isPlayer1 ? game.player2 : game.player1), game,
            			new OpponentMadeMoveMessage(move));
            } 
            else if (game.dotsBoardWSSGame.getTurnContinues() == true)
            {
            	this.sendJsonMessage((isPlayer1 ? game.player2 : game.player1), game,
            			new OpponentsTurnContinuesMessage(move));
            	this.sendJsonMessage((isPlayer1 ? game.player1 : game.player2), game,
            			new YourTurnContinuesMessage(move));
            	game.dotsBoardWSSGame.setTurnContinues();
            }
            
            if(game.dotsBoardWSSGame.isOver())
            {
                if(game.dotsBoardWSSGame.isDraw())
                {
                    this.sendJsonMessage(game.player1, game,
                            new GameIsDrawMessage());
                    this.sendJsonMessage(game.player2, game,
                            new GameIsDrawMessage());
                }
                else
                {
                    boolean wasPlayer1 = game.dotsBoardWSSGame.getWinner() ==
                            DotsBoardWSSGame.Player.PLAYER1;
                    this.sendJsonMessage(game.player1, game,
                            new GameOverMessage(wasPlayer1));
                    this.sendJsonMessage(game.player2, game,
                            new GameOverMessage(!wasPlayer1));
                }

                game.player1.close();
                game.player2.close();
                
            }
        }
        catch(IOException e)
        {
            this.handleException(e, game);
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("gameId") long gameId)
    {
        Game game = DotsBoardWSSServer.games.get(gameId);
        if(game == null)
            return;
        boolean isPlayer1 = session == game.player1;
        if(game.dotsBoardWSSGame == null)
        {
            DotsBoardWSSGame.removeQueuedGame(game.gameId);
        }
        else if(!game.dotsBoardWSSGame.isOver())
        {
            game.dotsBoardWSSGame.forfeit(isPlayer1 ? DotsBoardWSSGame.Player.PLAYER1 :
                    DotsBoardWSSGame.Player.PLAYER2);
            Session opponent = (isPlayer1 ? game.player2 : game.player1);
            this.sendJsonMessage(opponent, game, new GameForfeitedMessage());
            try
            {
                opponent.close();
            }
            catch(IOException e)
            {
                e.printStackTrace();
            }
        }
    }
    
    public static void sendEmail(String theSubject, DotsBoardWSSGame gameThatStarted)  //murmelssonic game-admin
      {
//    	
//		final String username = "<some-email-address>";
//		final String password = "<store-new-password-in-environment!>";
// 
//		Properties props = new Properties();
//		props.put("mail.smtp.auth", "true");
//		props.put("mail.smtp.starttls.enable", "true");
//		props.put("mail.smtp.host", "smtp.gmail.com");
//		props.put("mail.smtp.port", "587");
// 
//		javax.mail.Session session = javax.mail.Session.getInstance(props,
//		  new javax.mail.Authenticator() {
//			protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
//				return new javax.mail.PasswordAuthentication(username, password);
//			}
//		  });
// 
//		try {
// 
//			javax.mail.Message message = new javax.mail.internet.MimeMessage(session);
//			message.setFrom(new javax.mail.internet.InternetAddress("<sender-email-address>"));
//			message.setRecipients(javax.mail.Message.RecipientType.TO,
//				javax.mail.internet.InternetAddress.parse("<recipient-email-address>"));
//			message.setSubject(theSubject);
//			message.setText("Dear BilisMeister, Lui-Même"
//				+ "\n\nDotsboardMeister spamming you with a message for potential notification purposes!"
//				+ "\nThe opponents of this game instance are:\n"
//				+ gameThatStarted.getPlayer1() + " versus " + gameThatStarted.getPlayer2());
// 
//			javax.mail.Transport.send(message);
// 
//			System.out.println("INFO: game started: " + gameThatStarted.getPlayer1() + " versus " + gameThatStarted.getPlayer2());
// 
//		} catch (Exception e) {   //replace javax.mail.MessagingException
//			System.out.println("ERROR - when trying to sendEmail() to the Administrator");
//			System.out.println("INFO: game started: " + gameThatStarted.getPlayer1() + " versus " + gameThatStarted.getPlayer2());
//		}
    	
    //for now comment out email sending (as cannot get email authentication for the sender, replace with stdout:
    System.out.println("INFO: game started: " + gameThatStarted.getPlayer1() + " versus " + gameThatStarted.getPlayer2());

    }

    private void sendJsonMessage(Session session, Game game, Message message)
    {
        try
        {
        	//the ObjectMapper stringifies the message and sends to the session id (some js-browser-ClientEndpoint, that is):
            session.getBasicRemote()
                   .sendText(DotsBoardWSSServer.mapper.writeValueAsString(message));
        }
        catch(IOException e)
        {
            this.handleException(e, game);
        }
    }

    private void handleException(Throwable t, Game game)
    {
        t.printStackTrace();
        String message = t.toString();
        try
        {
            game.player1.close(new CloseReason(
                    CloseReason.CloseCodes.UNEXPECTED_CONDITION, message
            ));
        }
        catch(IOException ignore) { }
        try
        {
            game.player2.close(new CloseReason(
                    CloseReason.CloseCodes.UNEXPECTED_CONDITION, message
            ));
        }
        catch(IOException ignore) { }
    }
    
    private void handleIllegalMoveException(Move move, Game game, boolean isPlayer1)  //murmelsson
    {
        
        this.sendJsonMessage((isPlayer1 ? game.player1 : game.player2), game,
                new IllegalMoveAttemptedMessage(move));

    }

    private static class Game
    {
        public long gameId;

        public Session player1;

        public Session player2;

        public DotsBoardWSSGame dotsBoardWSSGame;
    }

    public static class Move
    {
        private int row;

        private int column;
        
        private int horv;
        
        private int[][] newlyFilledBoxes = new int[4][5];

        public int getRow()
        {
            return row;
        }

        public void setRow(int row)
        {
            this.row = row;
        }

        public int getColumn()
        {
            return column;
        }

        public void setColumn(int column)
        {
            this.column = column;
        }
        
        public int getHorv()
        {
            return horv;
        }

        public void setHorv(int horv)
        {
            this.horv = horv;
        }
        public int[][] getNewlyFilledBoxes()
        {
            return newlyFilledBoxes;
        }

        public void setNewlyFilledBoxes(int[][] theBoxGridint)
        {
            this.newlyFilledBoxes = theBoxGridint;
        }
    }

    public static abstract class Message
    {
        private final String action;

        public Message(String action)
        {
            this.action = action;
        }

        public String getAction()
        {
            return this.action;
        }
    }

    public static class GameStartedMessage extends Message
    {
        private final DotsBoardWSSGame game;

        public GameStartedMessage(DotsBoardWSSGame game)
        {
            super("gameStarted");
            this.game = game;
        }

        public DotsBoardWSSGame getGame()
        {
            return game;
        }
    }

    public static class OpponentMadeMoveMessage extends Message
    {
        private final Move move;

        public OpponentMadeMoveMessage(Move move)
        {
            super("opponentMadeMove");
            this.move = move;
        }

        public Move getMove()
        {
            return move;
        }
    }
    
    public static class YourTurnContinuesMessage extends Message
    {
        private final Move move;

        public YourTurnContinuesMessage(Move move)
        {
            super("yourTurnContinues");
            this.move = move;
        }

        public Move getMove()
        {
            return move;
        }
    }
    
    public static class OpponentsTurnContinuesMessage extends Message
    {
        private final Move move;

        public OpponentsTurnContinuesMessage(Move move)
        {
            super("opponentsTurnContinues");
            this.move = move;
        }

        public Move getMove()
        {
            return move;
        }
    }

    public static class GameOverMessage extends Message
    {
        private final boolean winner;

        public GameOverMessage(boolean winner)
        {
            super("gameOver");
            this.winner = winner;
        }

        public boolean isWinner()
        {
            return winner;
        }
    }

    public static class GameIsDrawMessage extends Message
    {
        public GameIsDrawMessage()
        {
            super("gameIsDraw");
        }
    }

    public static class GameForfeitedMessage extends Message
    {
        public GameForfeitedMessage()
        {
            super("gameForfeited");
        }
    }
    
    public static class IllegalMoveAttemptedMessage extends Message
    {
    	private final Move illegalMove;
        public IllegalMoveAttemptedMessage(Move move)
        {
            super("illegalMove");
            this.illegalMove = move;
        }
        
        //we don't currently need to Getter the illegalMove, since the object is passed to the
        //ClientEndpoint straight after construction, but we can reduce Eclipse syntax warnings by defining Getter:)
        //...and so we do that defining:
        public Move getMove()
        {
            return illegalMove;
        }
    }
}

