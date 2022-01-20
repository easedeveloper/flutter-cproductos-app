import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  //para poder saber el estado del form

  String email    = '';
  String password = '';

  bool _isLoading = false;
  bool get getIsLoading => _isLoading;
  set  setIsLoading( bool value ){
    this._isLoading = value;
    notifyListeners();
  }

  bool isValidationForm(){

    print(formKey.currentState?.validate());

    print('$email - $password');

    return formKey.currentState?.validate() ?? false;
  }

}