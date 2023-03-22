import 'package:flutter/foundation.dart' show VoidCallback, immutable;
import 'package:flutter/material.dart'
    show Colors, FontWeight, TextDecoration, TextStyle;

import 'link_text.dart';

@immutable
class BaseText {
  final String text;
  final TextStyle? style;

  const BaseText({
    required this.text,
    this.style,
  });

  // plain text
  factory BaseText.plain({
    required String text,
    TextStyle? style = const TextStyle(),
  }) =>
      BaseText(
        text: text,
        style: style,
      );

  // link text
  factory BaseText.link({
    required String text,
    required VoidCallback onTapped,
    TextStyle? style = const TextStyle(
      // decoration: TextDecoration.underline,
      letterSpacing: 1.0,
      fontWeight: FontWeight.bold,
    ),
  }) =>
      LinkText(
        text: text,
        style: style,
        onTapped: onTapped,
      );
}
