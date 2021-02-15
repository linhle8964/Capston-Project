import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  final String id;
  final String BudgetName;
  final String CateID;
  final double money;
  final double payMoney;
  final int status;

  BudgetEntity(this.id, this.BudgetName, this.CateID, this.money, this.payMoney,
      this.status);

  @override
  List<Object> get props => [id, BudgetName, CateID, money, payMoney, status];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "BudgetName": BudgetName,
      "CateID": CateID,
      "money": money,
      "payMoney": payMoney,
      "status": status,
    };
  }


  static BudgetEntity fromJson(Map<String, Object> json) {
    return BudgetEntity(
      json["id"] as String,
      json["BudgetName"] as String,
      json["CateID"] as String,
      json["money"] as double,
      json["payMoney"] as double,
      json["status"] as int,

    );
  }

  static BudgetEntity fromSnapshot(DocumentSnapshot snapshot) {
    return BudgetEntity(
      snapshot.id,
      snapshot.get("BudgetName"),
      snapshot.get("CateID"),
      snapshot.get("money"),
      snapshot.get("payMoney"),
      snapshot.get("status")
    );
  }

  Map<String, Object> toDocument() {
    return {
      "BudgetName": BudgetName,
      "CateID": CateID,
      "money": money,
      "payMoney": payMoney,
      "status": status,
    };
  }
}
