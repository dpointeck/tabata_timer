import 'package:flutter/material.dart';
import 'package:tabata_timer/theme/palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text("Work",
                      style: TextStyle(fontSize: 24, color: Palette.yellow500)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const StyledButton(text: "-"),
                    Row(
                      children: const [
                        Text("30",
                            style: TextStyle(
                                fontSize: 32,
                                height: 1.0,
                                color: Palette.yellow500)),
                        Text("sec",
                            style: TextStyle(
                                height: 2.0, color: Palette.yellow500)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    const StyledButton(text: "+"),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final String text;

  const StyledButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Palette.yellow500, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Palette.almostBlack)),
        ));
  }
}
