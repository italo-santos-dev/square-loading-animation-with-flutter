import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Squares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        seconds: 2,
      ),
      vsync: this,
    )..repeat();

    _animations = List.generate(4, (index) {
      final startInterval = index * 0.2;
      final endInterval = startInterval + 0.5;

      return TweenSequence([
        TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: -30).chain(
              CurveTween(curve: Curves.easeOut),
            ),
            weight: 50,
        ),
        TweenSequenceItem(
            tween: Tween<double>(begin: -30, end: 0).chain(
              CurveTween(curve: Curves.easeIn),
            ),
            weight: 50
        ),
      ]).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startInterval,
              endInterval.clamp(0.0, 1),
              curve: Curves.easeInOut,
            )
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSquare(Animation<double> animation, Color color) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Container(
              width: 20,
              height: 20,
              color: color,
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2F3336),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSquare(_animations[0], Colors.red),
            SizedBox(width: 10,),
            _buildSquare(_animations[1], Colors.green),
            SizedBox(width: 10,),
            _buildSquare(_animations[2], Colors.blue),
            SizedBox(width: 10),
            _buildSquare(_animations[3], Colors.yellow),
          ]
        ),
      ),
    );
  }
}