import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TapCounterApp());
}

class TapCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TapCounterHomePage(),
    );
  }
}

class TapCounterHomePage extends StatefulWidget {
  @override
  _TapCounterHomePageState createState() => _TapCounterHomePageState();
}

class _TapCounterHomePageState extends State<TapCounterHomePage>
    with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadTapCount();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementTapCount() {
    setState(() {
      _tapCount++;
      if (_tapCount % 10 == 0) {
        _changeBackgroundColor();
      }
      _saveTapCount();
      _controller.forward(from: 0);
    });
  }

  void _changeBackgroundColor() {
    setState(() {
      _backgroundColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    });
  }

  Future<void> _loadTapCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tapCount = prefs.getInt('tapCount') ?? 0;
    });
  }

  Future<void> _saveTapCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('tapCount', _tapCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _incrementTapCount();
              },
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/eggplant.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '$_tapCount',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
