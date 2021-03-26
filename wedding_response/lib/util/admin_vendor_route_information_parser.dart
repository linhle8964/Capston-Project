import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/util/admin_vendor_route_path.dart';

class AdminVendorRouteInformationParser extends RouteInformationParser<AdminVendorRoutePath> {
  @override
  Future<AdminVendorRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location);
    // Handle '/'
    if (uri.pathSegments.length == 0 ) {
      return AdminVendorRoutePath.Login();
    }
    // Handle '/login'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'admin') {
      final login = uri.pathSegments.first;
      if (login == null) return AdminVendorRoutePath.unknown();
      if(login != "login" ) return  AdminVendorRoutePath.unknown();
      return AdminVendorRoutePath.Login();
    }
    // Handle '/admin'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'login') {
      final admin = uri.pathSegments.first;
      if (admin == null) return AdminVendorRoutePath.unknown();
      if(admin != 'admin') return  AdminVendorRoutePath.unknown();
      return  AdminVendorRoutePath.AllVendor(admin);
    }
    // Handle '/admin/:vendorID'
    if (uri.pathSegments.length == 2) {
      final admin = uri.pathSegments.first;
      final vendorID = uri.pathSegments.elementAt(1);
      if (admin == 'admin' && vendorID !=null) return AdminVendorRoutePath.inputDetails(admin,vendorID);
      else if (admin == 'admin' && vendorID ==null) return AdminVendorRoutePath.AllVendor(admin);

      return AdminVendorRoutePath.unknown();
    }

    return AdminVendorRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AdminVendorRoutePath path) {

    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isAllVendorPage) {
      return RouteInformation(location: '/admin');
    }
    if (path.isInputDetailsPage) {
      return RouteInformation(location: '/admin/${path.vendorID}');
    }
    if (path.isLoginPage) {
      return RouteInformation(location: '/login');
    }


    return null;
  }
}


