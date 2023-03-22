import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_up/views/components/rich_text/base_text.dart';
import 'package:social_up/views/components/rich_text/link_text.dart';

class RichTextWidget extends StatelessWidget {
  final Iterable<BaseText> texts;
  final TextStyle? styleForAll;

  const RichTextWidget({
    super.key,
    required this.texts,
    this.styleForAll,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          children: texts.map((BaseText baseText) {
        if (baseText is LinkText) {
          return TextSpan(
            text: baseText.text,
            style: styleForAll?.merge(baseText.style).copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                ),
            recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
          );
        } else {
          return TextSpan(
            text: baseText.text,
            style: styleForAll?.merge(baseText.style),
          );
        }
      }).toList()),
    );
  }
}
