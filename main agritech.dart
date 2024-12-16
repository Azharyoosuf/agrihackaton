import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(FarmDirectApp());
}

class FarmDirectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiMitra',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.green[800],
              letterSpacing: 1.2), // More vibrant title
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87), // Body text with slight gray shade
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      supportedLocales: [Locale('en', 'US')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KrishiMitra – Empowering Farmers'),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor: Colors.green[700], // Darker shade for better contrast
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWidget(
              title: 'Easy Registration',
              content: RegistrationForm(),
            ),
            SectionWidget(
              title: 'Auction Platform',
              content: AuctionWidget(),
            ),
            SectionWidget(
              title: 'Market Price Updates',
              content: MarketPriceWidget(),
            ),
            SectionWidget(
              title: 'Negotiation Chatbot',
              content: ChatbotWidget(),
            ),
            SectionWidget(
              title: 'Navigation Support',
              content: NavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final Widget content;

  SectionWidget({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.green[50], // Light background for sections
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              content,
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField('Enter Name'),
        _buildTextField('Enter Email'),
        _buildTextField('Create Password', obscureText: true),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Registration Successful'),
                content: Text('Welcome to FarmDirect!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text('Register'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Consistent branding
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.green[800], // Button shadow for elevation
            elevation: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green[800]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
      ),
    );
  }
}

class AuctionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextContent('Place your produce for auction to get the best price.'),
        SizedBox(height: 10),
        _buildActionButton('Start Auction', Colors.orange, () {
          // Auction start logic
        }),
      ],
    );
  }

  Widget _buildTextContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.gavel),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.green.shade50,
      ),
    );
  }
}

// Repeating similar structure for MarketPriceWidget, ChatbotWidget, and NavigationWidget...



class MarketPriceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Current Market Prices for Crops',
          style: Theme.of(context).textTheme.bodyMedium, // Custom body text style
        ),
        SizedBox(height: 10),
        Text('Tomatoes: ₹30/kg'),
        Text('Potatoes: ₹20/kg'),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Refresh price logic
          },
          child: Text('Refresh Prices'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Button background color
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatbotWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Negotiation Chatbot',
          style: Theme.of(context).textTheme.bodyMedium, // Custom body text style
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Start chatbot conversation
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Chatbot Started'),
                content: Text('You can now chat with the bot for negotiations.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Start Chat'),
                  ),
                ],
              ),
            );
          },
          child: Text('Talk to Bot'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple, // Button background color
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
class NavigationWidget extends StatelessWidget {
  // Function to launch the Google Maps with a location or search query
  void _openGoogleMaps() async {
    final String googleMapsUrl = 'https://www.google.com/maps';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Find nearest buyers and delivery hubs',
          style: Theme.of(context).textTheme.bodyMedium, // Custom body text style
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Open Navigation logic
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Navigation Started'),
                content: Text('Locating nearest buyers and hubs...'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _openGoogleMaps(); // Launch Google Maps
                    },
                    child: Text('Go to Map'),
                  ),
                ],
              ),
            );
          },
          child: Text('Open Navigation'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Button background color
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
