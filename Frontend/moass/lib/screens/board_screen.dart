import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moass/model/boardModel.dart';
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
        title: '이음 보드',
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('어라, 아직 저장한 이음보드가 없어요!'),
                  Lottie.asset('assets/img/noDataCat.json',
                      repeat: true, animate: true),
                ],
              ),
            );
          }
          final boards = snapshot.data!;
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '이음 보드',
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
                          vertical: 10.0, horizontal: 20.0),
                      child: ClipPath(
                        clipper: ReversedFolderClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.yellow, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            // contentPadding: const EdgeInsets.all(16.0),
                            title: Text(board.boardName ?? 'Unnamed Board'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("이미지 갯수: ${screenshots.length}"),
                                const SizedBox(height: 10),
                                _buildScreenshotImages(screenshots),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoardDetailScreen(
                                    boardId: board.boardId,
                                    boardUserId: board.boardUserId,
                                    boardName:
                                        board.boardName ?? 'Unnamed Board',
                                  ),
                                ),
                              );
                            },
                          ),
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
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class ReversedFolderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double tabHeight = size.height * 0.2;
    double tabWidth = size.width * 0.6;

    path.moveTo(0, 0);
    path.lineTo(size.width - tabWidth - 10, 0);
    path.lineTo(size.width - tabWidth, tabHeight);
    path.lineTo(size.width, tabHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(ReversedFolderClipper oldClipper) => false;
}
