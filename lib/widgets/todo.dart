import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Todo extends StatelessWidget {
  final String? text;
  final bool isDone;
  const Todo({Key? key, this.text, required this.isDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isDone
                  ? null
                  : Border.all(
                      color: Color(0xFF86829D),
                      width: 1.5,
                    ),
            ),
            child: Image(
              image: AssetImage("assets/images/check_icon.png"),
            ),
          ),
          Flexible(
            child: Text(
              text ?? "Unanmed Task",
              style: TextStyle(
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
