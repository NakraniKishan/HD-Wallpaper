import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallpaperapp/pages/home/pg_fullscreen.dart';
import 'package:http/http.dart' as http;

class pg_searchimage extends StatefulWidget {
  @override
  State<pg_searchimage> createState() => _pg_searchimageState();
}

class _pg_searchimageState extends State<pg_searchimage> {

  TextEditingController searchtext = TextEditingController();
  final scrollControl = ScrollController();
  final _formkey = GlobalKey<FormState>();
  List images = [];
  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollControl.addListener(_scrollListener);
  }

  void _scrollListener(){
    if(scrollControl.position.pixels == scrollControl.position.maxScrollExtent)
    {
      setState(() {
        page = page + 1;
      });
      loadmore();
      // print("_scrollListener called");
    }

  }



  getimages() async {
    EasyLoading.show();

    try{
      setState(() {
        page = 0;
      });

      print("Page Value before call : $page");
      var respond = await http.get(
          Uri.parse(
              "https://api.pexels.com/v1/search?query=${searchtext.text.toString()}&per_page=80"),
          headers: {
            'Authorization':
            "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
          });
      var data = jsonDecode(respond.body);
      setState(() {
        images = data["photos"];
        if (page == 0) {
          page = page + 1;
        }
      });
      print("Page Value after call : $page");
      EasyLoading.dismiss();
    }catch(e){
      EasyLoading.dismiss();
      print("Catch Error is : $e");
    }

  }

  loadmore() async {
    EasyLoading.show();

    try{
      print("Page Value before loadmore : $page");
      setState(() {
        page = page + 1;
      });
      String newurl =
          "https://api.pexels.com/v1/search?query=${searchtext.text.toString()}&per_page=80&page=" +
              page.toString();
      // print("NewUrl in loadmore : $newurl");
      var respond = await http.get(Uri.parse(newurl), headers: {
        'Authorization':
        "kDvwTyFodolWzvcg5KBLKSck8sHcvl0yYiz3V75s6sKHaQ6EW4zpwtzo"
      });
      var data = jsonDecode(respond.body);
      setState(() {
        images.addAll(data["photos"]);
      });
      print("Page Value after loadmore : $page");
      EasyLoading.dismiss();
    }catch(e){
      EasyLoading.dismiss();
      print("Catch Error is : $e");
    }

  }

  reloadimages() async {
    // EasyLoading.show();
    setState(() {
      page = 1;
      images.clear();
    });
    getimages();
    // EasyLoading.dismiss();
  }

  Future<void> refresh() async {
    return Future.delayed(
      Duration(seconds: 2),
      () => reloadimages(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Form(
            key: _formkey,
            child: TextFormField(
              controller: searchtext,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for Amazing Images",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                focusColor: Colors.white,
                hoverColor: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    // if(searchtext.text.isNotEmpty || searchtext.text.contains(" ")  )
                    if (searchtext.text.contains(" ") ||
                        searchtext.text.isEmpty) {
                    } else {
                      getimages();
                    }
                  }
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
                  child: images.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: GridView.builder(
                              itemCount: images.length,
                              controller: scrollControl,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => pg_fullscreen(
                                          imageurl: images[index]["src"]
                                              ["original"]),
                                    ));
                                    // Get.toNamed("pg_fullscreen",parameters: images[index]["src"]["large2x"].toString() );
                                  },
                                  child: Container(
                                    // color: Colors.blue,
                                    child: Image.network(
                                      images[index]["src"]["large"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // page >= 1
              //     ? InkWell(
              //         onTap: () {
              //           loadmore();
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: Colors.black,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //           height: 60,
              //           width: double.infinity,
              //           child: Center(
              //               child: Text(
              //             "Load More Image",
              //             style: TextStyle(color: Colors.white),
              //           )),
              //         ),
              //       )
              //     : Container()
            ],
          ),
        ),
      ),
    );
  }
}
