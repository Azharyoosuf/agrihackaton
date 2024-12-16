// auction_item.dart
class AuctionItem {
  String id;
  String title;
  String description;
  double startingPrice;
  double currentBid;
  List<Bid> bids;

  AuctionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startingPrice,
    this.currentBid = 0.0,
    this.bids = const [],
  });

  void addBid(Bid bid) {
    bids.add(bid);
    currentBid = bid.amount;
  }
}

class Bid {
  String bidderName;
  double amount;
  DateTime time;

  Bid({
    required this.bidderName,
    required this.amount,
    required this.time,
  });
}
