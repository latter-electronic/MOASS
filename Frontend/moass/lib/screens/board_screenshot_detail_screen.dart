import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoardScreenshotDetailScreen extends StatefulWidget {
  final String screenshotUrl;
  final int screenshotId;

  const BoardScreenshotDetailScreen(
      {super.key, required this.screenshotUrl, required this.screenshotId});

  @override
  _BoardScreenshotDetailScreenState createState() =>
      _BoardScreenshotDetailScreenState();
}

class _BoardScreenshotDetailScreenState
    extends State<BoardScreenshotDetailScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setLandscape();
  }

  @override
  void dispose() {
    _setPortrait();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setLandscape();
    }
  }

  void _setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _setPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenshot Detail'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Screenshot ID: ${widget.screenshotId}',
                style: const TextStyle(fontSize: 12)),
            // const SizedBox(height: 20),
            Expanded(
              child: InteractiveViewer(
                child: SizedBox(
                  width: 600, // 원하는 너비로 조정
                  height: 80, // 원하는 높이로 조정
                  child: Image.network(
                    widget.screenshotUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
