import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../models/networkerrordialog.dart';

class pg_fullscreen extends StatefulWidget {
  final String imageurl;


  pg_fullscreen({required this.imageurl});

  @override
  State<pg_fullscreen> createState() => _pg_fullscreenState();
}

class _pg_fullscreenState extends State<pg_fullscreen> {
  var chk=0;
  var imagepath;
  bool isloading=true;
  var imagefile;
  var selectscreen="H";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkinternet();
  }

  setwallpaper(String s) async {

    if(s=="H"){
      var location = WallpaperManager.HOME_SCREEN;
      bool result =
          await WallpaperManager.setWallpaperFromFile(imagefile.path, location);
      // print("Results is : $result");
      if (result) {
        setState(() {
          chk=0;
        });
        MotionToast.success(
          title: Text("Success"),
          description: Text("Wallpaper Set Successfully            "),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.bottom,
          dismissable: false,
        ).show(context);
      }
    }
    else if(s=="L"){
      var location = WallpaperManager.LOCK_SCREEN;
      bool result =
          await WallpaperManager.setWallpaperFromFile(imagefile.path, location);
      // print("Results is : $result");
      if (result) {
        setState(() {
          chk=0;
        });
        MotionToast.success(
          title: Text("Success"),
          description: Text("Wallpaper Set Successfully            "),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.bottom,
          dismissable: false,
        ).show(context);
      }
    }
    else if(s=="B"){
      var location = WallpaperManager.BOTH_SCREEN;
      bool result =
          await WallpaperManager.setWallpaperFromFile(imagefile.path, location);
      // print("Results is : $result");
      if (result) {
        setState(() {
          chk=0;
        });
        MotionToast.success(
          title: Text("Success"),
          description: Text("Wallpaper Set Successfully            "),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.bottom,
          dismissable: false,
        ).show(context);
      }
    }
    // print("Location is : $location");
    //  file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    // print("File is : $file");
    // bool result =
    //     await WallpaperManager.setWallpaperFromFile(imagefile.path, location);
    // // print("Results is : $result");
    // if (result) {
    //   setState(() {
    //     chk=0;
    //   });
    //   MotionToast.success(
    //     title: Text("Success"),
    //     description: Text("Wallpaper Set Successfully            "),
    //     layoutOrientation: ToastOrientation.ltr,
    //     animationType: AnimationType.fromTop,
    //     position: MotionToastPosition.bottom,
    //     dismissable: false,
    //   ).show(context);
    // }
  }

  getwallpaper()async{

    try{

      var response = await http.get(Uri.parse(widget.imageurl));

      if (response.statusCode == 200) {
        imagefile = await DefaultCacheManager().getSingleFile(widget.imageurl);
        var dir = await getTemporaryDirectory();
        File file=new File(dir.path+"/a.jpg");
        await file.writeAsBytes(response.bodyBytes,flush: true);
        imagepath = file.path.toString();
        setState(() {
          isloading=false;
        });
      }

    }catch(e){
      print("Try Block Error is : $e");
    }

  }


  checkinternet() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    print("Connection result : ${connectivityResult[0]}");
    if (connectivityResult[0] == ConnectivityResult.wifi ||
        connectivityResult[0] == ConnectivityResult.mobile) {
      if(chk==1)
        {
          print("Ready to print alert dialog");
          showDialog(

            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              shadowColor: Colors.white,
              backgroundColor: Colors.white,
              title: Text("Apply"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: (){
                      setwallpaper("H");
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.black,
                    focusColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    title: Text("Set Home Screen"),
                  ),
                  ListTile(
                    onTap: (){
                      setwallpaper("L");
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.black,
                    focusColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    title: Text("Set Lock Screen"),
                  ),
                  ListTile(
                    onTap: (){
                      setwallpaper("B");
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.black,
                    focusColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    title: Text("Set Both Screen"),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton(
                  //       child: const Text("Cancel"),
                  //       onPressed: (){
                  //         Navigator.of(context).pop();
                  //       },
                  //     ),
                  //     ElevatedButton(
                  //       child: const Text("Set"),
                  //       onPressed: (){
                  //         print(selectscreen);
                  //         // setwallpaper();
                  //       },
                  //     )
                  //   ],
                  // ),

                ],
              ),
            ),
          );

          // setwallpaper();
        }
      else{

        getwallpaper();
      }

    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => NetworkErrorDialog(
          onPressed: () async {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult[0] == ConnectivityResult.wifi ||
                connectivityResult[0] == ConnectivityResult.mobile) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
              checkinternet();
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            title: Text(
              "Set Wallpaper",
              style: GoogleFonts.cherryCreamSoda(
                  textStyle: TextStyle(
                color: Colors.white,
              )),
            ),
            centerTitle: true,
            actions: [
              isloading==false ?
                  IconButton(
                onPressed: () async {
                  // EasyLoading.show();

                  await Share.shareXFiles([XFile('${imagepath.toString()}')]);
                  // try{
                  //   var response = await http.get(Uri.parse(widget.imageurl));
                  //
                  //   if (response.statusCode == 200) {
                  //
                  //     var dir = await getTemporaryDirectory();
                  //     File file=new File(dir.path+"/.jpg");
                  //     await file.writeAsBytes(response.bodyBytes,flush: true);
                  //     await Share.shareXFiles([XFile('${file.path.toString()}')]);
                  //     // return file.path.toString();
                  //   }
                  //
                  // }catch(e){
                  //   print("Try Block Error is : $e");
                  // }



                },
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ):Container()
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(

                        widget.imageurl,
                        fit: BoxFit.cover,
                          errorBuilder:
                              (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset("assets/images/nointernet/image.png",fit: BoxFit.contain,);
                          },
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if(loadingProgress == null){

                            return child;
                          }
                          else{
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                        },
                      ),
                    ),
                  )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       chk=1;
                  //     });
                  //     // setwallpaper();
                  //     checkinternet();
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     height: 60,
                  //     width: double.infinity,
                  //     child: Center(
                  //       child: Text(
                  //         "Set Lock Screen Wallpaper",
                  //         // style: TextStyle(color: Colors.white),
                  //         style: GoogleFonts.cherryCreamSoda(
                  //             textStyle: TextStyle(
                  //               color: Colors.white,
                  //             )),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          )),
    );
  }
}
