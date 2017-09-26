package fi.murmelssonic;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.Hashtable;
import java.util.Map;
import java.util.Random;

public class DotsBoardWSSGame
{
    private static long gameIdSequence = 1L;
    private static final Hashtable<Long, String> pendingGames = new Hashtable<>();
    private static final Map<Long, DotsBoardWSSGame> activeGames = new Hashtable<>();
    private final long id;
    private final String player1;
    private final String player2;
    private Player nextMove = Player.random();

    private Player[][] boxGrid = {
    		{Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES},
    		{Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES},
    		{Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES},
    		{Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES, Player.NOSIDES},
    };
    private int[][] boxGridint = {
    		{0,0,0,0,0},
    		{0,0,0,0,0},
    		{0,0,0,0,0},
    		{0,0,0,0,0},
    };
    
    private Player[][] horGrid = new Player[5][5];  //to hold the horizontal box-edges (who filled each edge)
    private Player[][] verGrid = new Player[4][6];  //to hold the vertical box-edges (who filled each edge)
    private boolean over;
    private boolean draw;
    private Player winner;
    
    private final int boxesToComplete = 20;
    private int completedBoxesCount = 0;
    private int player1score = 0;
    private int player2score = 0;
    private boolean turnContinues = false;

    private DotsBoardWSSGame(long id, String player1, String player2)
    {
        this.id = id;
        this.player1 = player1;
        this.player2 = player2;
    }

    public long getId()
    {
        return id;
    }

    public String getPlayer1()
    {
        return player1;
    }

    public String getPlayer2()
    {
        return player2;
    }

    public String getNextMoveBy()
    {
        return nextMove == Player.PLAYER1 ? player1 : player2;
    }

    public boolean isOver()
    {
        return over;
    }

    public boolean isDraw()
    {
        return draw;
    }
    
    public int[][] getBoxGridint()
    {
    	return boxGridint;
    }
    
    public boolean getTurnContinues()
    {
    	return turnContinues;
    }
    
    public void setTurnContinues()
    {
    	turnContinues = false;
    }

    public Player getWinner()
    {
        return winner;
    }

    @JsonIgnore
    public synchronized void move(Player player, int row, int column, int horv)
    {
        if(player != this.nextMove)
            throw new IllegalArgumentException("It is not your turn!");

        if(horv == 0) 
        {                // && row > 2) || (horv == 'v' && column > 5))
        	if (row > 4)
        		throw new IllegalArgumentException("hEdgeRow must be in range 0-4");
        	if (column > 4)
        		throw new IllegalArgumentException("hEdgeColumn must be in range 0-4");

        	if(this.horGrid[row][column] != null)
        		throw new IllegalArgumentException("Move already made at horizontal edge" + row + ","
                    + column);

        	this.horGrid[row][column] = player;
        	
        	//calculate which boxGrid boxes have gained a side (either exactly one - or exactly two - boxes have):
        	if (row == 0) {
        		addBoxSide(row, column, player);
        	} else if (row == 4) {
        		addBoxSide((row-1), column, player);
        	} else {
        		addBoxSide(row, column, player);
        		addBoxSide((row-1), column, player);
        	}
        }
        else if(horv == 1)
        {
        	if (row > 3)
            	throw new IllegalArgumentException("vEdgeRow must be in range 0-3");
            if (column > 5)
            	throw new IllegalArgumentException("vEdgeColumn must be in range 0-5");

            if(this.verGrid[row][column] != null)
            	throw new IllegalArgumentException("Move already made at vertical edge" + row + ","
                    + column);

            this.verGrid[row][column] = player;
            
            //again, calculate which boxGrid boxes have gained a side:
        	if (column == 0) {
        		addBoxSide(row, column, player);
        	} else if (column == 5) {
        		addBoxSide(row, (column-1), player);
        	} else {
        		addBoxSide(row, column, player);
        		addBoxSide(row, (column-1), player);
        	}
        }
        
        if (this.completedBoxesCount == this.boxesToComplete) {
            this.winner = this.calculateWinner();
            if(this.getWinner() != null || this.isDraw())
                this.over = true;
            if(this.isOver())
            	DotsBoardWSSGame.activeGames.remove(this.id);
            return;
        }
        
        if (turnContinues) {
        	this.nextMove =
        			this.nextMove == Player.PLAYER1 ? Player.PLAYER1 : Player.PLAYER2;
        } else {
        	this.nextMove =
        			this.nextMove == Player.PLAYER1 ? Player.PLAYER2 : Player.PLAYER1;
        }
//        this.winner = this.calculateWinner();
//        if(this.getWinner() != null || this.isDraw())
//            this.over = true;
//        if(this.isOver())
//        	DotsBoardWSSGame.activeGames.remove(this.id);
    }
    
// a method that calculates which boxes have had a side added:
    public void addBoxSide(int aRow, int aColumn, Player aPlayer)
    {
    	switch(this.boxGrid[aRow][aColumn]) {
		case NOSIDES: {
			this.boxGrid[aRow][aColumn] = Player.ONESIDE;
			break;
		}
		case ONESIDE: {
			this.boxGrid[aRow][aColumn] = Player.TWOSIDES;
			break;
		}
		case TWOSIDES: {
			this.boxGrid[aRow][aColumn] = Player.THREESIDES;
			break;
		}
		case THREESIDES: {
			this.boxGrid[aRow][aColumn] = aPlayer;
			this.completedBoxesCount++;
			this.turnContinues = true;
			if (aPlayer == Player.PLAYER1) {
				this.player1score++;
				this.boxGridint[aRow][aColumn] = 1;
			} else {
				this.player2score++;
				this.boxGridint[aRow][aColumn] = 2;
			}
			break;
		}
		case PLAYER1:
			break;
		case PLAYER2:
			break;
		default:
			break;
		}
    }

    public synchronized void forfeit(Player player)
    {
    	DotsBoardWSSGame.activeGames.remove(this.id);
        this.winner = player == Player.PLAYER1 ? Player.PLAYER2 : Player.PLAYER1;
        this.over = true;
    }

    private Player calculateWinner()
    {
        boolean draw = true;  //assume as default before checking in this method.
        
        if (player1score > player2score) {
        	return Player.PLAYER1;
        } else if (player2score > player1score) {
        	return Player.PLAYER2;
        }

        //no winner found, null returned - and so static draw variable should be 'true':
        this.draw = draw;
        return null;
    }

    @SuppressWarnings("unchecked")
    public static Map<Long, String> getPendingGames()
    {
        return (Map<Long, String>)DotsBoardWSSGame.pendingGames.clone();
    }

    public static long queueGame(String user1)
    {
        long id = DotsBoardWSSGame.gameIdSequence++;
        DotsBoardWSSGame.pendingGames.put(id, user1);
        return id;
    }

    public static void removeQueuedGame(long queuedId)
    {
        DotsBoardWSSGame.pendingGames.remove(queuedId);
    }

    public static DotsBoardWSSGame startGame(long queuedId, String user2)
    {
        String user1 = DotsBoardWSSGame.pendingGames.remove(queuedId);
        DotsBoardWSSGame game = new DotsBoardWSSGame(queuedId, user1, user2);
        DotsBoardWSSGame.activeGames.put(queuedId, game);
        return game;
    }

    public static DotsBoardWSSGame getActiveGame(long gameId)
    {
        return DotsBoardWSSGame.activeGames.get(gameId);
    }

    public enum Player
    {
        PLAYER1, PLAYER2, NOSIDES, ONESIDE, TWOSIDES, THREESIDES;

        private static final Random random = new Random();

        private static Player random()
        {
            return Player.random.nextBoolean() ? PLAYER1 : PLAYER2;
        }
    }
}
