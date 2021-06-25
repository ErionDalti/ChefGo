import 'dart:convert';

import 'package:RestaurantAppMobile/Repository/Repository.dart';
//import 'package:m_ticket_app/models/user.dart';

class AuthService {
  Repository _repository;

  AuthService() {
    _repository = Repository();
  }

  Future<dynamic> signIn(String api, String username, String password) async {
    var data = {'username': username, 'password': password};
    var _result = await _repository.httpPost(api, data);
    var result = json.decode(_result.body);
    print(json.encode(result));
    return result;
  }

  signOut(String userId) async {
    var data = {'email': userId};
    return await _repository.httpPost('logout', data);
  }
}
