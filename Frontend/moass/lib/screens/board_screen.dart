import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/model/BoardModel.dart';
import 'package:moass/riverpod/my_profile_river.dart';
import 'package:moass/screens/board_detail_screen.dart';
import 'package:moass/services/board_api.dart';
import 'package:moass/widgets/top_bar.dart';

// 더미 데이터 함수
Future<List<BoardModel>> fetchDummyBoards() async {
  return Future.delayed(
      const Duration(seconds: 1),
      () => [
            BoardModel(
              boardId: 1,
              boardName: '프로젝트 논의',
              memberImages: [
                MemberImage(userId: 1, url: 'https://picsum.photos/id/7/80/50'),
                MemberImage(
                    userId: 2, url: 'https://picsum.photos/id/63/90/50'),
                MemberImage(
                    userId: 2, url: 'https://picsum.photos/id/63/90/50'),
                MemberImage(
                    userId: 2, url: 'https://picsum.photos/id/63/90/50'),
                MemberImage(
                    userId: 2, url: 'https://picsum.photos/id/63/90/50'),
              ],
              images: [
                ImageDetail(
                    imageId: 101, url: 'https://picsum.photos/id/53/200/50'),
                ImageDetail(
                    imageId: 102, url: 'https://picsum.photos/id/33/200/50'),
              ],
            ),
            BoardModel(
              boardId: 2,
              boardName: '팀 회의',
              memberImages: [
                MemberImage(
                    userId: 3, url: 'https://picsum.photos/id/66/30/50'),
                MemberImage(
                    userId: 4, url: 'https://picsum.photos/id/59/100/50'),
              ],
              images: [
                ImageDetail(
                    imageId: 201, url: 'https://picsum.photos/id/300/200/50'),
              ],
            ),
          ]);
}

// BoardScreen 수정 ConsumerWidget 와 stateless는 같음 차이는 ref 추가
class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 전역관리 프로필 불러오기
    final profile = ref.watch(profileProvider);
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: const TopBar(
        title: '모음 보드',
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 10.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF6ECEF5),
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ListTile(
                      title: Text(board.boardName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Images count: ${board.images.length}"),
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          _buildMemberImages(board.memberImages),
                        ],
                      ),
                      trailing: (board.images.isNotEmpty)
                          ? Image.network(board.images[0].url,
                              width: 150, height: 70)
                          : const SizedBox(width: 50, height: 50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BoardDetailScreen(boardId: board.boardId),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildMemberImages(List<MemberImage> memberImages) {
  return SizedBox(
    width: 100, // 원형 이미지들의 가로 길이
    height: 50, // 원형 이미지들의 세로 길이
    child: Stack(
      children: memberImages.map((image) {
        int index = memberImages.indexOf(image);
        double left = index * 10.0; // 각 이미지의 위치를 조절
        return Positioned(
          left: left,
          child: CircleAvatar(
            radius: 15, // 프로필 이미지의 반지름
            backgroundImage: NetworkImage(image.url),
          ),
        );
      }).toList(),
    ),
  );
}


// APi가 왔을때 사용할 코드
// class BoardScreen extends StatelessWidget {
//   final BoardApi apiService = BoardApi();

//   BoardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const TopBar(
//         title: '저장된 모음 조각',
//         icon: Icons.dashboard_outlined,
//       ),
//       body: FutureBuilder<List<BoardModel>>(
//         future: apiService.fetchBoards(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (snapshot.hasData && snapshot.data!.isEmpty) {
//             // 데이터가 없는 경우 비어있는 화면 표시
//             return const Center(child: Text("데이터가 없습니다"));
//           }
//           final boards = snapshot.data!;


//           return ListView.builder(
//             itemCount: boards.length,
//             itemBuilder: (context, index) {
//               final board = boards[index];
//               return ListTile(
//                 trailing: (board.images.isNotEmpty)
//                     ? Image.network(board.images[0].url, width: 50, height: 50)
//                     : const SizedBox(width: 50, height: 50), // 이미지가 없을 때 플레이스홀더
//                 title: Text(board.boardName),
//                 subtitle: Text("Images count: ${board.images.length}"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           BoardDetailScreen(boardId: board.boardId),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
