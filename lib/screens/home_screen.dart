import 'package:flutter/material.dart';
import 'package:productos_app/models/products_Models.dart';
import 'package:productos_app/screens/screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final producService = Provider.of<ProductServices>(context);

    if(producService.isLoading) return LoadingScreen();
    //Cargar el CircularProgressIndicator, y una vez que obtenemos el JSON del FIREBASE el CircularProgressIndicator ponerlo en FALSO

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        //va a crear a los widget cuando esten cerca a entrar a la pantalla y no va a mantener toods activos
        itemCount: producService.products.length,
        itemBuilder: (BuildContext context, int index)=> GestureDetector(
          onTap: () {
            producService.selectProduct = producService.products[index].copyProduct();

            Navigator.pushNamed(context, 'product');
          },
          //Haciendo la redireccion a la pagina product

          child: ProductoCard( product: producService.products[index]),
        )
        // Text('Item: $index')
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        onPressed: (){

          producService.selectProduct = new ProductModel(
            available: false,
            name: '',
            price: 0,
            //INICIALIZANDO UN NUEVO PRODUCTO
          );

          Navigator.pushNamed(context, 'product');

        },
      ),
   );
  }
}