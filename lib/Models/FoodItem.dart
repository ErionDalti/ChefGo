class FoodItem {
  String itemId;
  String image;
  String name;
  bool isVeg;
  String price;
  bool isSelected;
  String extras;
  String description;
  String categoryId;
  int count = 0;
  FoodItem(
      this.itemId,
      this.image,
      this.name,
      this.isVeg,
      this.price,
      this.isSelected,
      this.count,
      this.extras,
      this.description,
      this.categoryId);

  FoodItem.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    count = json['count'];
    isSelected = json['isSelected'];
    extras = json['extras'];
    isVeg = json['isVeg'];
    description = json['Description'];
    categoryId = json['categoryId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['count'] = this.count;
    data['isVeg'] = this.isVeg;
    data['isSelected'] = this.isSelected;
    data['extras'] = this.extras;
    data['Description'] = this.description;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
