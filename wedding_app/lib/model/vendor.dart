import 'package:wedding_app/entity/vendor_entity.dart';

class Vendor {
  String id;
  String label;
  String name;
  String cateID;
  String location;
  String description;
  String frontImage;
  String ownerImage;
  

  Vendor(this.label, this.name,this.cateID ,this.location, this.description, this.frontImage, this.ownerImage, {String id})
      : this.id = id;
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
    return Vendor(
        label ?? this.label,
        name?? this.name,
        cateID ?? this.cateID,
        location ?? this.location,
        description ?? this.description,
        frontImage ?? this.frontImage,
        ownerImage ?? this.ownerImage,
        id: id ?? this.id);
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
    return Vendor(entity.label,entity.name, entity.cateID, entity.location,
        entity.description, entity.frontImage, entity.ownerImage,
        id: entity.id);
  }
}

