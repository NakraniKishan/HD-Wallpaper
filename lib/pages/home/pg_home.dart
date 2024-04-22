import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallpaperapp/pages/home/pg_fullscreen.dart';

import '../../models/networkerrordialog.dart';
import '../../models/photomodel.dart';

class pg_home extends StatefulWidget {
  @override
  State<pg_home> createState() => _pg_homeState();
}

class _pg_homeState extends State<pg_home> {
  List images = [];
  List testingdata = [];
  List testingphotosrcdata = [];
  int page = 1;

  final scrollControl = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollControl.addListener(_scrollListener);
    checkinternet();
    // seperatephotosrcdata();
  }
  //testing not working
  seperatephotosrcdata()async{
    print("Seperate Photo Src Data Function Called");
    var apireply = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
          "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
        });
    var jsonData = jsonDecode(apireply.body);
    // print("API jdonData Decoded : $jsonData");
    // Hamna json data ma all fullmap data che.
    // have emathi photo wali map list alag kari ne kam karshu.
    // have photo wali map list ne one by one map  select kari ne kam karshu.
    jsonData["photos"].forEach((element){
      PhotoModel phmodel = new PhotoModel();
      phmodel = PhotoModel.fromMap(element);
      testingphotosrcdata.add(phmodel.toMap());
    });
    print("testingphotosrcdata Data : $testingphotosrcdata");
  }
  //testing working
  seperatedata()async{
    print("Seperate Data Function Called");
    var apireply = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
          "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
        });
    var jsonData = jsonDecode(apireply.body);
    // print("API jdonData Decoded : $jsonData");
    // Hamna json data ma all fullmap data che.
    // have emathi photo wali map list alag kari ne kam karshu.
    // have photo wali map list ne one by one map  select kari ne kam karshu.
    jsonData["photos"].forEach((element){
      // LOM - List of Map = mathi 1 list is selected
      // for eg. have single single id one by one print thase as shown below
      // print("Element Id : ${element["id"]}");

      // full map jovo hoi to as shown below
      // print("All Data map by map in elelemt : $element}");

      //have aa list ma thodo data map mathi oocho karshu. atle k field 10 aapi che pan kamni 5 che
      //atle k list of photo aapdu navu bani jase.

      // ek class banavi ne obj banaivu.
      // jetli field joiti hoi atli class ma banavi devi.
      PhotoModel phmodel = new PhotoModel();
      // have one by one element lai ne class na object na member variable ma set kari devana.
      phmodel = PhotoModel.fromMap(element);
      //pachi ej object par class na member variable data ne map for ma return kari devana.
      print("Get specific data from element using class: $phmodel");
      testingdata.add(phmodel.toMap());
    });
    // have tame joi sako ke photos nu list oochu thai gyu hase.
    print("Testing Data : $testingdata");
  }

  checkinternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult[0] == ConnectivityResult.wifi ||
        connectivityResult[0] == ConnectivityResult.mobile) {
      if (page == 1) {
        getimages();
      } else {
        loadmore();
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
              if (page == 1) {
                getimages();
              } else {
                loadmore();
              }
            } else {
              Navigator.of(context).pop();
              checkinternet();
            }
          },
        ),
      );
    }
  }

  getimages() async {
    EasyLoading.show();
    try{
      var respond = await http.get(
          Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
          headers: {
            'Authorization':
            "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
          });
      var data = jsonDecode(respond.body);
      setState(() {
        images = data["photos"];
      });
      EasyLoading.dismiss();
    }catch(e){
      EasyLoading.dismiss();
      print("Catch Error is : $e");
    }

  }

  loadmore() async {
    EasyLoading.show();
    try{
      String newurl =
          "https://api.pexels.com/v1/curated?per_page=80&page=" + page.toString();
      var respond = await http.get(Uri.parse(newurl), headers: {
        'Authorization':
        "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
      });
      var data = jsonDecode(respond.body);
      setState(() {
        images.addAll(data["photos"]);
      });
      EasyLoading.dismiss();
    }catch(e){
      EasyLoading.dismiss();
      print("Catch Error is : $e");
    }

  }

  reloadimages() async {
    setState(() {
      page = 1;
      images.clear();
    });
    checkinternet();
  }

  Future<void> refresh() async {
    return Future.delayed(
      Duration(seconds: 2),
      () => reloadimages(),
    );
  }

  void _scrollListener(){
    if(scrollControl.position.pixels == scrollControl.position.maxScrollExtent)
      {
        setState(() {
          page = page + 1;
        });
        checkinternet();
        // print("_scrollListener called");
      }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          // title: Text("Wallpaper"),
          title: Text(
            "WALLPAPER",
            style: GoogleFonts.cherryCreamSoda(
                textStyle: TextStyle(
                  color: Colors.white,
                )),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed("pg_searchimage");
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          
          
          child: Column(
            
            children: [
              Expanded(
                child: Container(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: GridView.builder(
                        itemCount: images.length,
                        controller: scrollControl,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => pg_fullscreen(
                                    imageurl: images[index]["src"]["portrait"]),
                              ));
                            },
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.green,
                              //   borderRadius: BorderRadius.all(Radius.circular(10)),
                              //
                              //
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                    images[index]["src"]["large"],
                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset("assets/images/nointernet/image.png",fit: BoxFit.contain,);
                                    }
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     // setState(() {
              //     //   page = page + 1;
              //     // });
              //     // checkinternet();
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     height: 60,
              //     width: double.infinity,
              //     child: Center(
              //         child: Text(
              //           "Load More Image",
              //           style: GoogleFonts.cherryCreamSoda(
              //               textStyle: TextStyle(
              //                 color: Colors.white,
              //               )),
              //         )
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
