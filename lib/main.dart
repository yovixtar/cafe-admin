import 'package:admin/Screen/Aunthentication/login.dart';
import 'package:admin/Screen/Aunthentication/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/Providers/add_to_cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:admin/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderItemProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'Sen',
          useMaterial3: true,
        ),
        home: FistScreen(),
      ),
    );
  }
}

class FistScreen extends StatefulWidget {
  const FistScreen({super.key});

  @override
  State<FistScreen> createState() => _FistScreenState();
}

class _FistScreenState extends State<FistScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              alignment: Alignment.topLeft,
              child: Image.asset(
                'images/Ellipse_1.png',
              ),
            ),
            Container(
              child: Image.asset(
                'images/Logo.png',
              ),
            ),
            const SizedBox(height: 50),
            Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: Text("MASUK",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(64, 0, 0, 0),
                              ),
                            ],
                          ),
                        )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum Punya Akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: primaryColor),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/Ellipse_2.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
