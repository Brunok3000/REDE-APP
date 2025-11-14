import 'package:flutter/material.dart';

class ProfilePublic extends StatelessWidget {
  final String userName;
  const ProfilePublic({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(userName));
  }
}