import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CoconutListPage extends StatefulWidget {
  @override
  _CoconutListPageState createState() => _CoconutListPageState();
}

class _CoconutListPageState extends State<CoconutListPage> {
  late DatabaseReference _coconutsRef;
  late Stream<DatabaseEvent> _coconutsStream;

  @override
  void initState() {
    super.initState();
    _coconutsRef = FirebaseDatabase.instance.ref().child('coconuts');
    _coconutsStream = _coconutsRef.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auction Listings')),
      body: StreamBuilder<DatabaseEvent>(
        stream: _coconutsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map;
            final List<Widget> coconutWidgets = [];

            data.forEach((key, value) {
              final coconut = value as Map;
              coconutWidgets.add(ListTile(
                title: Text(coconut['title']),
                subtitle: Text('Price: \$${coconut['price']}'),
                trailing: Image.network(coconut['imageUrl'], width: 50, height: 50),
              ));
            });

            return ListView(children: coconutWidgets);
          }

          return Center(child: Text('No coconuts listed'));
        },
      ),
    );
  }
}
