class ItemSizeModel {

  String name;
  double price;
  int stock;

  ItemSizeModel({
    required this.name,
    required this.price,
    required this.stock
  });

  factory ItemSizeModel.fromMap(Map<String, dynamic> map){
    return ItemSizeModel(
        name: map['name'] as String,
        price: map['price'] as double,
        stock: map['stock'] as int
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  ItemSizeModel clone(){
    return ItemSizeModel(
      name: name,
      price: price,
      stock: stock);
  }

  bool get hashStock => stock > 0;

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}