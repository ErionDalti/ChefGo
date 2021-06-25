import 'package:flutter/material.dart';
import 'package:RestaurantAppMobile/Pages/home_page.dart';

class PageRoutes {
  static const String homePage = 'home_page';
  // static const String itemInfoPage = 'item_info';

  Map<String, WidgetBuilder> routes() {
    return {
      homePage: (context) => HomePage(),
      // itemInfoPage: (context) => ItemInfoPage(),
    };
  }
}
