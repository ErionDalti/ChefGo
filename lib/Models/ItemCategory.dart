class ItemCategory {
  String categoryId;
  String image;
  String name;

  ItemCategory(this.categoryId, this.image, this.name);

  ItemCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    image = json['image'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
