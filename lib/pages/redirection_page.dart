import 'package:ecommerce/pages/home_page.dart';
import 'package:ecommerce/pages/login_page.dart';
import 'package:ecommerce/services/firebase/auth.dart';
import 'package:flutter/material.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const MyHomePage(title: 'Home Page');
        } else if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error occurred')));
        } else {
          return LoginPage(title: 'Login Page');
        }
      },
    );
  }
}
