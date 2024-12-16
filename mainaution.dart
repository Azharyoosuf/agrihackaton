import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'coconut_auction_page.dart';
import 'coconut_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CoconutAuctionApp());
}

class CoconutAuctionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coconut Auction App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CoconutAuctionPage(),
        '/list': (context) => CoconutListPage(),
      },
    );
  }
}
