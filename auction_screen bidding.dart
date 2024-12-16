import 'package:flutter/material.dart';
import 'auction_provider.dart';  // Import AuctionProvider for use in AuctionScreen
import 'dart:async'; // Import Dart's async library for Timer
import 'package:provider/provider.dart'; // Import this at the top of the file


class AuctionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('KrishiMitra Auction', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<AuctionProvider>(  // Consumer widget to listen to AuctionProvider
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.auctionItems.length,
            itemBuilder: (context, index) {
              final auctionItem = provider.auctionItems[index];
              return AuctionItemWidget(
                auctionItem: auctionItem,
                provider: provider,
              );
            },
          );
        },
      ),
    );
  }
}

class AuctionItemWidget extends StatefulWidget {
  final AuctionItem auctionItem;
  final AuctionProvider provider;

  AuctionItemWidget({required this.auctionItem, required this.provider});

  @override
  _AuctionItemWidgetState createState() => _AuctionItemWidgetState();
}

class _AuctionItemWidgetState extends State<AuctionItemWidget> {
  final TextEditingController bidController = TextEditingController();
  String bidderName = 'Demo User'; // Example bidder name
  double bidAmount = 0.0;
  bool isBidPlaced = false; // Track whether a bid has been placed
  Timer? auctionTimer;
  Duration timeLeft = Duration(minutes: 5); // Set default auction duration

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    auctionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds > 0) {
        setState(() {
          timeLeft = timeLeft - Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        handleAuctionEnd();
      }
    });
  }

  void handleAuctionEnd() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Auction for ${widget.auctionItem.title} has ended!'),
      backgroundColor: Colors.red[600],
    ));
    widget.provider.endAuction(widget.auctionItem.id);
  }

  @override
  void dispose() {
    auctionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.auctionItem.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.auctionItem.description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 10),
            Text(
              'Current Bid: ₹${widget.auctionItem.currentBid.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[600]),
            ),
            SizedBox(height: 10),
            Text(
              'Time Left: ${timeLeft.inMinutes}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: bidController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Bid',
                      labelStyle: TextStyle(color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green[700]!),
                      ),
                    ),
                    onChanged: (value) {
                      bidAmount = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: timeLeft.inSeconds > 0
                      ? () {
                    if (bidAmount > widget.auctionItem.currentBid) {
                      setState(() {
                        isBidPlaced = true;
                      });
                      widget.provider.placeBid(widget.auctionItem.id, bidderName, bidAmount);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Bid placed successfully!'),
                        backgroundColor: Colors.green[600],
                      ));
                    } else {
                      setState(() {
                        isBidPlaced = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Bid must be higher than current bid.'),
                        backgroundColor: Colors.red[600],
                      ));
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.send, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Place Bid', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            if (isBidPlaced) ...[
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8),
                child: Text(
                  'New Bid Placed! Current Bid: ₹${widget.auctionItem.currentBid.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AuctionProvider with ChangeNotifier {
  List<AuctionItem> auctionItems = [
    AuctionItem(id: 1, title: "Fresh Tomatoes", description: "High-quality fresh tomatoes", currentBid: 5.0),
    AuctionItem(id: 2, title: "Organic Apples", description: "Freshly picked organic apples", currentBid: 8.0),
    AuctionItem(id: 3, title: "Green Spinach", description: "Green, healthy spinach", currentBid: 3.5),
  ];

  void placeBid(int id, String bidderName, double bidAmount) {
    final auctionItem = auctionItems.firstWhere((item) => item.id == id);
    if (bidAmount > auctionItem.currentBid) {
      auctionItem.currentBid = bidAmount; // Update the bid amount
      notifyListeners(); // Notify listeners (UI) to rebuild
    }
  }

  void endAuction(int id) {
    auctionItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

class AuctionItem {
  final int id;
  final String title;
  final String description;
  double currentBid;

  AuctionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.currentBid,
  });
}
