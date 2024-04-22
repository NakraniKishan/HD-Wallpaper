
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:wallpaperapp/pages/home/pg_fullscreen.dart';
import 'package:wallpaperapp/pages/home/pg_home.dart';
import 'package:wallpaperapp/pages/home/pg_searchimage.dart';
import 'package:wallpaperapp/pages/splash/splashscreen.dart';


var pages = [
  GetPage(
    name: "/splashscreen",

    page: () => splashscreen(),
  ),
  GetPage(
    name: "/pg_home",

    page: () => pg_home(),
  ),
  GetPage(
    name: "/pg_fullscreen",

    page: () => pg_fullscreen(imageurl: '',),
  ),
  GetPage(
    name: "/pg_searchimage",

    page: () => pg_searchimage(),
  ),








];