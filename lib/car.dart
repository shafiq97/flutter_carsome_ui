// car.dart

class Car {
  final int id;
  final String make;
  final String model;
  final int year;
  final double price;
  final int mileage;
  final String color;
  final String createdAt;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
    required this.mileage,
    required this.color,
    required this.createdAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: int.parse(json['year'].toString()),
      price: double.parse(json['price'].toString()),
      mileage: json['mileage'],
      color: json['color'],
      createdAt: json['created_at'],
    );
  }
}
