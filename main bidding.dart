// In main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auction_provider.dart';  // Import AuctionProvider
import 'auction_screen.dart';    // Import AuctionScreen


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuctionProvider(),
      child: MaterialApp(
        title: 'KrishiMitra Auction',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuctionScreen(),
      ),
    );
  }
}
