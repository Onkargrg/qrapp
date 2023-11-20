import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class AddProductsPage extends StatelessWidget {
  static const String id = 'add_products_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddProductsForm(),
      ),
    );
  }
}

class AddProductsForm extends StatefulWidget {
  @override
  _AddProductsFormState createState() => _AddProductsFormState();
}

class _AddProductsFormState extends State<AddProductsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _currentPriceController = TextEditingController();
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _pidController,
            decoration: InputDecoration(
              labelText: 'Product ID',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            keyboardType: TextInputType.text, // Changed to text
            style: const TextStyle(color: Colors.black),
            enabled: false, // Disable editing
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Product ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666',
                'Cancel',
                true,
                ScanMode.QR,
              );

              if (barcodeScanRes != '-1') {
                setState(() {
                  _isScanned = true;
                  _pidController.text = barcodeScanRes;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(12),
            ),
            child: const Text(
              'Scan QR Code',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Product Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _mrpController,
            decoration: InputDecoration(
              labelText: 'MRP',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter MRP';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _currentPriceController,
            decoration: InputDecoration(
              labelText: 'Current Price',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Current Price';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                await submitForm();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  // pending work
  Future<void> submitForm() async {
    try {
      // Prepare data to be sent to the API
      final postData = {
        "pid": _pidController.text,
        "name": _nameController.text,
        "mrp": int.parse(_mrpController.text).toString(), // Convert double to string
        "currprice": int.parse(_currentPriceController.text).toString(), // Convert double to string
      };

      // Make a POST request to the backend API
      const apiUrl = 'https://shivam.techfestsliet.org/api/addproduct';
      final response = await http.post(
        Uri.parse(apiUrl),
        body: postData,
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Product added successfully!');
        // Provide feedback to the user (you can navigate to another screen or show a snack-bar)
        showSuccessMessage();
      } else {
        // Handle error
        print('Failed to add product. Status code: ${response.statusCode}');
        // Provide feedback to the user (show an error message)
        showErrorMessage();
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      // Provide feedback to the user (show an error message)
      showErrorMessage();
    }
  }

  void showSuccessMessage() {
    // Implement displaying a success message to the user (e.g., using a snackbar)
  }

  void showErrorMessage() {
    // Implement displaying an error message to the user (e.g., using a snackbar)
  }
}
