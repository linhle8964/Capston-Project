import 'package:equatable/equatable.dart';

import 'package:flutter_web_diary/model/vendor.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

class VendorLoading extends VendorState {}

class VendorLoaded extends VendorState {
  final List<Vendor> vendors;

  const VendorLoaded([this.vendors = const []]);

  @override
  List<Object> get props => [vendors];

  @override
  String toString() {
    return 'VendorLoaded{vendors: $vendors}';
  }
}

class VendorNotLoaded extends VendorState {}
