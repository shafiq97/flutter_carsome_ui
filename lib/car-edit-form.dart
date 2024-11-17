import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car.dart';

class CarEditFormPage extends StatefulWidget {
  final Car car;

  const CarEditFormPage({super.key, required this.car});

  @override
  _CarEditFormPageState createState() => _CarEditFormPageState();
}

class _CarEditFormPageState extends State<CarEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;
  late TextEditingController _mileageController;
  late TextEditingController _colorController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing car data
    _makeController = TextEditingController(text: widget.car.make);
    _modelController = TextEditingController(text: widget.car.model);
    _yearController = TextEditingController(text: widget.car.year.toString());
    _priceController = TextEditingController(text: widget.car.price.toString());
    _mileageController =
        TextEditingController(text: widget.car.mileage.toString());
    _colorController = TextEditingController(text: widget.car.color);
  }

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
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/cars/${widget.car.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(carData),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Successfully updated the car
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car updated successfully')),
        );
        Navigator.pop(context, true); // Return to previous screen
      } else {
        // Failed to update the car
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update car')),
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
        title: const Text('Edit Car'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: const InputDecoration(labelText: 'Make'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car make';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car model';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Year'),
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
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      decoration: const InputDecoration(labelText: 'Mileage'),
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
                      decoration: const InputDecoration(labelText: 'Color'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car color';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
