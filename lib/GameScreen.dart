import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> board;
  late bool isPlayer1Turn;
  int player1Score = 0;
  int player2Score = 0;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayer1Turn = true;
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Score and game status display
          SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Player 1: $player1Score'),
                    Text('Player 2: $player2Score'),
                  ],
                ),
                Text(gameOver ? '' : 'Game in progress'),
              ],
            ),
          ),
          // Game board
          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (!gameOver && board[index].isEmpty) {
                      setState(() {
                        board[index] = isPlayer1Turn ? 'X' : 'O';
                        isPlayer1Turn = !isPlayer1Turn;
                        // Check for winner after each move
                        checkWinner();
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(child: Text(board[index], style: TextStyle(fontSize: 30))),
                  ),
                );
              },
            ),
          ),
          // Reset button
          if (gameOver)
            ElevatedButton(
              onPressed: resetGame,
              child: const Text('New Game'),
            ),
        ],
      ),
    );
  }

  void checkWinner() {
    // Define winning combinations
    List<List<int>> winCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]              // Diagonals
    ];

    // Check each winning combination
    for (var combo in winCombinations) {
      if (board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]] &&
          board[combo[0]].isNotEmpty) {
        // We have a winner
        setState(() {
          gameOver = true;
          if (board[combo[0]] == 'X') {
            player1Score++;
            _showWinDialog('Player 1');
          } else {
            player2Score++;
            _showWinDialog('Player 2');
          }
        });
        return;
      }
    }
    // Check for a draw
    if (!board.contains('')) {
      setState(() {
        gameOver = true;
        _showDrawDialog();
      });
    }
  }

  void _showWinDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$winner wins!'),
        content: Text('Congratulations! $winner has won the game.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Text('New Game'),
          ),
        ],
      ),
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('It\'s a Draw!'),
        content: Text('The game ended in a draw. Try again!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Text('New Game'),
          ),
        ],
      ),
    );
  }
}
