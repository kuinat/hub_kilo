import 'package:flutter/material.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          mainAxisExtent: 200.0,
        ),
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              width: double.infinity,
              height: 30,
              child: Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              )
          );
        });
  }
}