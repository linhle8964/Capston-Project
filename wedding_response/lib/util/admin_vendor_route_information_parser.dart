import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/util/admin_vendor_route_path.dart';

class AdminVendorRouteInformationParser extends RouteInformationParser<AdminVendorRoutePath> {
  @override
  Future<AdminVendorRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location);
    // Handle '/'
    if (uri.pathSegments.length == 0 ) {
      return AdminVendorRoutePath.login();
    }
    // Handle '/login'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'admin'&& uri.pathSegments.first != 'home') {
      final login = uri.pathSegments.first;
      if (login == null) return AdminVendorRoutePath.unknown();
      if(login != "login" ) return  AdminVendorRoutePath.unknown();
      return AdminVendorRoutePath.login();
    }
    // Handle '/home'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'admin' &&  uri.pathSegments.first != 'login') {
      final home = uri.pathSegments.first;
      if (home == null) return AdminVendorRoutePath.unknown();
      if(home != "home" ) return  AdminVendorRoutePath.unknown();
      return AdminVendorRoutePath.home(home);
    }

    // Handle '/admin'
    if (uri.pathSegments.length == 1 && uri.pathSegments.first != 'login'&& uri.pathSegments.first != 'home') {
      final admin = uri.pathSegments.first;
      if (admin == null) return AdminVendorRoutePath.unknown();
      if(admin != 'admin') return  AdminVendorRoutePath.unknown();
      return  AdminVendorRoutePath.allVendor(admin);
    }
    // Handle '/admin/:vendorID'
    if (uri.pathSegments.length == 2 && uri.pathSegments.elementAt(1)!='add') {
      final admin = uri.pathSegments.first;
      final vendorID = uri.pathSegments.elementAt(1);
      if (admin == 'admin' && vendorID !=null) return AdminVendorRoutePath.inputDetails(admin,vendorID);
      else if (admin == 'admin' && vendorID ==null) return AdminVendorRoutePath.allVendor(admin);

      return AdminVendorRoutePath.unknown();
    }

    // Handle '/admin/add'
    if (uri.pathSegments.length == 2 && uri.pathSegments.elementAt(1) =='add')  {
      final admin = uri.pathSegments.first;
      final add = uri.pathSegments.elementAt(1);
      if (admin == 'admin' && add =='add') return AdminVendorRoutePath.add(admin);
      else if (admin == 'admin' && add ==null) return AdminVendorRoutePath.allVendor(admin);

      return AdminVendorRoutePath.unknown();
    }

    return AdminVendorRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AdminVendorRoutePath path) {

    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if(path.isHome){
      return RouteInformation(location: '/home');
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
    if(path.isAdd){
      return RouteInformation(location: '/admin/add');
    }
    


    return null;
  }
}


