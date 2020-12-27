class Service {
  String uid;
  String ownerId;
  String description;
  int price;

  Service({
    this.ownerId,
    this.description,
    this.price,
  });

  Service.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        ownerId = json['ownerId'],
        description = json['description'],
        price = json['price'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'ownerId': ownerId,
    'description': description,
    'price': price
  };
}