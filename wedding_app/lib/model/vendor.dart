import 'package:wedding_app/entity/vendor_entity.dart';

class Vendor {
  String id;
  String label;
  String name;
  String cateID;
  String email;
  String phone;
  String location;
  String description;
  String frontImage;
  String ownerImage;
  

  Vendor(this.label, this.name,this.cateID ,this.email,this.phone,this.location, this.description, this.frontImage, this.ownerImage, {String id})
      : this.id = id;
  Vendor.fromMap(Map<dynamic, dynamic> map)
      : this.id = map['id'],
        this.label = map['label'],
        this.name= map['name'],
        this.email = map['email'],
        this.phone = map['phone'],
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
      'email':this.email,
      'phone':this.phone,
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
        String email,
        String phone,
        String cateID,
        String location,
        String description,
        String frontImage,
        String ownerImage}) {
    return Vendor(
        label ?? this.label,
        name?? this.name,
        email?? this.email,
        phone?? this.phone,
        cateID ?? this.cateID,
        location ?? this.location,
        description ?? this.description,
        frontImage ?? this.frontImage,
        ownerImage ?? this.ownerImage,
        id: id ?? this.id);
  }


  VendorEntity toEntity() {
    return VendorEntity(
        id, label,name,email,phone, cateID, location, description, frontImage, ownerImage);
  }

  bool operator ==(o) =>
      o is Vendor &&
          o.label == label &&
          o.id == id &&
          o.name==name &&
          o.email==email &&
          o.phone==phone &&
          o.cateID == cateID &&
          o.location == location &&
          o.description == description &&
          o.frontImage == frontImage &&
          o.ownerImage == ownerImage;

  static Vendor fromEntity(VendorEntity entity) {
    return Vendor(entity.label,entity.name,entity.email,entity.phone, entity.cateID, entity.location,
        entity.description, entity.frontImage, entity.ownerImage,
        id: entity.id);
  }

  @override
  String toString() {
    return 'Vendor{id: $id, label: $label, name: $name, cateID: $cateID, location: $location, description: $description, frontImage: $frontImage, ownerImage: $ownerImage}';
  }
}

