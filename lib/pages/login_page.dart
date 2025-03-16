import 'package:ecommerce/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _isLoading = false;
  bool _forLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_forLogin ? widget.title : 'Sign Up Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              _forLogin
                  ? SizedBox()
                  : TextFormField(
                    controller: _passwordConfirmController,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              // Implement login functionality
                              try {
                                if (_forLogin) {
                                  await Auth().logInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else {
                                  await Auth().createUserWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                // Handle error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${e.message}'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : Text(
                            _forLogin ? 'Login' : 'Sign Up',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                ),
              ),
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    _emailController.clear();
                    _passwordController.clear();
                    _passwordConfirmController.clear();
                    setState(() {
                      _forLogin = !_forLogin;
                    });
                  },
                  child: Text(
                    _forLogin
                        ? "Je n'ai pas encore de compte s'inscrire"
                        : "J'ai deja un compte se connecter",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
