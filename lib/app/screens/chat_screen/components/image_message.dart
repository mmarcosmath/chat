import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageMessage extends StatelessWidget {
  final String imagePath;
  final bool isSent;
  final String status;
  final String date;
  ImageMessage({
    Key? key,
    required this.imagePath,
    required this.isSent,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: isSent
            ? EdgeInsets.only(left: 30, top: 10, right: 5)
            : EdgeInsets.only(right: 30, top: 10, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSent
              ? Theme.of(context).primaryColor
              : Theme.of(context).backgroundColor,
        ),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Image.network(
                      imagePath,
                      frameBuilder: (BuildContext context, Widget child, frame,
                          bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          child: child,
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  );
                });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 200,
                width: 150,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  imagePath,
                  frameBuilder: (BuildContext context, Widget child, frame,
                      bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date.substring(11, 16),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Visibility(
                    visible: isSent,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        status == "sending"
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
      ),
    );
  }
}
