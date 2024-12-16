
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

class CoconutAuctionPage extends StatefulWidget {
  @override
  _CoconutAuctionPageState createState() => _CoconutAuctionPageState();
}

class _CoconutAuctionPageState extends State<CoconutAuctionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bidAmountController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Pick an image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  // Upload coconut details to Firebase
  Future<void> _uploadCoconut() async {
    if (_image == null) return;

    try {
      // Upload image to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('coconuts').child(DateTime.now().toString());
      await ref.putFile(File(_image!.path));

      final imageUrl = await ref.getDownloadURL();

      // Save coconut details to Firebase Database
      final databaseRef = FirebaseDatabase.instance.ref().child('coconuts').push();
      await databaseRef.set({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'bidAmount': _bidAmountController.text,
        'imageUrl': imageUrl,
      });

      // Reset fields
      setState(() {
        _image = null;
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _bidAmountController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coconut listed successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading coconut')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coconut Auction'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/list');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: _image == null
                    ? Center(child: Text('Tap to upload image'))
                    : Image.file(File(_image!.path), fit: BoxFit.cover),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _bidAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Bid Amount'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadCoconut,
              child: Text('List Coconut for Auction'),
            ),
          ],
        ),
      ),
    );
  }
}
