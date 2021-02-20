import 'package:wedding_app/entity/budget_entity.dart';

class Budget {
  final String id;
  final String BudgetName;
  final String CateID;
  final double money;
  final double payMoney;
  final int status;

  Budget(this.BudgetName, this.CateID,this.money,this.payMoney, this.status,
      {String id})
      : this.id = id;


  Budget copyWith(
      {String id,
      String BudgetName,
      String CateID,
      double money,
      double payMoney,
      int status}) {
    return Budget(BudgetName ?? this.BudgetName, CateID ?? this.CateID,money?? this.money,payMoney??this.payMoney,
        status ?? this.status);
  }

  @override
  String toString() {
    return 'Budget{id: $id, BudgetName: $BudgetName, CateID: $CateID, money: $money, payMoney: $payMoney, status: $status}\n';
  }

  BudgetEntity toEntity() {
    return BudgetEntity(id, BudgetName, CateID, money, payMoney, status);
  }

  bool operator ==(o) =>
      o is Budget &&
      o.BudgetName == BudgetName &&
      o.id == id &&
      o.CateID == CateID &&
      o.money == money &&
      o.payMoney == payMoney &&
      o.status == status;

  static Budget fromEntity(BudgetEntity entity) {
    return Budget(entity.BudgetName, entity.CateID,entity.money,entity.payMoney,entity.status);
  }
}
