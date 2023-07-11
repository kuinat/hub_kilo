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
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
            child: FadeInImage(
              width: 40,
              height: 40,
              image: NetworkImage(this.imageUrl, headers: Domain.getTokenHeaders()),
              placeholder: AssetImage(
                  "assets/img/loading.gif"),
              imageErrorBuilder:
                  (context, error, stackTrace) {
                return Image.asset(
                    "assets/img/téléchargement (1).png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.fitWidth);
              },
            )
        ),
        SizedBox(width: 20),
        Text(user, style: Get.textTheme.headline4)
      ],
    );
  }
}