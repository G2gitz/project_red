import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_red/assets/colors.dart';

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

  // Function to check if From and To locations are the same
  void _checkLocations() {
    if (_selectedFrom != null &&
        _selectedTo != null &&
        _selectedFrom == _selectedTo) {
      // Show SnackBar to alert the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: 'From' and 'To' locations cannot be the same!"),
        ),
      );
      // Reset the 'To' location if the same as 'From'
      setState(() {
        _selectedTo = null;
      });
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
    // Filter locations to exclude the selected 'From' location from the 'To' dropdown
    List<String> availableLocations = List.from(locations);
    if (_selectedFrom != null) {
      availableLocations.remove(_selectedFrom);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mysecondarycolor,
        title: Center(
            child: Text(
          "Dashboard",
          style: TextStyle(color: mytertiarycolor),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                }, locations),
                Icon(Icons.compare_arrows_outlined, size: 28),
                _buildDropdown("To", _selectedTo, (value) {
                  setState(() {
                    _selectedTo = value;
                  });
                  _checkLocations();
                }, availableLocations),
                _buildDateTimeField(),
              ],
            ),
            const SizedBox(height: 20),
            // Counter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCounterButton(
                    Icons.remove, Colors.red, _decrementCounter),
                    SizedBox(
                      width: 5,
                    ),
                _buildTextField("Counter", _myTextController),
                    SizedBox(
                      width: 5,
                    ),
                _buildCounterButton(Icons.add, Colors.green, _incrementCounter),
                  ],
                ),

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
      String label, String? value,
      ValueChanged<String?> onChanged, List<String> availableLocations) {
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
        value:
            value, // Default to the selected value or null if nothing is selected
        onChanged: (availableLocations.isNotEmpty)
            ? onChanged
            : null, // Ensure that the dropdown is enabled when there are options
        items: availableLocations.map((location) {
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
      width: 250.0,
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
