import 'package:balance_app/ui/input_decorations.dart';
import 'package:balance_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 250),
            SizedBox(
              width: double.infinity,
              child: Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 2,
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    _LoginForm()
                    // ChangeNotifierProvider(
                    //   create: ( _ ) => LoginFormProvider(),
                    //   child: _LoginForm()
                    // )
                  ])),
            )
          ]),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: const _CustomForm(),
    );
  }
}

class _CustomForm extends StatefulWidget {
  const _CustomForm({
    Key? key,
  }) : super(key: key);

  @override
  State<_CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<_CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      FocusScope.of(context).unfocus();
      setState(() {});
      final user = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      print(user.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, 'home');

      _formKey.currentState?.save();
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded),
            // onChanged: ( value ) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no luce como un correo';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
            // onChanged: ( value ) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Text(
                  _isLoading ? 'Loading...' : 'Send',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ))
          // Container(
          // height: 70,
          // width: double.infinity,
          // alignment: Alignment.center,
          // child: MaterialButton(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10)),
          //   disabledColor: Colors.grey,
          //   elevation: 0,
          //   color: Colors.deepPurple,
          //   child: _isLoading
          //       ? const SizedBox(
          //           width: 30,
          //           height: 30,
          //           child: CircularProgressIndicator(
          //             valueColor:
          //                 AlwaysStoppedAnimation<Color>(Colors.white),
          //           ),
          //         )
          //       : const Padding(
          //           padding:
          //               EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          //           child: Text(
          //             'Ingresar',
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //   onPressed: _isLoading ? null : _submit,
          // ))
        ],
      ),
    );
  }
}
