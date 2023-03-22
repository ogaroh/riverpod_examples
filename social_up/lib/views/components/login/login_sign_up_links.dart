import 'package:flutter/material.dart';
import 'package:social_up/extensions/dev/log.dart';
import 'package:social_up/views/components/rich_text/base_text.dart';
import 'package:social_up/views/components/rich_text/rich_text_widget.dart';
import 'package:social_up/views/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginViewSignupLinks extends StatelessWidget {
  const LoginViewSignupLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      styleForAll:
          Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5),
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        BaseText.link(
          text: Strings.facebook,
          onTapped: () async {
            final Uri url = Uri.parse(Strings.facebookSignupUrl);

            if (!await launchUrl(url)) {
              "Unable to launch URL: $url".log();
            }
          },
        ),
        BaseText.plain(
          text: Strings.orCreateAnAccountOn,
        ),
        BaseText.link(
          text: Strings.google,
          onTapped: () async {
            final Uri url = Uri.parse(Strings.googleSignupUrl);

            if (!await launchUrl(url)) {
              "Unable to launch URL: $url".log();
            }
          },
        ),
      ],
    );
  }
}
