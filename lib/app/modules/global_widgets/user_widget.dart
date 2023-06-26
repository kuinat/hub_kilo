import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../main.dart';
import '../account/widgets/account_link_widget.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({Key key,
    @required this.user,
    this.selected,
    @required this.imageUrl}) : super(key: key);

  final String user;
  final bool selected;
  final String imageUrl;


  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imageUrl, headers: Domain.getTokenHeaders()), fit: BoxFit.cover
              )),
        ),
        SizedBox(width: 20),
        Text(user)
      ],
    );
  }
}