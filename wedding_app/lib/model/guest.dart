import 'package:wedding_app/entity/guest_entity.dart';

class Guest{
  String id;
  String name;
  String description;
  int status;
  String phone;
  int type;
  int companion;
  String congrat;
  int money;

  Guest(this.name, this.description, this.status, this.phone, this.type, this.companion, this.congrat, this.money,
      {this.id});

  Guest copyWith({
    String id,
    String name,
    String description,
    int status,
    String phone,
    int type,
    int companion,
    String congrat,
    int money,
  }){
    return Guest(
      name ?? this.name,
      description ?? this.description,
      status ?? this.status,
      phone ?? this.phone,
      type ?? this.type,
      companion ?? this.companion,
      congrat ?? this.congrat,
      money ?? this.money,
      id: id ?? this.id,
    );
  }

  GuestEntity toEntity(){
    return GuestEntity(id, name, description, status, phone, type, companion, congrat, money);
  }

  static Guest fromEntity(GuestEntity entity){
    return Guest(
        entity.name,
        entity.description,
        entity.status,
        entity.phone,
        entity.type,
        entity.companion,
        entity.congrat,
        entity.money,
        id: entity.id,
    );
  }

  @override
  String toString() {
    return name +"|"+ description +"|"+ status.toString() +"|"+ phone +"|"+companion.toString()+"|"
        +congrat+"|"+money.toString()+"|"+type.toString();
  }
}