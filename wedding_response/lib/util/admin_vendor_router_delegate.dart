import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/category/bloc.dart';
import 'package:flutter_web_diary/bloc/login/login_bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/category_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/user_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/vendor_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/user_wedding.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/screen/vendor/detail.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_page.dart';
import 'package:flutter_web_diary/screen/views/detail/vendor_detail_page.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/home/home_view.dart';
import 'package:flutter_web_diary/screen/views/input_details/input_details.dart';
import 'package:flutter_web_diary/screen/views/login/login_page.dart';
import 'package:flutter_web_diary/screen/views/success/success_page.dart';
import 'package:flutter_web_diary/util/admin_login_route_path.dart';
import 'package:flutter_web_diary/util/globle_variable.dart';
import 'package:flutter_web_diary/util/admin_vendor_route_path.dart';

class AdminVendorRouterDelegate extends RouterDelegate<AdminVendorRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AdminVendorRoutePath> {
  UserWedding _selectedUser;
  Vendor _selectedVendor;
  //String _selectedVendorID;
  bool show404 = false;
  bool showDone = false;
  bool login = false;

  void _handleTap(Vendor vendor) {
    _selectedVendor = vendor;
    notifyListeners();
  }

  void _tapSubmitSuccess(bool b) {
    showDone = b;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  AdminVendorRoutePath get currentConfiguration {
    if (show404) return AdminVendorRoutePath.unknown();
    //if (showDone) return WeddingGuestRoutePath.Done();
    if (_selectedUser == null && _selectedVendor == null) return AdminVendorRoutePath.Login();
    if (_selectedUser != null && _selectedVendor == null) return AdminVendorRoutePath.AllVendor(_selectedUser.id);
    if (_selectedUser != null && _selectedVendor != null)
      return AdminVendorRoutePath.inputDetails(_selectedUser.id, _selectedVendor.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              userRepository: FirebaseUserRepository(),
            )),
        BlocProvider<VendorBloc>(
          create: (BuildContext context) => VendorBloc(
            todosRepository: FirebaseVendorRepository(),
          ),
        ),
        BlocProvider<CateBloc>(
          create: (BuildContext context) => CateBloc(
            todosRepository: FirebaseCategoryRepository(),
          ),
        ),
      ],
      child: Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(key: ValueKey('Login'), child: LoginPage()),
          if (show404)
            MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
          else if (_selectedUser == null && _selectedVendor == null)
              MaterialPage(
                key: ValueKey('Login'),
                child: LoginPage()
              )
            else if (_selectedUser != null && _selectedVendor == null)
                MaterialPage(
                  key: ValueKey('AllVendor'),
                  child: AllVendorPage()
                )
            else if (_selectedUser != null && _selectedVendor != null)
                MaterialPage(
                    key: ValueKey('inputDetails'),
                    child: VendorDetailPage(vendor: _selectedVendor,isEditing: true,)
                ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          _selectedVendor = null;
          _selectedUser = null;
          show404 = false;
          showDone = false;
          notifyListeners();
          return true;
        },
      ),


    );
  }

  _setPath(AdminVendorRoutePath path) {
    _selectedUser = null;
    _selectedVendor = null;

    if (path.isAllVendorPage) {
      _selectedUser = UserWedding(path.adminID);


    } else if (path.isInputDetailsPage) {
      _selectedUser = UserWedding(path.adminID);

      _selectedVendor = Vendor("", "","" ,"","","","","","" ,id: path.vendorID);

    } else if (path.isLoginPage){
      _selectedUser = null;
      _selectedVendor = null;
      show404 = false;
      return;
    }

    if (path.isUnknown) {
      _selectedUser = null;
      _selectedVendor = null;
      show404 = true;
      return;
    }

    if (path.isDone) {
      showDone = true;
      return;
    }


    show404 = false;
    showDone = false;
  }

  @override
  Future<void> setNewRoutePath(AdminVendorRoutePath path) async {
    _setPath(path);
  }

  @override
  Future<void> setInitialRoutePath(AdminVendorRoutePath path) async {
    _setPath(path);
  }
}
