import 'package:application/app/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String uuid;
  final String image;
  final String name;
  final String lastMessage;
  final String date;
  final bool hasMessage;
  // final String countMessage;
  const CustomListTile({
    Key? key,
    required this.image,
    required this.name,
    required this.lastMessage,
    required this.date,
    // required this.countMessage,
    required this.uuid,
    required this.hasMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  uuid: uuid,
                  name: name,
                  image: image,
                ),
              ),
            );
          },
          minVerticalPadding: 20,
          minLeadingWidth: 50,
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: ClipOval(
            child: Image.network(
              image,
              fit: BoxFit.fitWidth,
            ),
          ),
          title: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            lastMessage,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          trailing: Container(
            child: Column(
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                Visibility(
                  visible: hasMessage,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
