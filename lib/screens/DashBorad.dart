import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController _myTextController = TextEditingController();
  TextEditingController _myText2Controller = TextEditingController();
  int _counter = 0;

  final List<String> locations = ["Location A", "Location B", "Location C"];
  String? _selectedFrom;
  String? _selectedTo;
  String _currentDateTime =
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _updateTextFields();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateTextFields();
    });
  }

  void _decrementCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
        _updateTextFields();
      });
    }
  }

  void _updateTextFields() {
    _myTextController.text = _counter.toString();
    _myText2Controller.text = (_counter * 50).toString();
  }

  void _checkLocations() {
    if (_selectedFrom != null &&
        _selectedTo != null &&
        _selectedFrom == _selectedTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: 'From' and 'To' locations cannot be the same!"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _myTextController.dispose();
    _myText2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Location Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropdown("From", _selectedFrom, (value) {
                  setState(() {
                    _selectedFrom = value;
                  });
                  _checkLocations();
                }),
                Icon(Icons.compare_arrows_outlined, size: 28),
                _buildDropdown("To", _selectedTo, (value) {
                  setState(() {
                    _selectedTo = value;
                  });
                  _checkLocations();
                }),
                _buildDateTimeField(),
              ],
            ),
            const SizedBox(height: 20),
            // Counter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCounterButton(
                    Icons.remove, Colors.red, _decrementCounter),
                _buildTextField("Counter", _myTextController),
                _buildCounterButton(Icons.add, Colors.green, _incrementCounter),
                _buildTextField("Total", _myText2Controller),
              ],
            ),
            const SizedBox(height: 20),
            // Payment Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPaymentButton("Online Pay"),
                _buildPaymentButton("Manual Pay"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown field builder
  Widget _buildDropdown(
      String label, String? value, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 200.0,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        value: value,
        onChanged: onChanged,
        items: locations.map((location) {
          return DropdownMenuItem(
            value: location,
            child: Text(location),
          );
        }).toList(),
      ),
    );
  }

  // Date and Time field
  Widget _buildDateTimeField() {
    return SizedBox(
      width: 200.0,
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          labelText: "Date & Time",
          hintText: _currentDateTime,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  // Text field builder for counter and total
  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 120.0,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  // Counter button builder
  Widget _buildCounterButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  // Payment button builder
  Widget _buildPaymentButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
