import 'package:wedding_app/entity/wedding_entity.dart';

class Wedding {
  final String id;
  final String brideName;
  final String groomName;
  final DateTime weddingDate;
  final double budget;
  final String image;
  final DateTime dateCreated;
  final String address;
  final DateTime modifiedDate;

  Wedding(this.brideName, this.groomName, this.weddingDate, this.image,
      this.address,
      {String id, double budget, DateTime dateCreated, DateTime modifiedDate})
      : this.id = id,
        this.budget = budget,
        this.dateCreated = dateCreated,
        this.modifiedDate = modifiedDate;

  Wedding copyWith({
    String id,
    String brideName,
    String groomName,
    DateTime weddingDate,
    double budget,
    String image,
    DateTime dateCreated,
    String address,
    DateTime modifiedDate,
  }) {
    return Wedding(
        brideName ?? this.brideName,
        groomName ?? this.groomName,
        weddingDate ?? this.weddingDate,
        image ?? this.image,
        address ?? this.address,
        id: id ?? this.id,
        budget: budget ?? this.budget,
        dateCreated: dateCreated ?? this.dateCreated,
        modifiedDate: modifiedDate ?? this.modifiedDate);
  }

  WeddingEntity toEntity() {
    return WeddingEntity(id, brideName, groomName, weddingDate, budget, image,
        dateCreated, address, modifiedDate);
  }

  static Wedding fromEntity(WeddingEntity entity) {
    return Wedding(
      entity.brideName,
      entity.groomName,
      entity.weddingDate,
      entity.image,
      entity.address,
      id: entity.id,
      budget: entity.budget ?? 0,
      dateCreated: entity.dateCreated ??
          new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
      modifiedDate: entity.dateCreated ??
          new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
  }

  @override
  String toString() {
    return "Wedding: $id, $brideName, $groomName, $weddingDate, $image, $address, $budget";
  }
}
