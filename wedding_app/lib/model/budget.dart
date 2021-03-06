import 'package:wedding_app/entity/budget_entity.dart';

class Budget {
  final String id;
  final String budgetName;
  final String cateID;
  final double money;
  final double payMoney;
  final int status;
  final bool isComplete;

  Budget(this.budgetName, this.cateID, this.isComplete, this.money,
      this.payMoney, this.status,
      {String id})
      : this.id = id;

  Budget.fromMap(Map<dynamic, dynamic> map)
      : this.id = map['id'],
        this.budgetName = map['budgetName'],
        this.cateID = map['cateID'],
        this.money = map['money'],
        this.payMoney = map['payMoney'],
        this.isComplete = map['Complete'],
        this.status = map['status'];

  Map toMap() {
    return {
      'id': this.id,
      'budgetName': this.budgetName,
      'cateID': this.cateID,
      'money': this.money,
      'payMoney': this.payMoney,
      'Complete': this.isComplete,
      'status': this.status,
    };
  }

  Budget copyWith(
      {String id,
      String budgetName,
      String cateID,
      double money,
      double payMoney,
      bool isComplete,
      int status}) {
    return Budget(
        budgetName ?? this.budgetName,
        cateID ?? this.cateID,
        isComplete ?? this.isComplete,
        money ?? this.money,
        payMoney ?? this.payMoney,
        status ?? this.status,
        id: id ?? this.id);
  }

  @override
  String toString() {
    return 'Budget{id: $id, budgetName: $budgetName, cateID: $cateID, money: $money, payMoney: $payMoney, status: $status}\n';
  }

  BudgetEntity toEntity() {
    return BudgetEntity(
        id, budgetName, cateID, isComplete, money, payMoney, status);
  }

  bool operator ==(o) =>
      o is Budget &&
      o.budgetName == budgetName &&
      o.id == id &&
      o.cateID == cateID &&
      o.money == money &&
      o.payMoney == payMoney &&
      o.isComplete == isComplete &&
      o.status == status;

  static Budget fromEntity(BudgetEntity entity) {
    return Budget(entity.budgetName, entity.cateID, entity.isComplete,
        entity.money, entity.payMoney, entity.status,
        id: entity.id);
  }
}
