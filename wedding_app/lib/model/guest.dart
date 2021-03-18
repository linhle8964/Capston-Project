
import 'package:wedding_app/entity/guest_entity.dart';

class Guest{
  String id;
  String name;
  String description;
  int status;
  String phone;

  Guest(this.name, this.description, this.status, this.phone, {this.id});

  Guest copyWith({
    String id,
    String name,
    String description,
    int status,
    String phone
  }){
    return Guest(
      name ?? this.name,
      description ?? this.description,
      status ?? this.status,
      phone ?? this.phone,
      id: id ?? this.id
    );
  }

  GuestEntity toEntity(){
    return GuestEntity(id, name, description, status, phone);
  }

  static Guest fromEntity(GuestEntity entity){
    return Guest(
        entity.name,
        entity.description,
        entity.status,
        entity.phone,
        id: entity.id,
    );
  }

  @override
  String toString() {
    return name + description + status.toString() + phone;
  }
}