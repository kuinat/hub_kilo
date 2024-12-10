
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';


class SplashView extends GetView<AuthController>{

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen.withScreenFunction(
      splash: Lottie.asset("assets/img/home-delivery.json", frameRate: FrameRate.max,),
      duration: 10000,
      splashIconSize: double.infinity,
      screenFunction: () async{
        return LoginView();
      },
      //splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
      //pageTransitionType: PageTransitionType.scale,
    );
  }
}