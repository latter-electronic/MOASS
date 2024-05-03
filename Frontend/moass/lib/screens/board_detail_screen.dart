import 'package:flutter/material.dart';
import 'package:moass/model/BoardModel.dart';
import 'package:moass/screens/board_screen.dart';
import 'package:moass/widgets/top_bar.dart';

class BoardDetailScreen extends StatelessWidget {
  final int boardId;

  const BoardDetailScreen({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
        title: '모음 보드 세부 정보',
        icon: Icons.dashboard_outlined,
      ),
      body: FutureBuilder<List<BoardModel>>(
        future: fetchDummyBoards(), // 더미 데이터 사용
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            final BoardModel board = snapshot.data!.firstWhere(
              (b) => b.boardId == boardId,
              // orElse: () => null // 이 부분을 수정했습니다.
            );
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    board.boardName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ...board.images.map((image) {
                  return ListTile(
                    leading: Text("ID: ${image.imageId}"),
                    title: Image.network(image.url,
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
