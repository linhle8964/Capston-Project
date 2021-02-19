import 'package:wedding_app/entity/budget_entity.dart';
import 'package:wedding_app/model/budget.dart';
import 'package:wedding_app/model/wedding.dart';
import 'package:wedding_app/repository/budget_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseBudgetRepository implements BudgetRepository{
  final weddingCollection = FirebaseFirestore.instance.collection('wedding');
  
  

  @override
  Future<void> createBudget(Wedding wedding, Budget budget) {
    
    final budgetCollection = FirebaseFirestore.instance.collection('wedding').doc(wedding.id).collection("budget");

    return budgetCollection.add(budget.toEntity().toDocument());
  }

  @override
  Future<void> deleteBudget(Wedding wedding, Budget budget) {

  }

  @override
  Future<Budget> getWeddingByCategory(String CateId) {

  }

  @override
  Future<void> updateBudget(Wedding wedding, Budget budget) {

  }

}