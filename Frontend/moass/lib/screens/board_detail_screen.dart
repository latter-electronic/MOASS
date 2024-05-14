import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/model/BoardModel.dart';
import 'package:moass/services/board_api.dart';
import 'package:moass/widgets/top_bar.dart';

class BoardDetailScreen extends ConsumerWidget {
  final int boardId;
  final int boardUserId;

  const BoardDetailScreen(
      {super.key, required this.boardId, required this.boardUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardApi = ref.read(boardApiProvider);

    return Scaffold(
      appBar: const TopBar(
        title: '모음 보드 세부 정보',
        icon: Icons.dashboard_outlined,
      ),
      body: FutureBuilder<List<ScreenshotModel>>(
        future: boardApi.boardScreenshotList(boardUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            final screenshots = snapshot.data!;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '보드 ID: $boardId',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ...screenshots.map((screenshot) {
                  return ListTile(
                    leading: Text("ID: ${screenshot.screenshotId}"),
                    title: Image.network(screenshot.screenshotUrl,
                        width: 300, height: 150, fit: BoxFit.cover),
                  );
                }),
              ],
            );
          }
          return const Center(child: Text("데이터가 없습니다"));
        },
      ),
    );
  }
}
