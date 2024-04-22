// import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
class splashscreen extends StatefulWidget {

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(seconds: 5),
          () {
        Get.offAllNamed("pg_home");
        // abc();
        //Navigator.of(context).pop(),
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => Dashboard(),
        //   ),
        // ),
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Colors.red,
            image: DecorationImage(
              image: AssetImage("assets/splash/splash.jpg",),
              fit: BoxFit.cover,
              opacity: 0.8,

            )
          ),
          child: Column(
            children: [
              Spacer(flex: 3,),
              Text("WALLPAPER",style: GoogleFonts.cherryCreamSoda(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 40),),
              Spacer(flex: 3,),
              Lottie.asset("assets/lottie/splash.json",height: 130,),
              Spacer(flex: 2,),
            ],
          ),
        ),

        // body: Center(
        //   child: Text("Wallpaper"),
        // ),

      ),
    );
  }
}
