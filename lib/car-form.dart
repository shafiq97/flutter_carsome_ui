// car_form_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarFormPage extends StatefulWidget {
  const CarFormPage({super.key});

  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Prepare the data to send to the API
      Map<String, dynamic> carData = {
        'make': _makeController.text,
        'model': _modelController.text,
        'year': int.parse(_yearController.text),
        'price': double.parse(_priceController.text),
        'mileage': int.parse(_mileageController.text),
        'color': _colorController.text,
      };

      // Replace with your API endpoint
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/cars'),
        headers: {'Content-Type': 'application/json'},
        // send car data
        body: json.encode(carData),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        // Successfully added the car
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car added successfully')),
        );
        Navigator.pop(context, true); // Return to previous screen
      } else {
        // Failed to add the car
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add car')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controllers
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Car'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(50),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: InputDecoration(labelText: 'Make'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car make';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(labelText: 'Model'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car model';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(labelText: 'Year'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter a valid year';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mileageController,
                      decoration: InputDecoration(labelText: 'Mileage'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter a valid mileage';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _colorController,
                      decoration: InputDecoration(labelText: 'Color'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car color';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
