import 'package:flutter/material.dart';
import 'package:moass/model/related_gitlab_account.dart';

class GitlabMRCardWidget extends StatefulWidget {
  final MergeRequest mergeRequest;
  const GitlabMRCardWidget({super.key, required this.mergeRequest});

  @override
  State<GitlabMRCardWidget> createState() => _GitlabMRCardWidgetState();
}

class _GitlabMRCardWidgetState extends State<GitlabMRCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(color: Color(0xFFF66A26)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.mergeRequest.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.mergeRequest.author.avatarUrl),
                        radius: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          widget.mergeRequest.author.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('리뷰어 :'),
                        for (var reviewer in widget.mergeRequest.reviewers)
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(reviewer.avatarUrl),
                                  radius: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    reviewer.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '소스 브랜치 : ${widget.mergeRequest.sourceBranch}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Text(
                      '타겟 브랜치 : ${widget.mergeRequest.targetBranch}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Row(
                      children: [
                        for (var label in widget.mergeRequest.labels)
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                    color: Color(0xFF6ECEF5)),
                                child: Center(
                                  child: Text(
                                    label.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                )),
                          )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
