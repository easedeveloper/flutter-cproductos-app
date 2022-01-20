import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductServices extends ChangeNotifier{

  final String _baseUrl= 'pruebas-409bd.firebaseio.com';

  final List<ProductModel> products = [];
  //se usa final porque no quiero destruir el objeto y volverlo asignar, solo quiero cambiar los valores internos

  late ProductModel selectProduct;
  //Creara una copia para volver a guardarlo en al BD y no implicar el products = []

  File? newPictureFile;
  //Aqui va a seleccionar una IMG 
  
  bool isLoading = true;
  //porque no usa final, porque va a estar cambiando entre TRUE y FALSE

  bool isSaving = false;

  ProductServices(){
    //cuando la instancia de producto service sea llamada se va a querer disparar metodos
    this.loadProduct();
  }



  //CREANDO EL METODO GETPRODUCT.. <List<ProductModel>>
  Future <List<ProductModel>> loadProduct() async{
    this.isLoading = true;
    notifyListeners();
    //Carganamos el Loading

    final url = Uri.https(_baseUrl, 'producto.json');

    final resp = await http.get(url);
    //me va a regresar una respuesta cuyo BODY viene como un STRING

    final Map<String, dynamic> productsMap = json.decode(resp.body); 
    //convirtiendo en un mapa de nuestros productos
    
    //Vamos hacer un barrido
    productsMap.forEach((key, value) {
      final tempProducto = ProductModel.fromMap(value);
      tempProducto.id = key;
      //Guardando la llave ejm: "idProducto" o "pructoABC"

      this.products.add( tempProducto );
    });

    this.isLoading = false;
    notifyListeners();
    //Acabamos el Loading

    return this.products;

    // print(this.products[0].picture);
    // //Imprimiendo el NAME de idProducto
    // print(productsMap);
  }

  Future saveOrCreateProduct( ProductModel product )async {

    this.isSaving = true;
    notifyListeners();

    //Necesito un ID para comprobar si tengo CREAR o ACTUALIZAR
    if( product.id == null ){
      //Es necesario CREAR
      await this.createProduct(product);
    }else{
      //Es necesario Actualizar
      await this.updateProduct(product);
    }
    


    this.isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct( ProductModel product ) async {
    
    final url = Uri.https(_baseUrl, 'producto/${ product.id }.json');

    final resp = await http.put(url, body: product.toJson());
    //me va a ACTUALIZAR una peticion scuyo BODY viene como un STRING

    final decodeData = resp.body;
    //print(decodeData);

    final index = this.products.indexWhere((element) => element.id == product.id);
    //Saber cual es el indice del producto ah Actualizar

    products[index] = product;
    //Enviandole la informacion nueva a products y asi actualizar la pantalla principal

    return product.id!;
  }

  //CREANDO EL PRODUCTO
  Future<String> createProduct( ProductModel product ) async {
    
    final url = Uri.https(_baseUrl, 'producto.json');

    final resp = await http.post(url, body: product.toJson());
    //me va a CREAR una peticion scuyo BODY viene como un STRING

    final decodeData = json.decode(resp.body); 
    //El decodeData, muestra el ID que crea en FIREBASE: "name":"-MmBZbxIFsY4c4HNqMiM"
    
    product.id = decodeData['name'];
    //Obteniendo el nuevo ID del producto

    this.products.add(product);
    //Guardando en la Lista de products
    
    return product.id!;
  }

  void updateSelectdProductImage( String path ){
    //La idea es cambiar la IMG que tengo en la vista previa

    this.selectProduct.picture = path; 
    //ya tenemos un producto en patanlla

    this.newPictureFile = File.fromUri(Uri(path: path));
    //crea el archivo existente y lo guardo en la variable

    notifyListeners();
  }

  Future<String?> uploadImage() async {

    if( this.newPictureFile == null ) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dgmixixts/image/upload?upload_preset=lrlvlsrw');

    final imageUploadRequest = http.MultipartRequest( 'POST', url );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodeData = json.decode( resp.body );
    return decodeData['secure_url'];

    //print( resp.body );
  }
  

}