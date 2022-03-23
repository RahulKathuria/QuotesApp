import 'package:flutter/material.dart';
import 'package:quotesapp/HomePage.dart';

void main() {
  runApp( const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       home: HomeScreen(),
       
    );
   

  }
}
