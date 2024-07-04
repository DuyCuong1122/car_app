import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String time;
  final String user;
  const Comment(
      {super.key, required this.text, required this.time, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              user,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(text,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300)),
            const SizedBox(height: 5),
            Text(time,
                style: const TextStyle(
                    color: Color.fromRGBO(141, 137, 137, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w300))
          ]),
        ],
      ),
    );
  }
}
