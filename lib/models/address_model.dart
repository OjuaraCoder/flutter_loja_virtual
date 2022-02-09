class AddressModel {

  String street;
  String number;
  String complement;
  String district;
  String zipCode;
  String city;
  String state;
  double latitude;
  double longitude;

  AddressModel({
    required this.street,
    required this.number,
    required this.complement,
    required this.district,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude
  });

  factory AddressModel.clean(){
    return AddressModel(
      street: '',
      number: '',
      complement: '',
      district: '',
      zipCode: '',
      city: '',
      state: '',
      latitude: 0,
      longitude: 0
    );
  }
}
