import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../account/widgets/account_link_widget.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({Key key,
    @required this.user,
    @required this.color,
    @required this.imageUrl,

    @required this.text,
    @required this.onPressed}) : super(key: key);

  final Color color;
  final String user;
  final String text;

  final String imageUrl;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                ''
              ), fit: BoxFit.cover
            )),
        ),
        SizedBox(width: 20,),
        Text(user)
      ],
    );
  }
}