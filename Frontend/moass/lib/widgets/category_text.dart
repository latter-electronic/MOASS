import 'package:flutter/cupertino.dart';

class CategoryText extends StatelessWidget {
  final String text;
  final EdgeInsets padding;

  const CategoryText({
    super.key,
    required this.text,
    this.padding =
        const EdgeInsets.only(top: 10.0, bottom: 10, left: 14.0, right: 14.0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
