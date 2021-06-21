import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TextMessage extends StatefulWidget {
  final bool isSent;
  final String message;
  final String status;
  final String file;
  final String date;
  const TextMessage({
    Key? key,
    required this.message,
    required this.isSent,
    required this.file,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ' $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: widget.isSent
            ? EdgeInsets.only(left: 30, top: 10, right: 5)
            : EdgeInsets.only(right: 30, top: 10, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isSent
              ? Theme.of(context).primaryColor
              : Theme.of(context).backgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: widget.file.isEmpty,
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: 16,
                  height: 1,
                  color: Colors.white,
                ),
              ),
              replacement: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: widget.message,
                  ),
                  TextSpan(
                    text: ' link: ${widget.file}',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          _launchInBrowser(widget.file);
                        });
                      },
                  )
                ]),
                style: TextStyle(
                  fontSize: 16,
                  height: 1,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.date.substring(11, 16),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Visibility(
                  visible: widget.isSent,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      widget.status == "sending"
                          ? Icons.check_circle_outline_rounded
                          : Icons.check_circle_rounded,
                      color: DynamicTheme.of(context)!.themeId == 0
                          ? Colors.white.withOpacity(0.8)
                          : Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
