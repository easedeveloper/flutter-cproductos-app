import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final producService = Provider.of<ProductServices>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider( producService.selectProduct ),
      //Enviandole el productoSeleccionado por el constructor ah ProductFormProvider

      child: _ProductScreenProduct(producService: producService),
    );

  }
}

class _ProductScreenProduct extends StatelessWidget {

  const _ProductScreenProduct({
    Key? key,
    required this.producService,
  }) : super(key: key);

  final ProductServices producService;

  @override
  Widget build(BuildContext context) {

    final productFormu = Provider.of<ProductFormProvider>(context);


    return Scaffold(
      body: SingleChildScrollView(
        //nos puede servir para cuando el teclado del celular tape los demas inputs

        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //Cuando se haga Scroll se va a ocultar el teclado

        child: Column(
          children: [
            Stack(
              children: [
                ProductoImage( urlImg: producService.selectProduct.picture ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: ()async {
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                        //source: ImageSource.gallery,
                        source: ImageSource.camera,
                        imageQuality: 100
                      );

                      if( pickedFile == null ){
                        print('No Selecciono Nada');
                        return;
                      }

                      //print('Tenemos imagen ${ pickedFile.path }');
                      producService.updateSelectdProductImage(pickedFile.path);

                    },
                    icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,)
                  )
                ),

                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios, size: 40, color: Colors.white,)
                  )
                ),
              ],
            ),

            _ProductForm(),

            SizedBox(height: 100,),

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //crea una animacion
      floatingActionButton: FloatingActionButton(
        child: producService.isSaving
          ? CircularProgressIndicator( color: Colors.white, )
          : Icon( Icons.save_rounded ),
        onPressed: producService.isSaving
        ? null
        : () async {
          
          if( !productFormu.isValidForm()) return;
          //si el producto no es valido que no continue

          final String? imageURL = await producService.uploadImage();

          //print( imageURL );

          if( imageURL != null ) productFormu.product.picture = imageURL;
          //guardando la imageURL que me esta devolviendo Cloudinary

          await producService.saveOrCreateProduct(productFormu.product);
          //Actualizando el Producto

        },
      ),
   );
  }
}

class _ProductForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final productformprovider = Provider.of<ProductFormProvider>(context);
    //obteniendo los valores del ProductFormProvider

    final productForm = productformprovider.product;
    //Obteniendo todas las propiedades del product

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        //height: 200,
        decoration: _BuildBoxDecoration(),
        child: Form(
          key: productformprovider.formkey,

          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                initialValue: productForm.name,
                onChanged: ( value ) => productForm.name = value,
                //( value ), es el valor que la persona escribe en el input
                //productForm.name = value, enviamos el valor que se escriba al NAME

                validator: (value){
                  if( value == null || value.length < 1 )
                  return 'El nombre es obligatorio';
                },

                decoration: InputDecorations.authInputDecorations(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre: '
                ),
              ),

              SizedBox(height: 10,),

              TextFormField(
                initialValue: '${productForm.price}',

                inputFormatters: [
                  //Sirve para darle formato al TextFormField

                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                  //dando Formato para solo pueda escribir numeros 
                ],

                onChanged: ( value ) => {
                  if( double.tryParse(value) == null ){
                    //Si esto es igua la nulo no se puede parsear
                    productForm.price = 0,
                    //Entonces por defecto sera 0
                  }else{
                    productForm.price = double.parse(value),
                    //Si no entonces guarda en el precio el VALOR ingresado
                  }
                },
                
                keyboardType: TextInputType.number,
                //Nos permite cuando el teclado a numerico
                decoration: InputDecorations.authInputDecorations(
                  hintText: '\$150',
                  labelText: 'Precio : '
                ),
              ),

              SizedBox(height: 10,),

              SwitchListTile.adaptive(
                //adaptive segun en que tipo de sistema este
                value: productForm.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productformprovider.updateAvalaibleAbility
                //el valor va a enviarse como primer argumento a este metodo
              ),

              
              SizedBox(height: 10,),
            ],
          )
        ),
    
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only( 
      bottomRight: Radius.circular(25),
      bottomLeft:  Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]


  );
}