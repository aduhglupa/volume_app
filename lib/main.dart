import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentVolume = 0;

  @override
  void initState() {
    super.initState();
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _currentVolume = volume);
    });

    VolumeController().getVolume().then((volume) => _currentVolume = volume);
    VolumeController().showSystemUI = false;
  }

  @override
  void dispose() {
    super.dispose();
    VolumeController().removeListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Current volume: $_currentVolume'),
          ),
          Row(
            children: [
              const Text('Set Volume:'),
              Flexible(
                child: Slider(
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    _currentVolume = value;
                    VolumeController().setVolume(_currentVolume);
                    setState(() {});
                  },
                  value: _currentVolume,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => VolumeController().muteVolume(),
            child: const Text('Mute Volume'),
          ),
          TextButton(
            onPressed: () => VolumeController().maxVolume(),
            child: const Text('Max Volume'),
          ),
        ],
      ),
    );
  }
}
