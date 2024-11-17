// main.dart

// pub.dev
import 'dart:developer';
import 'package:carsome/widget/ui/car-card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// local
import 'car-form.dart';
import 'car-edit-form.dart'; // Import the edit form page
import 'car.dart';

class CarsList extends StatelessWidget {
  const CarsList({super.key});

  // Root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Listings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const CarListPage(title: 'Car Listings'),
    );
  }
}

class CarListPage extends StatefulWidget {
  const CarListPage({super.key, required this.title});

  final String title;

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late Future<List<Car>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
    log("Got here");
  }

  Future<List<Car>> fetchCars() async {
    // Replace with your API endpoint
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/cars'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((car) => Car.fromJson(car)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }

  void _goToCarInsertPage() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CarFormPage()),
    );

    if (result == true) {
      // If a new car was added, refresh the car list
      setState(() {
        futureCars = fetchCars();
      });
    }
  }

  void _deleteCar(int carId) async {
    bool confirm = await _showConfirmationDialog();
    if (confirm) {
      // Send DELETE request to the API
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/cars/$carId'),
      );

      if (response.statusCode == 200) {
        // Successfully deleted the car
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car deleted successfully')),
        );
        setState(() {
          futureCars = fetchCars();
        });
      } else {
        // Failed to delete the car
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete car')),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this car?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false; // If the dialog is dismissed, return false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added Drawer (from your previous request)
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCarInsertPage,
        tooltip: 'Add Car',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            // Drawer Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Close the drawer and navigate to Home
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Close the drawer and navigate to Settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Toyyib Pay'),
              onTap: () {
                // Close the drawer and navigate to Toyyib Pay
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Car>>(
        future: futureCars,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Car> cars = snapshot.data!;
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return CarCard(
                  car: cars[index],
                  onEdit: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarEditFormPage(car: cars[index]),
                      ),
                    );

                    if (result == true) {
                      // If a car was edited, refresh the car list
                      setState(() {
                        futureCars = fetchCars();
                      });
                    }
                  },
                  onDelete: () {
                    _deleteCar(cars[index].id);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          // By default, show a loading spinner
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
