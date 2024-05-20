import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moass/model/boardModel.dart';
import 'package:moass/screens/board_screenshot_detail_screen.dart';
import 'package:moass/services/board_api.dart';
import 'package:moass/widgets/top_bar.dart';

class BoardDetailScreen extends ConsumerWidget {
  final int boardId;
  final String boardName;
  final int boardUserId;

  const BoardDetailScreen({
    super.key,
    required this.boardId,
    required this.boardUserId,
    required this.boardName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardApi = ref.read(boardApiProvider);

    return Scaffold(
      appBar: const TopBar(
        title: '이음 보드 세부 정보',
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
                    '보드 이름: $boardName',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text('   * 왼쪽 드래그: 삭제 / 오른쪽 드래그: 저장'),
                ...screenshots.map((screenshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: CustomDismissible(
                      screenshot: screenshot,
                      boardApi: boardApi,
                      boardId: boardId,
                      boardUserId: boardUserId,
                    ),
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

class CustomDismissible extends StatefulWidget {
  final ScreenshotModel screenshot;
  final BoardApi boardApi;
  final int boardId;
  final int boardUserId;

  const CustomDismissible({
    super.key,
    required this.screenshot,
    required this.boardApi,
    required this.boardId,
    required this.boardUserId,
  });

  @override
  _CustomDismissibleState createState() => _CustomDismissibleState();
}

class _CustomDismissibleState extends State<CustomDismissible> {
  double _dragExtent = 0.0;
  final double _maxDragDistance = 80.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragExtent += details.primaryDelta ?? 0;
          if (_dragExtent < -_maxDragDistance) {
            _dragExtent = -_maxDragDistance;
          } else if (_dragExtent > _maxDragDistance) {
            _dragExtent = _maxDragDistance;
          }
        });
      },
      onHorizontalDragEnd: (details) async {
        if (_dragExtent <= -_maxDragDistance) {
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("삭제 확인"),
                  content: const Text("스크린샷을 삭제하시겠습니까?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("취소"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("삭제"),
                    ),
                  ],
                ),
              ) ??
              false;
          if (confirmed) {
            await widget.boardApi
                .boardScreenshotDelete(widget.screenshot.screenshotId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("스크린샷이 삭제되었습니다."),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else if (_dragExtent >= _maxDragDistance) {
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("다운로드 확인"),
                  content: const Text("이 스크린샷을 다운로드하시겠습니까?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("취소"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("네"),
                    ),
                  ],
                ),
              ) ??
              false;
          if (confirmed) {
            await _downloadImage(context, widget.screenshot.screenshotUrl);
          }
        }
        setState(() {
          _dragExtent = 0.0;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    alignment: Alignment.center,
                    width: -_dragExtent <= _maxDragDistance / 2 ? 90 : 0,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    alignment: Alignment.center,
                    width: _dragExtent <= _maxDragDistance / 2 ? 90 : 0,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 186, 238, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Text("ID: ${widget.screenshot.screenshotId}"),
                title: Image.network(widget.screenshot.screenshotUrl,
                    width: 300, height: 120, fit: BoxFit.cover),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardScreenshotDetailScreen(
                        screenshotUrl: widget.screenshot.screenshotUrl,
                        screenshotId: widget.screenshot.screenshotId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      // 다운로드 디렉토리 경로 가져오기
      Directory directory = Directory('/storage/emulated/0/Download');

      String filePath =
          '${directory.path}/screenshot${widget.screenshot.screenshotId}.jpg';
      await Dio().download(url, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("다운로드가 완료되었습니다."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("다운로드 실패: $e"),
        ),
      );
    }
  }
}
