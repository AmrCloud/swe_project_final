import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/services/auth_service.dart';
import 'package:sugarsense/core/services/consumed_food_service.dart';
import 'package:sugarsense/core/services/food_service.dart';

class FoodTrackerWidget extends StatefulWidget {
  const FoodTrackerWidget({super.key});

  @override
  _FoodTrackerWidgetState createState() => _FoodTrackerWidgetState();
}

class _FoodTrackerWidgetState extends State<FoodTrackerWidget> {
  late Future<List<dynamic>> _foodsFuture;
  late Future<List<dynamic>> _consumedFoodsFuture;
  final TextEditingController _gramsController = TextEditingController();
  int? _selectedFoodId;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    final foodService = Provider.of<FoodService>(context, listen: false);
    final consumedFoodService = Provider.of<ConsumedFoodService>(context, listen: false);
    
    setState(() {
      _foodsFuture = foodService.getAllFoods();
      _consumedFoodsFuture = consumedFoodService.getConsumedFoods();
    });
  }

  Future<void> _addFood() async {
    if (_selectedFoodId == null || _gramsController.text.isEmpty) return;

    final consumedFoodService = Provider.of<ConsumedFoodService>(context, listen: false);
    await consumedFoodService.addConsumedFood(
      _selectedFoodId!,
      double.parse(_gramsController.text),
    );
    
    _gramsController.clear();
    _refreshData();
  }

  Future<void> _updateFood(int consumedId, double grams) async {
    final consumedFoodService = Provider.of<ConsumedFoodService>(context, listen: false);
    await consumedFoodService.updateConsumedFood(consumedId, grams);
    _refreshData();
  }

  Future<void> _deleteFood(int consumedId) async {
    final consumedFoodService = Provider.of<ConsumedFoodService>(context, listen: false);
    await consumedFoodService.deleteConsumedFood(consumedId);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Food Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Add Consumed Food', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16),
                  FutureBuilder<List<dynamic>>(
                    future: _foodsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading foods');
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: 'Select Food'),
                        items: snapshot.data!.map((food) {
                          return DropdownMenuItem<int>(
                            value: food['food_id'],
                            child: Text(food['food_name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFoodId = value;
                          });
                        },
                      );
                    },
                  ),
                  TextFormField(
                    controller: _gramsController,
                    decoration: InputDecoration(labelText: 'Grams Consumed'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addFood,
                    child: Text('Add Food'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Consumed Foods List
          Text('Your Consumed Foods', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _consumedFoodsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading consumed foods'));
                }
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text('No foods consumed yet'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          item['Food']['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Icon(Icons.fastfood, size: 50),
                        ),
                        title: Text(item['Food']['food_name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['consumed_grams']}g'),
                            Text('${(item['consumed_grams'] * item['Food']['calories_per_gram']).toStringAsFixed(1)} calories'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditDialog(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteFood(item['consumed_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> item) {
  final gramsController = TextEditingController(text: item['consumed_grams'].toString());
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit ${item['Food']['food_name']}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: gramsController,
            decoration: InputDecoration(labelText: 'Grams'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (double.tryParse(value) == null) return 'Enter valid number';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newGrams = double.parse(gramsController.text);
                if (newGrams != item['consumed_grams']) {
                  await _updateFood(item['consumed_id'], newGrams);
                }
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }
}