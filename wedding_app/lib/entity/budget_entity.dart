import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  final String id;
  final String budgetName;
  final String cateID;
  final double money;
  final double payMoney;
  final bool isComplete;
  final int status;
  final String note;

  BudgetEntity(this.id, this.budgetName, this.cateID, this.isComplete,
      this.money, this.payMoney, this.status, this.note);

  @override
  List<Object> get props =>
      [id, budgetName, cateID, money, payMoney, isComplete, status, note];

  Map<String, Object> toJson() {
    return {
      "id": id,
      "budgetName": budgetName,
      "cateID": cateID,
      "Complete": isComplete,
      "money": money,
      "payMoney": payMoney,
      "status": status,
      "note": note
    };
  }

  static BudgetEntity fromJson(Map<String, Object> json) {
    return BudgetEntity(
        json["id"] as String,
        json["budgetName"] as String,
        json["cateID"] as String,
        json["Complete"] as bool,
        json["money"] as double,
        json["payMoney"] as double,
        json["status"] as int,
        json["note"] as String);
  }

  static BudgetEntity fromSnapshot(DocumentSnapshot snapshot) {
    return BudgetEntity(
        snapshot.id,
        snapshot.get("budgetName"),
        snapshot.get("cateID"),
        snapshot.get("Complete"),
        snapshot.get("money").toDouble(),
        snapshot.get("payMoney").toDouble(),
        snapshot.get("status"),
        snapshot.get("note"));
  }

  @override
  String toString() {
    return 'BudgetEntity{id: $id, budgetName: $budgetName, cateID: $cateID, money: $money, payMoney: $payMoney, isComplete: $isComplete, status: $status,note: $note}';
  }

  Map<String, Object> toDocument() {
    return {
      "budgetName": budgetName,
      "cateID": cateID,
      "Complete": isComplete,
      "money": money,
      "payMoney": payMoney,
      "status": status,
      "note":note
    };
  }
}
