import 'package:flutter/material.dart';
import 'package:productos_app/models/products_Models.dart';

class ProductoCard extends StatelessWidget {

  final ProductModel product;

  const ProductoCard({
    Key? key,
    required this.product
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _CardBordes(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundIMG( product.picture ),

            _ProductDetails( product.name, product.id! ),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag( product.price )
            ),

            if(!product.available)
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvaible()
            )

          ],
        ),
      ),
    );
  }

  BoxDecoration _CardBordes() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );
}

class _NotAvaible extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No Disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double precioProduct;

  const _PriceTag(
    this.precioProduct
  );
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        //con esto el texto se va a adaptar al espacio que tiene
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,),
          child: Text(
            '\$${this.precioProduct}',
            style: TextStyle(color: Colors.white, fontSize: 20)
          )
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25)
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  final String nameProduct;
  final String subNameProduct;

  const _ProductDetails(
    this.nameProduct,
    this.subNameProduct
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        //color: Colors.indigo,

        decoration: _BuildBoxDecoration(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.nameProduct,
              style: TextStyle( fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              this.subNameProduct,
              style: TextStyle( fontSize: 15, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(25)
    )
  );
}


class _BackgroundIMG extends StatelessWidget {
  final String? imgUrl;

  const _BackgroundIMG(
    this.imgUrl
  ); 

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: (imgUrl == null)
          ? Image(image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover,)
          :FadeInImage(
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(imgUrl!),
            fit: BoxFit.cover,
              //para que se expanda toda la imagen
          ),
      ),
    );
  }
}