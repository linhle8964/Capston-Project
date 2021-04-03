import 'package:wedding_app/model/vendor.dart';

abstract class VendorRepository {
  Stream<List<Vendor>> getallVendor();
}
