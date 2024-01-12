// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget buildDetail(String label, String value,
    {CrossAxisAlignment alignment = CrossAxisAlignment.end}) {
  return Column(
    crossAxisAlignment: alignment,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      SizedBox(height: 12),
    ],
  );
}
