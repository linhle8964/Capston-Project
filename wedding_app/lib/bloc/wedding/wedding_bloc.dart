
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/utils/validations.dart';

class CreateWeddingBloc{
  StreamController _nameController = new StreamController();
  StreamController _partnerNameController = new StreamController();
  StreamController _weddingNameController = new StreamController();
  StreamController _addressController = new StreamController();
  StreamController _emailController = new StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get partnerNameStream => _partnerNameController.stream;
  Stream get weddingNameStream => _weddingNameController.stream;
  Stream get addressStream => _addressController.stream;
  Stream get emailStream => _emailController.stream;


  bool isNameValid(String text,int length){
    if(!Validation.isStringValid(text, length)){
      _nameController.sink.addError("hãy nhập ít nhất $length kí tự");
      return false;
    }
    _nameController.sink.add("OK");
    return true;
  }

  bool isPartnerNameValid(String text,int length){
    if(!Validation.isStringValid(text, length)){
      _partnerNameController.sink.addError("hãy nhập ít nhất $length kí tự");
      return false;
    }
    _partnerNameController.sink.add("OK");
    return true;
  }

  bool isWeddingNameValid(String text,int length){
    if(!Validation.isStringValid(text, length)){
      _weddingNameController.sink.addError("hãy nhập ít nhất $length kí tự");
      return false;
    }
    _weddingNameController.sink.add("OK");
    return true;
  }

  bool isAddressValid(String text,int length){
    if(!Validation.isStringValid(text, length)){
      _addressController.sink.addError("hãy nhập ít nhất $length kí tự");
      return false;
    }
    _addressController.sink.add("OK");
    return true;
  }

  bool isEmailValid(String email){
    if(!Validation.isEmailValid(email)){
      _emailController.sink.addError("email không chính xác");
      return false;
    }
    _emailController.sink.add("OK");
    return true;
  }

  void dispose(){
    _nameController.close();
    _partnerNameController.close();
    _weddingNameController.close();
    _addressController.close();
    _emailController.close();
  }

}