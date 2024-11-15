import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Ticket Booker',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedFrom;
  String? selectedTo;
  DateTime currentTime = DateTime.now();
  int count = 0;
  int total = 0;

  List<String> locations = ['Location 1', 'Location 2', 'Location 3'];

  @override
  void initState() {
    super.initState();
    // Update the current time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  void updateTotal() {
    setState(() {
      total = count * 50; // Assume each ticket costs $50
    });
  }

  // Function to save booking to Firestore
  void saveBooking(String paymentMethod) async {
    if (selectedFrom != null && selectedTo != null && count > 0) {
      CollectionReference bookings =
          FirebaseFirestore.instance.collection('bookings');

      try {
        await bookings.add({
          'from': selectedFrom,
          'to': selectedTo,
          'time': DateFormat('hh:mm a')
              .format(currentTime), // Store time as formatted string
          'quantity': count,
          'total_price': total,
          'payment_method': paymentMethod,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successful with $paymentMethod!')),
        );
      } catch (e) {
        print('Error saving booking: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save booking: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all details before proceeding')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a').format(currentTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Bus Ticket Booker', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From and To Dropdowns
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'From',
                      labelStyle: TextStyle(color: Color(0xFF4A6572)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedFrom,
                    items: locations
                        .where((location) => location != selectedTo)
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFrom = value;
                      });
                    },
                  ),
                ),
                Icon(Icons.swap_horiz_sharp, color: Colors.amber, size: 30.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'To',
                      labelStyle: TextStyle(color: Color(0xFF4A6572)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedTo,
                    items: locations
                        .where((location) => location != selectedFrom)
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTo = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Date and Time Display
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current Time: $formattedTime',
                style: TextStyle(fontSize: 16, color: Color(0xFF344955)),
              ),
            ),
            SizedBox(height: 20),
            // Counter Field
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Color(0xFFF9AA33)),
                  onPressed: () {
                    if (count > 0) {
                      setState(() {
                        count--;
                        updateTotal();
                      });
                    }
                  },
                ),
                Text(
                  '$count',
                  style: TextStyle(fontSize: 20, color: Color(0xFF344955)),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Color(0xFFF9AA33)),
                  onPressed: () {
                    setState(() {
                      count++;
                      updateTotal();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Total Field
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total: \$${total}',
                style: TextStyle(fontSize: 20, color: Color(0xFF344955)),
              ),
            ),
            SizedBox(height: 20),
            // Payment Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9AA33),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    saveBooking('online');
                  },
                  child: Text('Pay Online'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF344955),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    saveBooking('pay later');
                  },
                  child: Text('Pay Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
