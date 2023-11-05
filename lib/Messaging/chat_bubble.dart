import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final int textColor;
  const ChatBubble({
    super.key,
    required this.message,
    required this.color,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    if(textColor == 0){
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
    else{
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
    }
  }
}