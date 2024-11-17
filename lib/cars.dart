// main.dart

// pub.dev
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

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

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onEdit;

  const CarCard({super.key, required this.car, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(car.id.toString()),
      // Specify the direction of the slide
      direction: Axis.horizontal,
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onEdit();
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              onEdit();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          // You can add more actions here if needed
        ],
      ),
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${car.make} ${car.model}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text('Year: ${car.year}'),
              Text('Price: \$${car.price.toStringAsFixed(2)}'),
              Text('Mileage: ${car.mileage} miles'),
              Text('Color: ${car.color}'),
              Text('Listed on: ${car.createdAt}'),
            ],
          ),
        ),
      ),
    );
  }
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
