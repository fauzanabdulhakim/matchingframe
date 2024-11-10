import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'my_page.dart'; // Ganti dengan import halaman MyPage yang sesuai

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/myPage': (context) => MyPage(), // Daftarkan route untuk MyPage
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMyPage(); // Navigasi ke MyPage setelah beberapa detik
  }

  // Navigasi ke MyPage setelah beberapa detik
  Future<void> _navigateToMyPage() async {
    await Future.delayed(Duration(seconds: 5)); // Ubah sesuai keinginan Anda
    Navigator.of(context).pushReplacementNamed('/myPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
              'assets/animasi_car.json', // Ganti dengan path animasi Lottie Anda
              //width: 250,
              //height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              'Matching Frame',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
