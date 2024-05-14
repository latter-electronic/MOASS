import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/model/BoardModel.dart';
import 'package:moass/screens/board_detail_screen.dart';
import 'package:moass/services/board_api.dart';
import 'package:moass/widgets/top_bar.dart';

// BoardScreen 수정 ConsumerWidget 와 stateless는 같음 차이는 ref 추가
class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardApi = ref.read(boardApiProvider);

    return Scaffold(
      appBar: const TopBar(
        title: '모음 보드',
        icon: Icons.dashboard_outlined,
      ),
      body: FutureBuilder<List<BoardModel>>(
        future: boardApi.fetchBoards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("데이터가 없습니다"));
          }
          final boards = snapshot.data!;
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '보드 모음',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ...boards.map((board) {
                return FutureBuilder<List<ScreenshotModel>>(
                  future: boardApi.boardScreenshotList(board.boardUserId),
                  builder: (context, screenshotSnapshot) {
                    if (screenshotSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (screenshotSnapshot.hasError) {
                      return Center(
                          child: Text("Error: ${screenshotSnapshot.error}"));
                    }
                    final screenshots = screenshotSnapshot.data ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 10.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF6ECEF5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          title: Text(board.boardName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Images count: ${screenshots.length}"),
                              const SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              _buildScreenshotImages(screenshots),
                            ],
                          ),
                          trailing: (screenshots.isNotEmpty)
                              ? Image.network(
                                  screenshots[0].screenshotUrl,
                                  width: 150,
                                  height: 70,
                                )
                              : const SizedBox(width: 50, height: 50),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoardDetailScreen(
                                  boardId: board.boardId,
                                  boardUserId: board.boardUserId,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScreenshotImages(List<ScreenshotModel> screenshots) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: screenshots.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.network(
              screenshots[index].screenshotUrl,
              width: 100,
              height: 70,
            ),
          );
        },
      ),
    );
  }
}
