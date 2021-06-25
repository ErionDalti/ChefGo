import 'dart:convert';

import 'package:RestaurantAppMobile/Pages/home_page.dart';
import 'package:RestaurantAppMobile/Repository/Repository.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RestaurantAppMobile/Locale/locales.dart';
import 'package:RestaurantAppMobile/Models/TableDetail.dart';
import 'package:RestaurantAppMobile/Pages/login.dart';
import 'package:RestaurantAppMobile/Theme/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:RestaurantAppMobile/Models/constants.dart' as Constants;

class TableSelectionPage extends StatefulWidget {
  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

// class TableDetail {
//   Color color;
//   String time;
//   String items;

//   TableDetail(this.color, this.time, this.items);
// }
class _TableSelectionPageState extends State<TableSelectionPage> {
  List<TableDetailNew> ordersList = new List<TableDetailNew>();
  Repository _repository = new Repository();
  SharedPreferences _prefs;
  bool _isLoading = false;
  String userName = "";
  _updatePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {
        userName = _prefs.getString("userName");
      });
    }
  }

  _logout() {
    if (_prefs != null) {
      _prefs.clear();
      _pushToLogin();
    }
  }

  _pushToLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginUI()));
  }

  _clearTables() {
    ordersList = new List<TableDetailNew>();
  }

  _getTables() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences _pref;
    _pref = await SharedPreferences.getInstance();
    var userId = _pref.getString("userId");
    var tablesNew = await _repository.getTables(Constants.getTables, userId);
    if (mounted) {
      setState(() {
        tablesNew.forEach((v) {
          if (v.status == "Disponibile") {
            ordersList.add(new TableDetailNew(
                v.tableId,
                Theme.of(context).scaffoldBackgroundColor,
                v.time,
                v.current_seats_used,
                v.max_seats,
                v.status,
                v.tableName));
          } else if (v.status == "In Uso") {
            ordersList.add(new TableDetailNew(v.tableId, newOrderColor, v.time,
                v.current_seats_used, v.max_seats, v.status, v.tableName));
          } else if (v.status == "Riservato") {
            ordersList.add(new TableDetailNew(
                v.tableId,
                Theme.of(context).primaryColor,
                v.time,
                v.current_seats_used,
                v.max_seats,
                v.status,
                v.tableName));
          } else if (v.status == "Fuori Servizio") {
            ordersList.add(new TableDetailNew(
                v.tableId,
                Colors.red[500],
                v.time,
                v.current_seats_used,
                v.max_seats,
                v.status,
                v.tableName));
          }
        });
      });
      setState(() {
        _isLoading = false;
      });
      print(json.encode(ordersList));
    }
  }

  _getStringDateTime(String date) {
    DateTime newDate = DateTime.parse(date);
    String formattedDate = DateFormat('kk:mm').format(newDate);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    _updatePrefs();
    _getTables();
    //print(json.encode(tables));
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    print(json.encode(locale.energy));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
            onDoubleTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginUI()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadedScaleAnimation(
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Chef ',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            letterSpacing: 1, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Go',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold)),
                  ])),
                  durationInMilliseconds: 400,
                ),
                Row(
                  children: [
                    FadedScaleAnimation(
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: 'Benvenuto ',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: '$userName      ',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold)),
                      ])),
                      durationInMilliseconds: 400,
                    ),
                    ElevatedButton(
                        child:
                            Text("Esci", style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ))),
                        onPressed: () => _logout())
                  ],
                )
              ],
            )),
        actions: [],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: _isLoading == true
            ? SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 20.0,
              )
            : GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                itemCount: ordersList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => ordersList[index].status == "Unavailable"
                        ? showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                                title: "Fuori servizio",
                                description:
                                    "Non puoi effetuare ordini per questo tavolo!"))
                        : Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (ctx) => HomePage(
                                      tableId: ordersList[index].tableId,
                                      tableStatus: ordersList[index].status,
                                      tableName: ordersList[index].tableName,
                                    )))
                            .then((context) {
                            _clearTables();
                            _getTables();
                          }),
                    child: FadedScaleAnimation(
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        height: 80,
                        decoration: BoxDecoration(
                            color: ordersList[index].color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  ordersList[index].tableName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: ordersList[index].color ==
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor
                                              ? blackColor
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                          fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  _getStringDateTime(ordersList[index].time),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontSize: 12,
                                          color: ordersList[index].color ==
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor
                                              ? blackColor
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                )
                              ],
                            ),
                            Spacer(),
                            // ListTile(
                            //   onTap: (){},
                            //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            //   title: Text('Table 1'), trailing: Text('1:33'),),
                            Text(
                              ordersList[index].current_seats_used == null
                                  ? '0 / ${ordersList[index].max_seats}'
                                  : '${ordersList[index].current_seats_used} / ${ordersList[index].max_seats}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontSize: 11,
                                      color: ordersList[index].color ==
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor
                                          ? Color(0xff777777)
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor),
                            ),
                            Text(
                              'Status :  ${ordersList[index].status}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      fontSize: 11,
                                      color: ordersList[index].color ==
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor
                                          ? Color(0xff777777)
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor),
                            )
                          ],
                        ),
                      ),
                      durationInMilliseconds: 200,
                    ),
                  );
                }),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
