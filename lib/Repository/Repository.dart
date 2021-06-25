import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:RestaurantAppMobile/Models/CartItem.dart';
import 'package:RestaurantAppMobile/Models/FoodItem.dart';
import 'package:RestaurantAppMobile/Models/ItemCategory.dart';
import 'package:RestaurantAppMobile/Models/Order.dart';
import 'package:RestaurantAppMobile/Models/OrderItem.dart';
import 'package:RestaurantAppMobile/Models/OrderMeta.dart';
import 'package:RestaurantAppMobile/Models/Original.dart';
import 'package:RestaurantAppMobile/Models/Shipping.dart';
import 'package:RestaurantAppMobile/Models/TableDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:RestaurantAppMobile/Models/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  // DatabaseConnection _connection;

  String url = 'http://al-kron.com/api/gastro';
  // ignore: non_constant_identifier_names
  String x_api_key = "jwSEb7jiCKwetzHtPfIH5ePeVI2Kh1IL7YafzbDh";

  Repository() {
    // _connection = new DatabaseConnection();
  }

  //static Database _db;

  // Future<Database> get db async {
  //   if (_db != null) return _db;

  //   _db = await _connection.setDb();
  //   return _db;
  // }

  Future<dynamic> getTables(String api, String userId) async {
    try {
      List<TableDetailNew> tables = new List<TableDetailNew>();
      //print('$url/$api');
      http.Response response = await http
          .get('$url/$api/$userId', headers: {"x-api-key": x_api_key});
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        result.forEach((v) {
          print(v);
          tables.add(new TableDetailNew.fromJson(v));
        });
        print(json.encode(tables));

        return tables;
      } else {
        throw Exception("Fetch to failed restaurant details");
        // return restaurantDetails;
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  getItemDetail(String api, String itemId) async {
    try {
      Original original = new Original();
      //print('$url/$api');
      print('$url/$api/$itemId');
      http.Response response = await http
          .get('$url/$api/$itemId', headers: {"x-api-key": x_api_key});
      print(response.statusCode);
      if (response.statusCode == 200) {
        //var result = json.decode();
        //tables = Original.fromJson(result[0]);
        // print(json.encode(tables));

        return response.body;
      } else {
        throw Exception("Fetch to failed restaurant details");
        // return restaurantDetails;
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<dynamic> getCategories(String api) async {
    try {
      List<ItemCategory> categories = new List<ItemCategory>();
      //print('$url/$api');
      http.Response response =
          await http.get('$url/$api', headers: {"x-api-key": x_api_key});
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        result.forEach((v) {
          //print(v);
          categories.add(new ItemCategory.fromJson(v));
        });
        print(json.encode(categories));

        return categories;
      } else {
        throw Exception("Fetch to failed restaurant details");
        // return restaurantDetails;
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<dynamic> getProductsByCategoryId(String api, String categoryId) async {
    try {
      List<FoodItem> products = new List<FoodItem>();
      //print('$url/$api');
      http.Response response = await http
          .get('$url/$api/' + categoryId, headers: {"x-api-key": x_api_key});
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        result.forEach((v) {
          products.add(new FoodItem.fromJson(v));
        });
        print(json.encode(products));

        return products;
      } else {
        throw Exception("Fetch to failed restaurant details");
        // return restaurantDetails;
      }
    } catch (exception) {
      print(exception.toString());
    }
  }

  httpPost(String api, data) async {
    try {
      print(this.url + '/' + api);
      return await http.post(this.url + '/' + api,
          body: data, headers: {"x-api-key": x_api_key});
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<String> proceedOrder(
      String api,
      String postApi,
      List<CartItem> cartItems,
      String notes,
      String totalPrice,
      String tableName,
      String tableId,
      SharedPreferences _pref) async {
    try {
      // List<FoodItem> products = new List<FoodItem>();
      //print('$url/$api');
      _pref = await SharedPreferences.getInstance();
      print(json.encode(cartItems));
      List<OrderItem> orderItems = [];
      Shipping shipping =
          new Shipping("", "", "", "", "", "", "", "", "", "", "", 0, "", "");
      print("test");
      print(cartItems.length);
      for (int i = 0; i < cartItems.length; i++) {
        http.Response response = await http.get('$url/$api/${cartItems[i].id}',
            headers: {"x-api-key": x_api_key});
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
      // cartItems.forEach((v) async {
      //   // Original originalModel = new Original();
      //   // getOriginal(api, v.id).then((Original original) {
      //   //   originalModel = original;
      //   // });
      //   // print(json.encode(originalModel));
      //   http.Response response = await http
      //       .get('$url/$api/${v.id}', headers: {"x-api-key": x_api_key});
      //   var result = json.decode(response.body);
      //   Original original = Original.fromJson(result[0]);
      //   original.restaurant_food_note = notes;
      //   original.restaurant_food_status = "not_ready";
      //   original.discount_type = "percentage";
      //   original.discount_amount = "0";
      //   original.qte_added = v.count.toString();
      //   original.promo_enabled = "true";
      //   OrderItem orderItem = new OrderItem();
      //   orderItem = convertToOrderModel(original, v);
      //   orderItems.add(orderItem);
      //   //print(json.encode(original));
      // });
      if (orderItems.length == 0)
        print("s ka elemente");
      else
        print("ka elemente");
      print(json.encode(orderItems));
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

      //print(json.encode(order));
      var data = order.toJson();
      //print(data);
      var jsonModel = jsonEncode(data);
      print("modeli u krijua");
      print(jsonModel);
      print('$url/$postApi/' + userId);
      //print(data);
      http.Response response =
          await http.post('$url/$postApi/' + userId, body: jsonModel, headers: {
        "x-api-key": x_api_key,
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });
      log(jsonModel);
      print(response.statusCode);
      if (response.statusCode == 200) {
        //var result = json.decode(response.body);
        print(response.body.toString());
        print("orderi u be");
        //print(json.encode(result));

        return "success";
      } else {
        throw Exception("Fetch to failed restaurant details");
        // return restaurantDetails;
      }
    } catch (exception) {
      print(exception.toString());
    }
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
        qte_added: (original.qte_added == null || original.qte_added == "")
            ? 0
            : int.parse(original.qte_added),
        promo_enabled: original.promo_enabled,
        iD: original.id == null ? "" : original.id,
        qte_Added: (original.qte_added == null || original.qte_added == "")
            ? 0
            : int.parse(original.qte_added),
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
    http.Response response =
        await http.get('$url/$api/$id', headers: {"x-api-key": x_api_key});
    var result = json.decode(response.body);
    Original original = Original.fromJson(result[0]);
    return original;
  }
}
