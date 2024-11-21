import 'package:flutter/material.dart';
import 'car_api_service.dart'; // Make sure you have the CarApiService implemented

class MotorVehicleScreen extends StatefulWidget {
  const MotorVehicleScreen({super.key});

  @override
  State<MotorVehicleScreen> createState() => _MotorVehicleScreenState();
}

class _MotorVehicleScreenState extends State<MotorVehicleScreen> {
  final TextEditingController _vehicleValueController = TextEditingController();
  final TextEditingController _driverAgeController = TextEditingController();
  String _result = '';
  String? _selectedModel;
  List<dynamic> _vehicleModels = [];
  final CarApiService apiService = CarApiService(
    apiToken: 'your_api_token', // Replace with your API token
    apiSecret: 'your_api_secret', // Replace with your API secret
  );

  @override
  void initState() {
    super.initState();
    _fetchVehicleModels();
  }

  Future<void> _fetchVehicleModels() async {
    try {
      var models = await apiService.fetchVehicleModels();
      setState(() {
        _vehicleModels = models;
      });
    } catch (e) {
      // Handle error (e.g., show a snackbar or dialog)
      print('Error fetching vehicle models: $e');
    }
  }

  void _calculatePremium() {
    final double? vehicleValue = double.tryParse(_vehicleValueController.text);
    final int? driverAge = int.tryParse(_driverAgeController.text);

    if (vehicleValue != null && driverAge != null && _selectedModel != null) {
      final double premium = PremiumCalculator.calculateMotorVehiclePremium(vehicleValue, driverAge);
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)} for $_selectedModel';
      });
    } else {
      setState(() {
        _result = 'Please enter valid values.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motor Vehicle Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedModel,
              hint: const Text('Select Vehicle Model'),
              items: _vehicleModels.map((model) {
                return DropdownMenuItem<String>(
                  value: model['name'], // Adjust based on the API response
                  child: Text(model['name']), // Adjust based on the API response
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _vehicleValueController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Vehicle Value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _driverAgeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Driver Age',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePremium,
              child: const Text('Calculate Premium'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumCalculator {
  static double calculateMotorVehiclePremium(double vehicleValue, int driverAge) {
    double basePremium = vehicleValue * 0.05;

    // Example logic to adjust premium based on driver age
    if (driverAge < 25) {
      basePremium *= 1.2; // Increase for young drivers
    } else if (driverAge > 65) {
      basePremium *= 1.15; // Slight increase for older drivers
    }

    // Additional calculations can be added here based on other factors

    return basePremium;
  }
}
