class SectionItem{

   dynamic image;
   String uidProduct;

   SectionItem({
     required this.image,
     required this.uidProduct,
   });


   factory SectionItem.fromMap(Map<String, dynamic> map){
     return SectionItem(
       image: map['image'] as String,
       uidProduct: map['product'] as String,
     );
   }

   Map<String, dynamic> toMap(){
     return {
       'image': image,
       'product': uidProduct,
     };
   }


   SectionItem clone(){
     return SectionItem(
       image: image,
       uidProduct: uidProduct
     );
   }

   @override
  String toString() {
    return 'SectionItem{image: $image, uidProduct: $uidProduct}';
  }

}