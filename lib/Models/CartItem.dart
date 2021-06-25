class CartItem {
  String id;
  String name;
  String image;
  String price;
  int count;
  String extras;
  bool isVeg;
  String categoryId;
  CartItem(this.id, this.name, this.image, this.price, this.count, this.extras,
      this.isVeg, this.categoryId);

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    count = json['count'];
    isVeg = json['isVeg'];
    extras = json['extras'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['count'] = this.count;
    data['isVeg'] = this.isVeg;
    data['extras'] = this.extras;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
