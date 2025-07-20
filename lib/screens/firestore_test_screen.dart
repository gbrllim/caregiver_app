import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreTestScreen extends StatefulWidget {
  const FirestoreTestScreen({super.key});

  @override
  State<FirestoreTestScreen> createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _status = 'Testing Firestore connection...';

  @override
  void initState() {
    super.initState();
    _testFirestore();
  }

  Future<void> _testFirestore() async {
    try {
      setState(() {
        _status = 'Testing Firestore connection...';
      });

      // Check if user is authenticated
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _status = 'Error: User not authenticated';
        });
        return;
      }

      // Try to write a test document
      await _firestore.collection('test').doc('test').set({
        'message': 'Hello Firestore!',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      // Try to read the test document
      DocumentSnapshot doc = await _firestore.collection('test').doc('test').get();
      
      if (doc.exists) {
        setState(() {
          _status = 'Success! Firestore is working properly.\nData: ${doc.data()}';
        });
      } else {
        setState(() {
          _status = 'Error: Could not read test document';
        });
      }

      // Clean up test document
      await _firestore.collection('test').doc('test').delete();

    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firestore Connection Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testFirestore,
              child: const Text('Test Again'),
            ),
          ],
        ),
      ),
    );
  }
}
