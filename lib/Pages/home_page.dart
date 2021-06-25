import 'dart:convert';
import 'dart:developer';

import 'package:RestaurantAppMobile/Models/MergeOrderModel.dart';
import 'package:RestaurantAppMobile/Models/Order.dart';
import 'package:RestaurantAppMobile/Models/OrderItem.dart';
import 'package:RestaurantAppMobile/Models/OrderMeta.dart';
import 'package:RestaurantAppMobile/Models/Original.dart';
import 'package:RestaurantAppMobile/Models/Shipping.dart';
import 'package:RestaurantAppMobile/Pages/table_selection.dart';
import 'package:RestaurantAppMobile/Repository/Repository.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:RestaurantAppMobile/Components/custom_circular_button.dart';
import 'package:RestaurantAppMobile/Locale/locales.dart';
import 'package:RestaurantAppMobile/Models/CartItem.dart';
import 'package:RestaurantAppMobile/Models/FoodItem.dart';
import 'package:RestaurantAppMobile/Models/ItemCategory.dart';
import 'package:RestaurantAppMobile/Pages/item_info.dart';
import 'package:RestaurantAppMobile/Pages/orderPlaced.dart';
import 'package:RestaurantAppMobile/Theme/colors.dart';
import 'package:RestaurantAppMobile/Models/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  final tableId;
  final tableStatus;
  final tableName;
  HomePage({Key key, this.tableId, this.tableStatus, this.tableName})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double count;
  bool _isLoading = false;
  SharedPreferences _prefs;
  List<ItemCategory> foodCategories = new List<ItemCategory>();
  List<FoodItem> foodItems = new List<FoodItem>();
  Repository _repository = new Repository();

  List<CartItem> cartItems = [];

  void updateExtraOnSpecificItem(text) {
    setState(() {
      foodItems = foodItems
          .map((item) => item.itemId == itemToPassToInfoScreen.itemId
              ? (FoodItem(
                  item.itemId,
                  (item.image == null || item.image == "")
                      ? "assets/notfound3.png"
                      : item.image,
                  item.name,
                  item.isVeg,
                  item.price,
                  item.isSelected,
                  item.count,
                  text,
                  item.description,
                  item.categoryId))
              : item)
          .toList();
    });
  }

  _updateCartItemsCounter(id) {
    setState(() {
      _scaffoldKey.currentState.openEndDrawer();
      drawerCount = 0;
      FoodItem currentItem =
          foodItems.singleWhere((foodItem) => id == foodItem.itemId);

      if ((cartItems.singleWhere((item) => item.id == currentItem.itemId,
              orElse: () => null) ==
          null)) {
        cartItems = new List.from(cartItems)
          ..addAll(([
            CartItem(
                currentItem.itemId,
                currentItem.name,
                (currentItem.image == null || currentItem.image == "")
                    ? "assets/notfound3.png"
                    : currentItem.image,
                currentItem.price,
                1,
                currentItem.extras,
                currentItem.isVeg,
                currentItem.categoryId),
          ]));
      } else {
        cartItems = cartItems
            .map((item) => item.id == id
                ? (CartItem(
                    item.id,
                    item.name,
                    (item.image == null || item.image == "")
                        ? "assets/notfound3.png"
                        : item.image,
                    item.price,
                    item.count + 1,
                    item.extras,
                    item.isVeg,
                    item.categoryId))
                : item)
            .toList();
      }
      // cartItems.length == 0
      //     ? 0
      //     : cartItems.map((item) => item.count).reduce(
      //         (a, b) => int.parse(a.toString()) + int.parse(b.toString()));
    });
  }

  _updateFoodItems() {
    setState(() {
      cartItems.forEach((cartItem) => {
            foodItems = foodItems
                .map((foodI) => foodI.itemId == cartItem.id
                    ? (FoodItem(
                        cartItem.id,
                        (cartItem.image == null || cartItem.image == "")
                            ? "assets/notfound3.png"
                            : cartItem.image,
                        cartItem.name,
                        true,
                        cartItem.price,
                        cartItem.isVeg,
                        cartItem.count,
                        cartItem.extras,
                        foodI.description,
                        foodI.categoryId))
                    : foodI)
                .toList()
          });
    });
  }

  _updateCartItems(String id, String action) {
    setState(() {
      FoodItem currentItem =
          foodItems.singleWhere((foodItem) => id == foodItem.itemId);
      if (action == "add") {
        if (cartItems.length == 0 ||
            (cartItems.singleWhere((item) => item.id == currentItem.itemId,
                    orElse: () => null) ==
                null)) {
          cartItems = new List.from(cartItems)
            ..addAll(([
              CartItem(
                  currentItem.itemId,
                  currentItem.name,
                  (currentItem.image == null || currentItem.image == "")
                      ? "assets/notfound3.png"
                      : currentItem.image,
                  currentItem.price,
                  currentItem.count,
                  currentItem.extras,
                  currentItem.isVeg,
                  currentItem.categoryId)
            ]));
        } else {
          cartItems = cartItems
              .map((item) => item.id == id
                  ? (CartItem(
                      item.id,
                      item.name,
                      (item.image == null || item.image == "")
                          ? "assets/notfound3.png"
                          : item.image,
                      item.price,
                      item.count + 1,
                      item.extras,
                      item.isVeg,
                      item.categoryId))
                  : item)
              .toList();
        }
      } else {
        if (currentItem.count == 0) {
          cartItems = cartItems.where((item) => item.id != id).toList();
        } else {
          cartItems = cartItems
              .map((item) => item.id == id
                  ? (CartItem(
                      item.id,
                      item.name,
                      (item.image == null || item.image == "")
                          ? "assets/notfound3.png"
                          : item.image,
                      item.price,
                      item.count - 1,
                      item.extras,
                      item.isVeg,
                      item.categoryId))
                  : item)
              .toList();
        }
      }
    });
  }

  _updateFoodItemsFromCartItem() {
    setState(() {});
  }

  _updateFoodItemByIdAndAction(String id, String action) {
    setState(() {
      CartItem currentItem =
          cartItems.singleWhere((cartItem) => id == cartItem.id);
      if (action == "add") {
        foodItems = foodItems
            .map((item) => item.itemId == id
                ? FoodItem(
                    item.itemId,
                    (item.image == null || item.image == "")
                        ? "assets/notfound3.png"
                        : item.image,
                    item.name,
                    item.isVeg,
                    item.price,
                    true,
                    item.count + 1,
                    item.extras,
                    item.description,
                    item.categoryId)
                : item)
            .toList();
      } else {
        if (currentItem.count == 1) {
          var foodItem =
              foodItems.firstWhere((f) => f.itemId == id, orElse: () => null);
          if (foodItem != null) {
            foodItems[foodItems.indexWhere((item) => item.itemId == id)]
                .count--;
            foodItems[foodItems.indexWhere((item) => item.itemId == id)]
                .isSelected = false;
          }

          cartItems = cartItems.where((item) => item.id != id).toList();
        } else {
          foodItems = foodItems
              .map((item) => item.itemId == id
                  ? FoodItem(
                      item.itemId,
                      (item.image == null || item.image == "")
                          ? "assets/notfound3.png"
                          : item.image,
                      item.name,
                      item.isVeg,
                      item.price,
                      true,
                      item.count - 1,
                      item.extras,
                      item.description,
                      item.categoryId)
                  : item)
              .toList();
        }
      }
    });
  }

  _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    var categories = await _repository.getCategories(Constants.getCategories);
    setState(() {
      categories.forEach((c) {
        foodCategories.add(new ItemCategory(c.categoryId, c.image, c.name));
      });
    });
  }

  __getProductsByCategoryId(String categoryId) async {
    setState(() {
      _isLoading = true;
    });
    List<ItemCategory> items = [];

    String catId = categoryId;
    if (categoryId == null) {
      var categories = await _repository.getCategories(Constants.getCategories);
      categories.forEach((c) {
        items.add(new ItemCategory(c.categoryId, c.image, c.name));
      });
      catId = items.first.categoryId.toString();
    }
    var products = await _repository.getProductsByCategoryId(
        Constants.getProductsByCategoryId, catId);
    setState(() {
      foodItems = new List<FoodItem>();
      products.forEach((f) {
        foodItems.add(new FoodItem(f.itemId, f.image, f.name, true, f.price,
            false, 0, "", f.description, categoryId));
      });
      _updateFoodItems();
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    __getProductsByCategoryId(null);
    //buildItemsInCartButton(context);
  }

  bool itemSelected = false;
  FoodItem itemToPassToInfoScreen;
  int drawerCount = 0;
  int currentIndex = 0;
  String searchString = "";
  PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Drawer(
          child: drawerCount == 1
              ? ItemInfoPage(
                  itemToPassToInfoScreen,
                  updateExtraOnSpecificItem,
                  _updateFoodItems,
                  _updateFoodItemByIdAndAction,
                  _updateCartItemsCounter)
              : SafeArea(
                  child: Stack(
                    children: [
                      ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 8.0),
                                child: Text(
                                  locale.tableNo + ' 6',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              buildItemsInCartButton(context),
                            ],
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 150),
                              itemCount: cartItems.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      leading: GestureDetector(
                                        onTap: () {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) => ItemInfoPage(
                                          //               foodItems[
                                          //                   foodItems.indexWhere(
                                          //                       (foodItem) =>
                                          //                           foodItem
                                          //                               .itemId ==
                                          //                           cartItems[
                                          //                                   index]
                                          //                               .id)],
                                          //               updateExtraOnSpecificItem,
                                          //               _updateFoodItems,
                                          //               _updateFoodItemByIdAndAction,
                                          //               _updateCartItemsCounter)));
                                          //
                                        },
                                        child: FadedScaleAnimation(
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: FadedScaleAnimation(
                                                (cartItems[index].image ==
                                                            null ||
                                                        cartItems[index]
                                                                .image ==
                                                            "http://al-kron.com/public/upload/items-images/")
                                                    ? Image.asset(
                                                        "assets/notfound3.png",
                                                        height: 40,
                                                        width: 50,
                                                      )
                                                    : Image.network(
                                                        cartItems[index].image,
                                                        height: 40,
                                                        width: 50,
                                                      ),
                                                durationInMilliseconds: 400,
                                              )),
                                          durationInMilliseconds: 400,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FadedScaleAnimation(
                                              Image.asset(
                                                cartItems[index].isVeg
                                                    ? 'assets/ic_veg.png'
                                                    : 'assets/ic_nonveg.png',
                                                height: 12,
                                              ),
                                              durationInMilliseconds: 400,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              cartItems[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6, horizontal: 6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: newOrderColor,
                                                        width: 0.2)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          bool found = false;
                                                          if (cartItems[index]
                                                                  .count ==
                                                              1) {
                                                            found = true;
                                                          }
                                                          setState(() {
                                                            _updateFoodItemByIdAndAction(
                                                                cartItems[index]
                                                                    .id,
                                                                "remove");
                                                            if (!found) {
                                                              cartItems[index]
                                                                  .count--;
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          color: newOrderColor,
                                                          size: 40,
                                                        )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      cartItems[index]
                                                          .count
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                              fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _updateFoodItemByIdAndAction(
                                                                cartItems[index]
                                                                    .id,
                                                                "add");
                                                            cartItems[index]
                                                                .count++;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: newOrderColor,
                                                          size: 40,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '\ALL ' +
                                                    cartItems[index].price,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // index == 0
                                          //     ? Row(
                                          //         children: [
                                          //           Text(
                                          //             "Extra Cheese",
                                          //             style: Theme.of(context)
                                          //                 .textTheme
                                          //                 .subtitle1
                                          //                 .copyWith(
                                          //                     fontSize: 14),
                                          //           ),
                                          //           Spacer(),
                                          //           Text(
                                          //               '\$' +
                                          //                   cartItems[index]
                                          //                       .price,
                                          //               style: TextStyle(
                                          //                   color:
                                          //                       Colors.black))
                                          //         ],
                                          //       )
                                          //     :
                                          SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 200,),
                                  ],
                                );
                              })
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              tileColor: Theme.of(context).backgroundColor,
                              title: Text(locale.totalAmount,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 14)),
                              trailing: Text(
                                '\ALL ' +
                                    '${cartItems.length == 0 ? "" : cartItems.map((item) => item.count * double.parse(item.price)).reduce((a, b) => a + b)}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            // TextFormField(
                            //   onChanged: (text) {
                            //     //widget.updateExtra(text);
                            //   },
                            //   initialValue: "",
                            //   decoration:
                            //       InputDecoration(labelText: 'Enter notes'),
                            // ),
                            CustomButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => PlaceOrderDialog(
                                          title: "Termina l'ordine",
                                          description: "Note sull'ordine",
                                          items: cartItems,
                                          totalPrice:
                                              '${cartItems.length == 0 ? "" : cartItems.map((item) => item.count * double.parse(item.price)).reduce((a, b) => a + b)}',
                                          tableId: this.widget.tableId,
                                          tableName: this.widget.tableName,
                                          prefs: _prefs,
                                          tableStatus: this.widget.tableStatus,
                                        ));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => OrderPlaced()));
                                // Navigator.pop(context);
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       _buildAboutDialog(context),
                                // );
                              },
                              // margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              bgColor: Theme.of(context).primaryColor,
                              title: Text(
                                this.widget.tableStatus == "In Uso"
                                    ? locale.mergeOrdering
                                    : locale.finishOrdering,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 16),
                              ),
                              borderRadius: 0,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FadedScaleAnimation(
          RichText(
              text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(letterSpacing: 1, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                TextSpan(
                  text: 'Chef ',
                ),
                TextSpan(
                    text: 'Go',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ])),
          durationInMilliseconds: 400,
        ),
        actions: [
          Container(
              width: 200,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: locale.searchItem,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40))),
                onChanged: (text) {
                  setState(() {
                    searchString = text;
                  });

                  // foodItems.where((f) => f.name.contains(text)).toList();
                },
              )),
          buildItemsInCartButton(context)
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            Container(
              width: 110,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: foodCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                          __getProductsByCategoryId(
                              foodCategories[currentIndex].categoryId);
                        });
                      },
                      child: Container(
                        height: 87,
                        // width: 60,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: currentIndex == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Spacer(),
                            FadedScaleAnimation(
                              (foodCategories[index].image == null ||
                                      foodCategories[index].image ==
                                          "http://al-kron.com/public/upload/categories/")
                                  ? Image.asset(
                                      "assets/notfound3.png",
                                      scale: 3.5,
                                    )
                                  : Image.network(
                                      foodCategories[index].image,
                                      scale: 3.5,
                                    ),
                              durationInMilliseconds: 400,
                            ),
                            Spacer(),
                            Text(
                              foodCategories[index].name.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  _isLoading
                      ? SpinKitThreeBounce(
                          color: Theme.of(context).primaryColor,
                          size: 20.0,
                        )
                      : buildPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomButton buildItemsInCartButton(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return CustomButton(
      onTap: () {
        setState(() {
          drawerCount = 0;
        });
        if (itemSelected) {
          _scaffoldKey.currentState.openEndDrawer();
        }
      },
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      title: Text(
        locale.itemsInCart +
            '   (${cartItems.length == 0 ? 0 : cartItems.map((item) => item.count).reduce((a, b) => int.parse(a.toString()) + int.parse(b.toString()))})',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      bgColor: itemSelected ? buttonColor : Colors.grey[600],
    );
  }

  _indexOfCurrentFoodItem(index, filteredFoodItems) {
    return foodItems.indexWhere(
        (foodItem) => foodItem.itemId == filteredFoodItems[index].itemId);
  }

  Widget buildPage() {
    List<FoodItem> filteredFoodItems = foodItems
        .where((foodItem) => foodItem.name.toLowerCase().contains(searchString))
        .toList();

    return GridView.builder(
        physics: BouncingScrollPhysics(),
        padding:
            EdgeInsetsDirectional.only(top: 16, bottom: 16, start: 16, end: 32),
        itemCount: filteredFoodItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 22,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        foodItems[_indexOfCurrentFoodItem(
                                index, filteredFoodItems)]
                            .isSelected = !foodItems[_indexOfCurrentFoodItem(
                                index, filteredFoodItems)]
                            .isSelected;
                        itemSelected = true;
                      });
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context)=>ItemInfoPage(foodItems[index].image,foodItems[index].name)));
                    },
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                image: DecorationImage(
                                    image: (filteredFoodItems[index].image ==
                                                null ||
                                            filteredFoodItems[index].image ==
                                                "http://al-kron.com/public/upload/items-images/")
                                        ? AssetImage("assets/notfound3.png")
                                        : NetworkImage(
                                            filteredFoodItems[index].image),
                                    fit: BoxFit.fill)),
                          ),
                          durationInMilliseconds: 400,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: FadedScaleAnimation(
                            Container(
                              height: 20,
                              width: 30,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey.shade400,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      itemToPassToInfoScreen = foodItems[
                                          _indexOfCurrentFoodItem(
                                              index, filteredFoodItems)];
                                      drawerCount = 1;
                                    });
                                    _scaffoldKey.currentState.openEndDrawer();
                                  }),
                            ),
                            durationInMilliseconds: 400,
                          ),
                        ),
                        foodItems[_indexOfCurrentFoodItem(
                                    index, filteredFoodItems)]
                                .isSelected
                            ? Opacity(
                                opacity: 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          transparentColor,
                                        ],
                                        stops: [
                                          0.2,
                                          0.75,
                                        ]),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        foodItems[_indexOfCurrentFoodItem(
                                    index, filteredFoodItems)]
                                .isSelected
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (foodItems[
                                                          _indexOfCurrentFoodItem(
                                                              index,
                                                              filteredFoodItems)]
                                                      .count >=
                                                  1)
                                                setState(() {
                                                  foodItems[
                                                          _indexOfCurrentFoodItem(
                                                              index,
                                                              filteredFoodItems)]
                                                      .count--;
                                                });
                                              _updateCartItems(
                                                  foodItems[
                                                          _indexOfCurrentFoodItem(
                                                              index,
                                                              filteredFoodItems)]
                                                      .itemId,
                                                  "remove");
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: buttonColor,
                                          child: Text(
                                            filteredFoodItems[index]
                                                .count
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                foodItems[
                                                        _indexOfCurrentFoodItem(
                                                            index,
                                                            filteredFoodItems)]
                                                    .count++;
                                              });
                                              _updateCartItems(
                                                  foodItems[
                                                          _indexOfCurrentFoodItem(
                                                              index,
                                                              filteredFoodItems)]
                                                      .itemId,
                                                  "add");
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 40,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    filteredFoodItems[index].name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      FadedScaleAnimation(
                        Image.asset(
                          filteredFoodItems[index].isVeg
                              ? 'assets/ic_veg.png'
                              : 'assets/ic_nonveg.png',
                          scale: 2.5,
                        ),
                        durationInMilliseconds: 400,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('\ALL ' + filteredFoodItems[index].price),
                    ],
                  ),
                ),
                Spacer(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //         vertical: 6, horizontal: 6),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         border: Border.all(
                //             color: newOrderColor, width: 0.2)),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         GestureDetector(
                //             onTap: () {
                //               if (foodItems[index].count >= 1)
                //                 setState(() {
                //                   foodItems[index].count--;
                //                 });
                //             },
                //             child: Icon(
                //               Icons.remove,
                //               color: newOrderColor,
                //               size: 16,
                //             )),
                //         SizedBox(
                //           width: 8,
                //         ),
                //         Text(
                //           foodItems[index].count.toString(),
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle1
                //               .copyWith(fontSize: 12),
                //         ),
                //         SizedBox(
                //           width: 8,
                //         ),
                //         GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 foodItems[index].count++;
                //               });
                //             },
                //             child: Icon(
                //               Icons.add,
                //               color: newOrderColor,
                //               size: 16,
                //             )),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        });
  }
}

class PlaceOrderDialog extends StatefulWidget {
  final String title,
      description,
      buttonText,
      totalPrice,
      tableId,
      tableName,
      tableStatus;
  final Image image;
  final List<CartItem> items;
  final SharedPreferences prefs;
  PlaceOrderDialog(
      {Key key,
      this.title,
      this.description,
      this.buttonText,
      this.image,
      this.items,
      this.tableId,
      this.tableName,
      this.totalPrice,
      this.prefs,
      this.tableStatus})
      : super(key: key);
  @override
  _PlaceOrderDialog createState() => _PlaceOrderDialog();
}

class _PlaceOrderDialog extends State<PlaceOrderDialog> {
  Repository _repository = new Repository();
  bool _isLoading = false;
  TextEditingController _notesController = new TextEditingController();

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  inputField(controllerName, obscureText, hint) {
    return TextFormField(
      controller: controllerName,
      obscureText: obscureText,
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        Container(
          width: 400,
          height: 230,
          padding: EdgeInsets.only(top: 10, bottom: 16, left: 2, right: 2),
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.save,
                color: Colors.green[500],
                size: 40.0,
              ),
              Text(
                this.widget.title,
                style: TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.w700, height: 1),
              ),
              SizedBox(height: 10.0),
              Text(this.widget.description, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 10.0),
              inputField(_notesController, false, "Note sull'ordine"),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    //Navigator.pop(context);

                    this.widget.tableStatus == "In Uso"
                        ? mergeOrder(
                            context,
                            Constants.getItemDetail,
                            Constants.getOrderIdByTableId,
                            Constants.mergeOrder,
                            this.widget.items,
                            _notesController.text,
                            this.widget.totalPrice,
                            this.widget.tableId,
                            this.widget.prefs)
                        : proceedOrder(
                            context,
                            Constants.getItemDetail,
                            Constants.placeOrder,
                            this.widget.items,
                            _notesController.text,
                            this.widget.totalPrice,
                            this.widget.tableName,
                            this.widget.tableId,
                            this.widget.prefs);
                  },
                  child: Container(
                    child: _isLoading == true
                        ? SpinKitThreeBounce(
                            color: Colors.white,
                            size: 20.0,
                          )
                        : Text("Ok",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              height: 1,
                              fontSize: 16.0,
                            )),
                    alignment: Alignment.center,
                    width: 120,
                    padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                  ),
                ),
              ),
            ],
          ),
        ),
        // getText() == null ? Text("") : getText()
      ],
    ));
  }

  Future<String> proceedOrder(
      BuildContext context,
      String api,
      String postApi,
      List<CartItem> cartItems,
      String notes,
      String totalPrice,
      String tableName,
      String tableId,
      SharedPreferences _pref) async {
    try {
      setState(() {
        _isLoading = true;
      });
      _pref = await SharedPreferences.getInstance();
      List<OrderItem> orderItems = [];
      Shipping shipping =
          new Shipping("", "", "", "", "", "", "", "", "", "", "", 0, "", "");
      for (int i = 0; i < cartItems.length; i++) {
        http.Response response = await http.get(
            '${Constants.url}/$api/${cartItems[i].id}',
            headers: {"x-api-key": Constants.x_api_key});
        var result = json.decode(response.body);
        Original original = Original.fromJson(result[0]);
        original.restaurant_food_note = "";
        original.restaurant_food_status = "not_ready";
        original.discount_type = "percentage";
        original.discount_amount = "0";
        original.qte_added = cartItems[i].count.toString();
        original.promo_enabled = "true";
        OrderItem orderItem = new OrderItem();
        orderItem = convertToOrderModel(original, cartItems[i]);
        orderItems.insert(i, orderItem);
      }
      Order order = new Order();
      order.shipping = shipping;
      order.date_creation = DateTime.now().toString();
      order.remise_type = "";
      order.total = totalPrice.toString();
      order.net_total = totalPrice;
      order.remise_percent = "0";
      order.remise = "0";
      order.rebais = "0";
      order.ristourne = "0";
      order.iva = "0";
      order.ref_tax = "0";
      var userId = _pref.getString("userId");
      order.ref_client = "1";
      order.payment_type = null;
      order.group_discount = "0";
      order.discount_type = "disable";
      order.hmb_discount = "";
      order.register_id = "default";

      order.editable_orders = ["nexo_order_devis"];
      order.description = notes;
      order.titre = "Vip Zone > " + tableName;
      order.metas = new OrderMeta(table_id: tableId, seat_used: "2");
      order.somme_percu = "0";

      order.payments = [];
      order.restaurant_order_type = "dinein";
      order.restaurant_order_status = "pending";
      order.items = orderItems;

      var data = order.toJson();
      var jsonModel = jsonEncode(data);
      log(jsonModel);
      print('${Constants.url}/$postApi/' + userId);
      http.Response response = await http.post(
          '${Constants.url}/$postApi/' + userId,
          body: jsonModel,
          headers: {
            "x-api-key": Constants.x_api_key,
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        //var result = json.decode(response.body);
        print("Ordered");
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrderPlaced()))
            .then((value) {
          _pushToTableSelectionPage();
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => CustomDialog(
                title: "Errore",
                description:
                    "Qualcosa è andato storto. Si prega di contattare l'amministratore!"));
        setState(() {
          _isLoading = false;
        });

        // return restaurantDetails;
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
              title: "Errore",
              description:
                  "Qualcosa è andato storto. Si prega di contattare l'amministratore!"));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> mergeOrder(
      BuildContext context,
      String api,
      String getOrderIdApi,
      String postApi,
      List<CartItem> cartItems,
      String notes,
      String totalPrice,
      String tableId,
      SharedPreferences _pref) async {
    try {
      setState(() {
        _isLoading = true;
      });
      _pref = await SharedPreferences.getInstance();
      List<OrderItem> orderItems = [];

      for (int i = 0; i < cartItems.length; i++) {
        http.Response response = await http.get(
            '${Constants.url}/$api/${cartItems[i].id}',
            headers: {"x-api-key": Constants.x_api_key});
        var result = json.decode(response.body);
        Original original = Original.fromJson(result[0]);
        original.restaurant_food_note = notes;
        original.restaurant_food_status = "not_ready";
        original.discount_type = "percentage";
        original.discount_amount = "0";
        original.qte_added = cartItems[i].count.toString();
        original.promo_enabled = "true";
        OrderItem orderItem = new OrderItem();
        orderItem = convertToOrderModel(original, cartItems[i]);
        orderItems.insert(i, orderItem);
      }

      var userId = _pref.getString("userId");
      http.Response getOrderIdResponse = await http.get(
          '${Constants.url}/$getOrderIdApi/$tableId',
          headers: {"x-api-key": Constants.x_api_key});
      var orderId = json.decode(getOrderIdResponse.body);
      print(orderId.toString());
      MergeOrderModel mergeOrderModel = new MergeOrderModel();
      mergeOrderModel.items = orderItems;
      var jsonModel = jsonEncode(mergeOrderModel);
      log(jsonModel);
      print('${Constants.url}/$postApi/' + orderId.toString());
      http.Response response = await http.post(
          '${Constants.url}/$postApi/' + orderId.toString(),
          body: jsonModel,
          headers: {
            "x-api-key": Constants.x_api_key,
            'Content-type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrderPlaced()))
            .then((value) {
          _pushToTableSelectionPage();
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => CustomDialog(
                title: "Errore",
                description:
                    "Qualcosa è andato storto. Si prega di contattare l'amministratore"));

        setState(() {
          _isLoading = false;
        });
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
              title: "Errore",
              description:
                  "Qualcosa è andato storto. Si prega di contattare l'amministratore"));
      setState(() {
        _isLoading = false;
      });
    }
  }

  _pushToTableSelectionPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TableSelectionPage()));
  }

  convertToOrderModel(Original original, CartItem item) {
    OrderItem orderItem = new OrderItem(
        id: original.id == null ? 0 : int.parse(original.id),
        design: original.design,
        alternative_name: original.alternative_name,
        ref_rayon: original.ref_rayon,
        ref_shipping: original.ref_shipping,
        ref_categorie: original.ref_categorie,
        restaurant_food_printed: original.restaurant_food_printed,
        product_skip_cooking: original.product_skip_cooking,
        ref_provider: original.ref_provider,
        ref_taxe: original.ref_taxe,
        order: "0",
        tax_type: "exclusive",
        quantity: original.quantity,
        sku: original.sku,
        quantite_restante: original.quantite_restante,
        hold_quantity: original.hold_quantity,
        quantite_vendu: original.quantite_vendu,
        defectueux: original.defectueux,
        prix_dachat: original.prix_dachat,
        frais_accessoire: original.frais_accessoire,
        count_dachat: original.count_dachat,
        taux_de_marge: original.taux_de_marge,
        prix_de_vente: original.prix_de_vente,
        prix_de_vente_ttc: original.prix_de_vente_ttc,
        prix_de_vente_brut: original.prix_de_vente_brut,
        shadow_price: original.shadow_price,
        taille: original.taille,
        poids: original.poids,
        couleur: original.couleur,
        hauteur: original.hauteur,
        largeur: original.largeur,
        prix_promotionel: original.prix_promotionel,
        special_price_start_date: original.special_prix_start_date,
        special_price_end_date: original.special_prix_end_date,
        description: original.description,
        apercu: original.apercu,
        codebar: original.codebar,
        date_creation: original.date_creation,
        date_mod: original.date_mod,
        author: original.author,
        override_stock: original.override_stock,
        ref_recipe: original.ref_recipe,
        type: original.type,
        status: original.status,
        stock_enabled: original.stock_enabled,
        stock_alert: original.stock_alert,
        alert_quantity: original.alert_quantity,
        expiration_date: original.expiration_date,
        on_expire_action: original.on_expire_action,
        auto_barcode: original.auto_barcode,
        barcode_type: original.barcode_type,
        ref_modifiers_group: original.ref_modifiers_group,
        use_variation: original.use_variation,
        restaurant_food_note: original.restaurant_food_note,
        restaurant_food_Printed: original.restaurant_food_printed,
        restaurant_food_status: original.restaurant_food_status,
        discount_type: original.discount_type,
        discount_amount:
            (original.discount_amount == null || original.discount_amount == "")
                ? 0
                : int.parse(original.discount_amount),
        discount_percent: (original.discount_percent == null ||
                original.discount_percent == "")
            ? 0
            : int.parse(original.discount_percent),
        qte_added: item.count,
        promo_enabled: original.promo_enabled,
        iD: original.id == null ? "" : original.id,
        qte_Added: item.count,
        codeBar: original.codebar,
        stock_Enabled: original.stock_enabled,
        discount_Type: original.discount_type,
        discount_Percent: (original.discount_percent == null ||
                original.discount_percent == "")
            ? 0
            : int.parse(original.discount_percent),
        discount_Amount:
            (original.discount_amount == null || original.discount_amount == "")
                ? 0
                : int.parse(original.discount_amount),
        categoryId: original.ref_categorie,
        qte_remaining: "0",
        qte_sold: item.price,
        salePrice: item.price,
        metas: {},
        name: item.name,
        alternativename: item.name,
        inline: false,
        tax: item.price == null ? 0.2 : (double.parse(item.price) * 0.2),
        total_tax: item.price == null ? 0 : (double.parse(item.price) * 0.2),
        restaurant_food_issue: "",
        restaurant_food_modifiers: {},
        original: original);
    return orderItem;
  }

  Future<Original> getOriginal(String api, String id) async {
    http.Response response = await http.get('${Constants.url}/$api/$id',
        headers: {"x-api-key": Constants.x_api_key});
    var result = json.decode(response.body);
    Original original = Original.fromJson(result[0]);
    return original;
  }
}
