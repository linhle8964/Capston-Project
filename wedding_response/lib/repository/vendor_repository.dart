
import 'package:flutter_web_diary/model/vendor.dart';

abstract class VendorRepository {
  Stream<List<Vendor>> getallVendor();
}