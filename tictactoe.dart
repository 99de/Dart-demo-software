import 'dart:io';

void main() {
  // Initialize the Tic-Tac-Toe board
  List<List<String>> board = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9']
  ];

  String currentPlayer = 'X'; // X always starts
  bool gameWon = false;

  // Display the board
  void displayBoard() {
    for (var row in board) {
      print(row.join(' | '));
      print('---------');
    }
  }

  // Check if the current player has won
  bool checkWin() {
    // Rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == currentPlayer &&
          board[i][1] == currentPlayer &&
          board[i][2] == currentPlayer) {
        return true;
      }
    }
    // Columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == currentPlayer &&
          board[1][i] == currentPlayer &&
          board[2][i] == currentPlayer) {
        return true;
      }
    }
    // Diagonals
    if (board[0][0] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][2] == currentPlayer) {
      return true;
    }
    if (board[0][2] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][0] == currentPlayer) {
      return true;
    }

    return false;
  }

  // Check if the board is full
  bool isBoardFull() {
    for (var row in board) {
      for (var cell in row) {
        if (cell != 'X' && cell != 'O') {
          return false;
        }
      }
    }
    return true;
  }

  // Main game loop
  while (!gameWon && !isBoardFull()) {
    displayBoard();
    print('Player $currentPlayer, enter a number (1-9) to place your mark:');
    
    // Get input and validate it
    String? input = stdin.readLineSync();
    int? move = int.tryParse(input ?? '');
    if (move == null || move < 1 || move > 9) {
      print('Invalid input. Please enter a number between 1 and 9.');
      continue;
    }

    // Calculate row and column from move
    int row = (move - 1) ~/ 3;
    int col = (move - 1) % 3;

    // Check if the cell is already occupied
    if (board[row][col] == 'X' || board[row][col] == 'O') {
      print('Cell is already occupied. Choose another.');
      continue;
    }

    // Place the mark and check for a win
    board[row][col] = currentPlayer;
    gameWon = checkWin();

    // If the game is won, display the board and announce the winner
    if (gameWon) {
      displayBoard();
      print('Player $currentPlayer wins!');
    } else if (isBoardFull()) {
      displayBoard();
      print('It\'s a draw!');
    } else {
      // Switch player
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }
  }
}
