import 'package:flutter/foundation.dart' show VoidCallback, immutable;
import 'package:social_up/views/components/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;

  const LinkText({
    required super.text,
    required this.onTapped,
    super.style,
  });
}
