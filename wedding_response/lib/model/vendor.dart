import 'package:flutter_web_diary/entity/vendor_entity.dart';

class Vendor {
  String id;
  String label;
  String name;
  String cateID;
  String location;
  String description;
  String frontImage;
  String ownerImage;

  Vendor(this.id,
      {String label,
        String name,
        String cateID,
        String location,
        String description,
        String frontImage,
        String ownerImage})
      : this.label = label,
        this.name = name,
        this.cateID = cateID,
        this.location = location,
        this.description = description,
        this.frontImage = frontImage,
        this.ownerImage = ownerImage;



  Vendor.fromMap(Map<dynamic, dynamic> map)
      : this.id = map['id'],
        this.label = map['budgetName'],
        this.name= map['name'],
        this.cateID = map['cateID'],
        this.location = map['location'],
        this.description = map['description'],
        this.frontImage = map['frontImage'],
        this.ownerImage = map['ownerImage'];

  Map toMap() {
    return {
      'id': this.id,
      'label': this.label,
      'name':this.name,
      'cateID': this.cateID,
      'location': this.location,
      'description': this.description,
      'frontImage': this.frontImage,
      'ownerImage': this.ownerImage,
    };
  }

  Vendor copyWith(
      {String id,
        String label,
        String name,
        String cateID,
        String location,
        String description,
        String frontImage,
        String ownerImage}) {
    return Vendor(id ?? this.id,
        label:label ?? this.label,
        name:name?? this.name,
        cateID:cateID ?? this.cateID,
        location: location?? this.location,
        description:description ?? this.description,
        frontImage: frontImage?? this.frontImage,
        ownerImage: ownerImage?? this.ownerImage,
        );
  }


  VendorEntity toEntity() {
    return VendorEntity(
        id, label,name, cateID, location, description, frontImage, ownerImage);
  }

  bool operator ==(o) =>
      o is Vendor &&
          o.label == label &&
          o.id == id &&
          o.name==name &&
          o.cateID == cateID &&
          o.location == location &&
          o.description == description &&
          o.frontImage == frontImage &&
          o.ownerImage == ownerImage;

  static Vendor fromEntity(VendorEntity entity) {
    return Vendor(entity.id,
        label:entity.label,
        name:entity.name,
        cateID:entity.cateID,
        location:entity.location,
        description:entity.description,
        frontImage:entity.frontImage,
        ownerImage:entity.ownerImage);
  }

  @override
  String toString() {
    return 'Vendor{id: $id, label: $label, name: $name, cateID: $cateID, location: $location, description: $description, frontImage: $frontImage, ownerImage: $ownerImage}';
  }
}

