import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String text;
  const CheckboxWidget({
    super.key,
    required this.text,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color(0xFF6ECEF5);
      }
      return const Color(0xFF6ECEF5);
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.black,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        Text(widget.text)
      ],
    );
  }
}
