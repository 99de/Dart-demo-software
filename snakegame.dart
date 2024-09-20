import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SnakeGameHome(),
    );
  }
}

class SnakeGameHome extends StatefulWidget {
  @override
  _SnakeGameHomeState createState() => _SnakeGameHomeState();
}

class _SnakeGameHomeState extends State<SnakeGameHome> {
  static const int gridSize = 20;
  //static const double blockSize = 20.0;

  List<Offset> snake = [Offset(0.0, 0.0)];
  Offset food = Offset(5.0, 5.0);
  String direction = 'right';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    snake = [Offset(0.0, 0.0)];
    direction = 'right';
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      moveSnake();
      checkCollision();
      setState(() {});
    });
  }

  void moveSnake() {
    Offset head = snake.first;
    switch (direction) {
      case 'up':
        snake.insert(0, Offset(head.dx, head.dy - 1.0));
        break;
      case 'down':
        snake.insert(0, Offset(head.dx, head.dy + 1.0));
        break;
      case 'left':
        snake.insert(0, Offset(head.dx - 1.0, head.dy));
        break;
      case 'right':
        snake.insert(0, Offset(head.dx + 1.0, head.dy));
        break;
    }

    if (snake.first == food) {
      food = Offset(Random().nextInt(gridSize).toDouble(), Random().nextInt(gridSize).toDouble());
    } else {
      snake.removeLast();
    }
  }

  void checkCollision() {
    Offset head = snake.first;
    if (head.dx < 0 ||
        head.dx >= gridSize ||
        head.dy < 0 ||
        head.dy >= gridSize ||
        snake.sublist(1).contains(head)) {
      timer?.cancel();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score: ${snake.length - 1}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text('Restart'),
            ),
          ],
        ),
      );
    }
  }

  void changeDirection(String newDirection) {
    if ((direction == 'up' && newDirection != 'down') ||
        (direction == 'down' && newDirection != 'up') ||
        (direction == 'left' && newDirection != 'right') ||
        (direction == 'right' && newDirection != 'left')) {
      direction = newDirection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            changeDirection('down');
          } else if (details.delta.dy < 0) {
            changeDirection('up');
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            changeDirection('right');
          } else if (details.delta.dx < 0) {
            changeDirection('left');
          }
        },
        child: Container(
          color: Colors.black,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              Offset position = Offset(index % gridSize.toDouble(), (index ~/ gridSize).toDouble());
              bool isSnake = snake.contains(position);
              bool isFood = position == food;
              return Container(
                margin: EdgeInsets.all(1.0),
                color: isSnake ? Colors.green : isFood ? Colors.red : Colors.black,
              );
            },
          ),
        ),
      ),
    );
  }
}