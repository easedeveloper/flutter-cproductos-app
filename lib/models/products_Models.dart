// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);


// class Welcome {
//     Welcome({
//         this.idProducto,
//         this.pructoAbc,
//     });

//     IdProducto idProducto;
//     IdProducto pructoAbc;

//     factory Welcome.fromJson(String str) => Welcome.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory Welcome.fromMap(Map<String, dynamic> json) => Welcome(
//         idProducto: IdProducto.fromMap(json["idProducto"]),
//         pructoAbc: IdProducto.fromMap(json["pructoABC"]),
//     );

//     Map<String, dynamic> toMap() => {
//         "idProducto": idProducto.toMap(),
//         "pructoABC": pructoAbc.toMap(),
//     };
// }

import 'dart:convert';
class ProductModel {
    ProductModel({
        required this.available,
        required this.name,
        this.picture,
        required this.price,
        this.id
        //this.idProductoPicture,
    });

    bool available;
    String name;
    String? picture;
    double price;
    String? id;
    //String idProductoPicture;

    factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        available: json["available"],
        name: json["name"],
        picture: json["picture"] == null ? null : json["picture"],
        price: json["price"].toDouble(),
        //idProductoPicture: json["picture "] == null ? null : json["picture "],
    );

    Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture == null ? null : picture,
        "price": price,
        //"picture ": idProductoPicture == null ? null : idProductoPicture,
    };

    //SE HACE UNA COPIA DE LOS PRODUCTOS
    ProductModel copyProduct() => ProductModel(
      available: this.available,
      name: this.name, 
      picture: this.picture,
      price: this.price,
      id: this.id
    );

}
