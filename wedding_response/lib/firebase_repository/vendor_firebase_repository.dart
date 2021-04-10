import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_diary/entity/vendor_entity.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/repository/vendor_repository.dart';


class FirebaseVendorRepository implements VendorRepository {
  final vendorCollection = FirebaseFirestore.instance.collection('vendor');


  @override
  Stream<List<Vendor>> getallVendor() {
    return vendorCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Vendor.fromEntity(VendorEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}