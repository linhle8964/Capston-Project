import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/util/wedding_route_path.dart';

class WeddingGuestRouteInformationParser extends RouteInformationParser<WeddingGuestRoutePath> {
  @override
  Future<WeddingGuestRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location);

    // Handle '/:weddingID'
    if (uri.pathSegments.length == 1) {
      final weddingID = uri.pathSegments.first;
      if (weddingID == null) return WeddingGuestRoutePath.unknown();
      if(weddingID == "done") return WeddingGuestRoutePath.Done();
      return WeddingGuestRoutePath.register(weddingID);
    }
    // Handle '/:weddingID/:guestID'
    if (uri.pathSegments.length == 2) {
      final weddingID = uri.pathSegments.first;
      final guestID = uri.pathSegments.elementAt(1);
      if (weddingID != null && guestID !=null) return WeddingGuestRoutePath.inputDetails(weddingID,guestID);
      else if (weddingID != null && guestID ==null) return WeddingGuestRoutePath.register(weddingID);

      return WeddingGuestRoutePath.unknown();
    }

    return WeddingGuestRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(WeddingGuestRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isRegisterPage) {
      return RouteInformation(location: '/${path.weddingID}');
    }
    if (path.isInputDetailsPage) {
      return RouteInformation(location: '/${path.weddingID}/${path.guestID}');
    }
    if (path.isDone) {
      return RouteInformation(location: '/done');
    }

    return null;
  }
}


