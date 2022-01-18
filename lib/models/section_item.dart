class SectionItem{

   String image;
   String product;

   SectionItem({
     required this.image,
     required this.product,
   });


   factory SectionItem.fromMap(Map<String, dynamic> map){
     return SectionItem(
         image:  map['image'] as String,
         product: map['product'] as String,
     );
   }

   SectionItem clone(){
     return SectionItem(
       image: image,
       product: product
     );
   }

   @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}