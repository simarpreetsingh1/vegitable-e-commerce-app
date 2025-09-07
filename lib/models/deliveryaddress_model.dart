class DeliveryAddressModel {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String alternativeNumber;
  final String society;
  final String street;
  final String landmark;
  final String city;
  final String area;
  final String pinCode;
  final String addressType;
  final double? longitude;
  final double? latitude;

  DeliveryAddressModel({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.alternativeNumber,
    required this.society,
    required this.street,
    required this.landmark,
    required this.city,
    required this.area,
    required this.pinCode,
    required this.addressType,
    this.longitude,
    this.latitude,
  });
}