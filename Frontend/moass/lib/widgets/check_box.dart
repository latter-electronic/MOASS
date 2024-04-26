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
  bool isPressed = false;

  detectPressed() {
    setState(() {
      isPressed = true;
    });
  }

  cancelPressed() {
    setState(() {
      isPressed = false;
    });
  }

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: () {
          detectPressed();
        },
        onTap: () {
          if (isPressed == true) {
            cancelPressed();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: isPressed == true
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
                  Text(
                    widget.text,
                    style: isChecked
                        ? const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)
                        : null,
                  )
                ],
              ),
              Container(
                child: isPressed
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          size: 15,
                          color: Colors.red,
                        ),
                      )
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
