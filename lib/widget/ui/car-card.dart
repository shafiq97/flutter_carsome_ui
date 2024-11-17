// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../car.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onEdit;
  final VoidCallback onDelete; // Add this line

  const CarCard({
    Key? key,
    required this.car,
    required this.onEdit,
    required this.onDelete, // Add this line
  }) : super(key: key);

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
          // Edit Action
          SlidableAction(
            onPressed: (context) {
              onEdit();
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          // Delete Action
          SlidableAction(
            onPressed: (context) {
              onDelete(); // Call the onDelete callback
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
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
