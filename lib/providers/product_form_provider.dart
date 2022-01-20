import 'package:flutter/material.dart';
import 'package:productos_app/models/products_Models.dart';

class ProductFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  
  ProductModel product;
  //se crea para almacenar el nuevo prodcuto seleccionado

  ProductFormProvider( this.product );
  //cuando se quiera crear una instancia me tienen que enviar al producto

  updateAvalaibleAbility(bool value){
    print(value);
    this.product.available = value;
    notifyListeners();
    //usamos para notificar los cambios y redibujar
  }


  bool isValidForm(){

    print(product.name);
    print(product.price);
    print(product.available);

    return formkey.currentState?.validate() ?? false ;
  }

}