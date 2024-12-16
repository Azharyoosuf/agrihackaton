import 'package:flutter/material.dart';

class AuctionItem {
  final int id;
  final String title;
  final String description;
  double currentBid;
  final int duration; // Duration in hours
  final DateTime endTime; // Auction end time

  AuctionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.currentBid,
    required this.duration,
    required this.endTime,
  });

  bool get isAuctionActive {
    return DateTime.now().isBefore(endTime);
  }
}

class AuctionProvider with ChangeNotifier {
  List<AuctionItem> auctionItems = [];

  AuctionProvider() {
    _initializeAuctionItems();
  }

  void _initializeAuctionItems() {
    auctionItems = [
      AuctionItem(
        id: 1,
        title: "Fresh Tomatoes",
        description: "High-quality fresh tomatoes",
        currentBid: 5.0,
        duration: 24,
        endTime: DateTime.now().add(Duration(hours: 24)),
      ),
      AuctionItem(
        id: 2,
        title: "Organic Apples",
        description: "Freshly picked organic apples",
        currentBid: 8.0,
        duration: 12,
        endTime: DateTime.now().add(Duration(hours: 12)),
      ),
    ];
  }

  void placeBid(int id, String bidderName, double bidAmount) {
    final auctionItem = auctionItems.firstWhere((item) => item.id == id);
    if (auctionItem.isAuctionActive && bidAmount > auctionItem.currentBid) {
      auctionItem.currentBid = bidAmount;
      notifyListeners();
    }
  }
}
