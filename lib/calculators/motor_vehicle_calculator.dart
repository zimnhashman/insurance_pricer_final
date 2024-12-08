import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';

class MotorVehicleScreen extends StatefulWidget {
  const MotorVehicleScreen({super.key});

  @override
  State<MotorVehicleScreen> createState() => _MotorVehicleScreenState();
}

class _MotorVehicleScreenState extends State<MotorVehicleScreen> {
  final TextEditingController _vehicleValueController = TextEditingController();
  final TextEditingController _driverAgeController = TextEditingController();
  final TextEditingController _vehicleAgeController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _drivingExperienceController = TextEditingController();
  final TextEditingController _claimsHistoryController = TextEditingController();
  final TextEditingController _safetyFeaturesController = TextEditingController();

  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? vehicleValue = double.tryParse(_vehicleValueController.text);
    final int? driverAge = int.tryParse(_driverAgeController.text);
    final int? vehicleAge = int.tryParse(_vehicleAgeController.text);
    final String vehicleType = _vehicleTypeController.text.trim();
    final int? mileage = int.tryParse(_mileageController.text);
    final int? drivingExperience = int.tryParse(_drivingExperienceController.text);
    final int? claimsHistory = int.tryParse(_claimsHistoryController.text);
    final bool? safetyFeatures = _safetyFeaturesController.text.toLowerCase() == 'yes';

    // Validation checks
    if (vehicleValue == null || vehicleValue <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for vehicle value.';
        _result = '';
      });
      return;
    }
    if (driverAge == null || driverAge < 16) {
      setState(() {
        _errorMessage = 'Please enter a valid age (16 or older) for the driver.';
        _result = '';
      });
      return;
    }
    if (vehicleAge == null || vehicleAge < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative age for the vehicle.';
        _result = '';
      });
      return;
    }
    if (mileage == null || mileage < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative mileage.';
        _result = '';
      });
      return;
    }
    if (drivingExperience == null || drivingExperience < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative value for driving experience.';
        _result = '';
      });
      return;
    }
    if (claimsHistory == null || claimsHistory < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative value for claims history.';
        _result = '';
      });
      return;
    }

    // Calculation
    try {
      final double premium = PremiumCalculator.calculateMotorVehiclePremium(
        vehicleValue,
        driverAge,
        vehicleAge,
        vehicleType,
        mileage,
        drivingExperience,
        claimsHistory,
        safetyFeatures ?? false,
      );
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)}';
        _previousResults.add(_result);
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during calculation.';
      });
    }
  }

  void _generatePdf() {
    if (_result.isNotEmpty) {
      double premiumValue = double.tryParse(_result.split('\$')[1]) ?? 0;
      PdfReport().generateReport('Motor Vehicle Insurance', premiumValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motor Vehicle Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(_vehicleValueController, 'Enter Vehicle Value', Icons.attach_money, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_driverAgeController, 'Enter Driver Age', Icons.person, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_vehicleAgeController, 'Enter Vehicle Age', Icons.calendar_today, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_vehicleTypeController, 'Enter Vehicle Type (e.g., SUV, Sedan)', Icons.directions_car, TextInputType.text),
                    const SizedBox(height: 20),
                    _buildTextField(_mileageController, 'Enter Annual Mileage', Icons.speed, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_drivingExperienceController, 'Enter Driving Experience (years)', Icons.access_time, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_claimsHistoryController, 'Enter Number of Past Claims', Icons.history, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_safetyFeaturesController, 'Safety Features (yes/no)', Icons.security, TextInputType.text),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculatePremium,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue.shade600,
                      ),
                      child: const Text('Calculate Premium', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)),
                    if (_result.isNotEmpty)
                      Text(_result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _generatePdf,
                      child: const Text('Generate PDF Report'),
                    ),
                    const SizedBox(height: 20),
                    if (_previousResults.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Previous Results:', style: TextStyle(fontSize: 16)),
                          ..._previousResults.map((result) => Text(result)).toList(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: type,
    );
  }
}

// Premium Calculation Logic
class PremiumCalculator {
  static double calculateMotorVehiclePremium(
      double vehicleValue,
      int driverAge,
      int vehicleAge,
      String vehicleType,
      int mileage,
      int drivingExperience,
      int claimsHistory,
      bool safetyFeatures,
      ) {
    double basePremium = vehicleValue * 0.05; // Base premium based on vehicle value

    // Adjustments based on additional factors
    if (driverAge < 25) {
      basePremium *= 1.2; // Increase for younger drivers
    }
    if (vehicleAge > 10) {
      basePremium *= 1.1; // Increase for older vehicles
    }
    if (mileage > 15000) {
      basePremium += (mileage - 15000) * 0.01; // Increase for high mileage
    }
    if (drivingExperience < 2) {
      basePremium *= 1.15; // Increase for less experienced drivers
    }
    basePremium += claimsHistory * 50; // Increase for past claims
    if (safetyFeatures) {
      basePremium -= 100; // Decrease for safety features
    }

    return basePremium;
  }
}
