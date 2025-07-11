class Address {

  String? id;
  String? customerId;
  double? latitude;
  double? longitude;
  String? houseApartmentNo;
  String? streetNo;
  String? lane;
  String? city;
  String? buildingName;
  String? nearbyLandmark;

  Address({
    this.id,
    this.customerId,
    this.latitude,
    this.longitude,
    this.houseApartmentNo,
    this.streetNo,
    this.lane,
    this.city,
    this.buildingName,
    this.nearbyLandmark
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    customerId = json['customer_id'].toString();
    latitude = json['latitude'] != null ? double.tryParse(json['latitude']) : null;
    longitude = json['longitude'] != null ? double.tryParse(json['longitude']) : null;
    houseApartmentNo = json['house_apartment_no'].toString();
    streetNo = json['street_no'].toString();
    lane = json['lane'];
    city = json['city'];
    buildingName = json['building_name'];
    nearbyLandmark = json['nearby_landmark'];
  }
}