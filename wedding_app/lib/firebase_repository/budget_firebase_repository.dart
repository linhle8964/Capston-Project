import 'package:wedding_app/entity/budget_entity.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/budget_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseBudgetRepository implements BudgetRepository{
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');
  
  

  @override
  Future<void> createBudget(String weddingId, Budget budget) {
    
    final budgetCollection = FirebaseFirestore.instance.collection('wedding').doc(weddingId).collection("budget");

    return budgetCollection.add(budget.toEntity().toDocument());
  }

  @override
  Future<void> deleteBudget(String weddingId, Budget budget) {

  }

  @override
  Stream<List<Budget>> getBudgetByCateId(String weddingId,String cateId) {
    final budgetCollection = FirebaseFirestore.instance.collection('wedding')
        .doc(weddingId)
        .collection("budget");


    return budgetCollection
        .where("CateID", isEqualTo:cateId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          Budget.fromEntity(BudgetEntity.fromSnapshot(doc)))
          .toList();

    });
  }

  @override
  Future<void> updateBudget(String weddingId, Budget budget) {
    final budgetCollection = FirebaseFirestore.instance.collection('wedding').doc(weddingId).collection("budget");
    return budgetCollection.doc(budget.id).update(budget.toEntity().toDocument());
  }

  @override
  Future<Budget> getBudgetById(String budgetId, String weddingId) async {
    final budgetCollection = FirebaseFirestore.instance.collection('wedding').doc(weddingId).collection("budget");
    DocumentSnapshot snapshot = await budgetCollection.doc(budgetId).get();
    return Budget.fromEntity(BudgetEntity.fromSnapshot(snapshot));
  }

}