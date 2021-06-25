class Shipping {
  String name;
  String enterprise;
  String address_1;
  double price;
  String city;
  String country;
  String pobox;
  String title;
  String state;
  String surname;
  String email;
  String phone;
  String address_2;
  String id;

  Shipping(
    this.id,
    this.title,
    this.address_1,
    this.address_2,
    this.city,
    this.country,
    this.email,
    this.enterprise,
    this.name,
    this.phone,
    this.pobox,
    this.price,
    this.state,
    this.surname,
  );

  Shipping.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    enterprise = json['enterprise'];
    address_1 = json['address_1'];
    price = json['price'];
    city = json['city'];
    country = json['country'];
    pobox = json['pobox'];
    title = json['title'];
    state = json['state'];
    surname = json['surname'];
    email = json['email'];
    phone = json['phone'];
    address_2 = json['address_2'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = name;
    json['enterprise'] = enterprise;
    json['address_1'] = address_1;
    json['price'] = price;
    json['city'] = city;
    json['country'] = country;
    json['pobox'] = pobox;
    json['title'] = title;
    json['state'] = state;
    json['surname'] = surname;
    json['email'] = email;
    json['phone'] = phone;
    json['address_2'] = address_2;
    json['id'] = id;
    return json;
  }
}
