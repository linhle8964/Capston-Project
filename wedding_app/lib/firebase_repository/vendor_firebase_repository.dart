
import 'package:wedding_app/entity/vendor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/model/vendor.dart';
import 'package:wedding_app/repository/vendor_repository.dart';

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
