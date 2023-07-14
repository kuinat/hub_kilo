import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';

class PopUpWidget extends StatelessWidget {
  const PopUpWidget({Key key,
    @required this.cancel,
    @required this.confirm,
    @required this.onTap,
    @required this.icon,
    @required this.title
  }) : super(key: key);

  final String cancel;
  final String confirm;
  final String title;
  final Widget icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      icon: icon,
      content: Text(title, style: Get.textTheme.headline1.merge(TextStyle(fontSize: 15, color: Colors.black))),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: ()=>{
              Navigator.pop(context)
            },
                child: Text(cancel, style: TextStyle(color: inactive))),
            SizedBox(width: 10),
            TextButton(onPressed: onTap,
                child: Text(confirm, style: TextStyle(color: specialColor)))
          ],
        )
      ],
    );
  }
}
