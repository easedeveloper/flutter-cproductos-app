import 'package:flutter/material.dart';
import 'package:productos_app/providers/loginFormProvider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250,),

              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),
                    //Text('Formulario'),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),


                  ],
                )
              ),

              SizedBox(height: 50,),
              Text('Crear una nueva Cuenta', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),),
              SizedBox(height: 50,),

            ],
          ),
        )
        // Container(
        //   width: double.infinity,
        //   height: 300,
        //   color: Colors.red,
        // ),
      ),
   );
  }
}

class _LoginForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);
    //ahora esta vairable tiene acceso a las variables de loginFormProvider

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //mostrara el mensaje de cada TextFormField -> validator

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecorations(
                hintText: 'Yui@gmail.com',
                labelText: 'Correo Electronico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: (value) => loginForm.email = value,
              //Validando el value que reciba el email

              validator: ( value ){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no luce como un correo';

                      //toma la regExp y verifica si son iguales con value
              },
            ),
            SizedBox(height: 30,),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecorations(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline_rounded
              ),
              onChanged: (value) => loginForm.password = value,
              //Validando el value que reciba el password

              validator: ( value ){
                
                return ( value != null && value.length >= 6 )
                  ? null
                  : 'La contraseña debe ser mayor a 6 caracteres';
              },
            ),
            SizedBox(height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.getIsLoading
                    ? 'Espere...'
                    : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.getIsLoading? null : () async{
                  //loginForm.getIsLoading? null : aqui deshabilito el boton cuando ya esta logeado y no se puede hacer click

                  FocusScope.of(context).unfocus();
                  //Quitando el teclado cuando se precione el Botton de Ingresar

                if(!loginForm.isValidationForm()) return;
                //validando con el botom el formulario

                loginForm.setIsLoading = true;

                await Future.delayed(Duration( seconds: 2 ));
                //Se espera 2 segundos para que ingrese a la siguiente pagina

                loginForm.setIsLoading = false;

                Navigator.pushReplacementNamed(context, 'homeScreen');
              }
            )


          ],
        )
      ),  
    );
  }
}