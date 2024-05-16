import 'package:flutter/material.dart';
import 'package:moass/model/related_gitlab_account.dart';

class GitlabIssueCardWidget extends StatefulWidget {
  final Issue issue;
  const GitlabIssueCardWidget({super.key, required this.issue});

  @override
  State<GitlabIssueCardWidget> createState() => _GitlabIssueCardWidgetState();
}

class _GitlabIssueCardWidgetState extends State<GitlabIssueCardWidget> {
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
                    widget.issue.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.issue.author.avatarUrl),
                        radius: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          widget.issue.author.name,
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
                    Text(widget.issue.description),
                    Text(
                      '생성 시간 : ${widget.issue.createdAt}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Text(
                      '수정 시간 : ${widget.issue.updatedAt}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
