import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/category/bloc.dart';
import 'package:flutter_web_diary/bloc/login/login_bloc.dart';
import 'package:flutter_web_diary/bloc/vendor/bloc.dart';
import 'package:flutter_web_diary/firebase_repository/category_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/user_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/user_wedding_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/vendor_firebase_repository.dart';
import 'package:flutter_web_diary/firebase_repository/wedding_firebase_repository.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/user_wedding.dart';
import 'package:flutter_web_diary/model/vendor.dart';
import 'package:flutter_web_diary/model/wedding.dart';
import 'package:flutter_web_diary/screen/views/addVendor/add_vendor_page.dart';
import 'package:flutter_web_diary/screen/views/allvendor/all_vendor_page.dart';
import 'package:flutter_web_diary/screen/views/vendorDetail/vendor_detail_page.dart';
import 'package:flutter_web_diary/screen/views/error/error_page.dart';
import 'package:flutter_web_diary/screen/views/homeVendor/home_view.dart';
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
  bool add = false;
  bool _login = true;
  bool _home = false;
  void _handleTap(Vendor vendor) {
    _selectedVendor = Vendor(vendor.label, vendor.name,vendor.cateID ,vendor.location,vendor.description,vendor.frontImage,vendor.ownerImage,vendor.email,vendor.phone,id: vendor.id);
    notifyListeners();
  }
  void _handleAdd(bool add1){
    add = add1;
    notifyListeners();
  }
  void _handlelogin(bool login){
    _login = login;
    _selectedUser = UserWedding('home');
    notifyListeners();
  }
  void _handleHome(bool home){
    _home = home;
    notifyListeners();
  }
  

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  AdminVendorRoutePath get currentConfiguration {
    if (show404) return AdminVendorRoutePath.unknown();
    if (_selectedUser != null && add) return AdminVendorRoutePath.add(_selectedUser.id);
    if (_selectedUser != null && _home) return AdminVendorRoutePath.homeVendor(_selectedUser.id);
    if (_selectedUser == null && _selectedVendor == null) return AdminVendorRoutePath.login();
    if (_selectedUser != null && _selectedVendor == null) return AdminVendorRoutePath.allVendor(_selectedUser.id);
    if (_selectedUser != null && _selectedVendor != null)
      return AdminVendorRoutePath.inputDetailsVendor(_selectedUser.id, _selectedVendor.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              userWeddingRepository: FirebaseUserWeddingRepository(),
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
          
          if (show404)
            MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
          else if ( _selectedVendor == null && !add && _login)
              MaterialPage(
                key: ValueKey('Login'),
                child: LoginPage(onTapped: _handleTap,onAdd: _handleAdd,onlogin: _handlelogin,onHome: _handleHome,)
              )
              else if(_selectedUser == null && !_login)
                 MaterialPage(
                key: ValueKey('Login'),
                child: LoginPage(onTapped: _handleTap,onAdd: _handleAdd,onlogin: _handlelogin,onHome: _handleHome,)
                 )     
              else if (_selectedUser != null && _selectedVendor == null && !add && !_login && _home)            
                MaterialPage(
                  key: ValueKey('HomeVendor'),
                  child: HomeViewGuest(onTapped: _handleTap,onAdd: _handleAdd,onHome: _handleHome,)
                )          
            else if (_selectedUser != null && _selectedVendor == null && add && !_login)            
                MaterialPage(
                  key: ValueKey('AddVendor'),
                  child: AddVendorPage(),
                )
            else if(_selectedUser != null && _selectedVendor == null && !add && !_login)
                MaterialPage(
                  key: ValueKey('AllVendor'),
                  child: AllVendorPage(onTapped: _handleTap,onAdd: _handleAdd,)
                )                                
            else if (_selectedUser != null && _selectedVendor != null)
                MaterialPage(
                    key: ValueKey('inputDetailsVendor'),
                    child: VendorDetailPage(vendor: _selectedVendor,isEditing: true,)
                ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          if(route.toString().contains('Home')){
            print(route.toString());
          _selectedVendor = null;
          _selectedUser = null;
          show404 = false;
          add = false;
          _login= true;
          notifyListeners();
          return true;
          }else if(route.toString().contains('inputDetails')){
            print(route.toString());
          _selectedVendor = null;
          _selectedUser = UserWedding('admin');
          show404 = false;
          add = false;
          _login= false;
          notifyListeners();
          return true;
          }
         return false;
        },
      ),


    );
  }

  _setPath(AdminVendorRoutePath path) {
    _selectedUser = null;
    _selectedVendor = null;

    if (path.isAllVendorPage) {
      _selectedUser = UserWedding(path.adminID);
      add =false;
      _login=false;
      _home=false;
      _selectedVendor = null;
      show404 = false;
    } else if (path.isInputDetailsVendorPage) {
      _selectedUser = UserWedding(path.adminID);
      _selectedVendor = Vendor("", "","" ,"","","","","","" ,id: path.vendorID);
      add =false;
      _login=false;
      _home=false;
      show404 = false;
    } else if (path.isLoginPage){
      _selectedUser = null;
      _selectedVendor = null;
      add =false;
      _login=true;
      _home=false;
      show404 = false;
      return;
    }else if(path.isHomeVendorPage){
      _selectedUser=UserWedding(path.adminID);
      _selectedVendor = null;
       show404 = false;
       add =false;
      _login=false;
      _home=true;
    }else if(path.isAdd){
      _selectedUser=UserWedding(path.adminID);
      _selectedVendor = null;
       show404 = false;
       add =true;
      _login=false;
      _home=false;
    }

    if (path.isUnknown) {
      _selectedUser = null;
      _selectedVendor = null;
      show404 = true;
      add =false;
      _login=false;
      _home=false;
      return;
    }

    add = false;
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
