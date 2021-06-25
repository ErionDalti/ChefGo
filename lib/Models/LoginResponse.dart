class LoginResponseModel {
  String msg;
  String code;
  Data data;

  LoginResponseModel(this.msg, this.code, this.data);

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    data = json['data'] == "" ? new Data(null) : Data.fromJson(json['data']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}

class Data {
  String id;

  Data(this.id);
  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
