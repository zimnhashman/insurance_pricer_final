import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';
import 'package:insurance_pricer/widgets/textField.dart';

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  final TextEditingController _farmValueController = TextEditingController();
  final TextEditingController _livestockCountController = TextEditingController();
  final TextEditingController _equipmentValueController = TextEditingController();
  final TextEditingController _structuresValueController = TextEditingController();
  final TextEditingController _acreageController = TextEditingController();

  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? farmValue = double.tryParse(_farmValueController.text);
    final int? livestockCount = int.tryParse(_livestockCountController.text);
    final double? equipmentValue = double.tryParse(_equipmentValueController.text);
    final double? structuresValue = double.tryParse(_structuresValueController.text);
    final double? acreage = double.tryParse(_acreageController.text);

    // Validation checks
    if (farmValue == null || farmValue <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for farm value.';
        _result = '';
      });
      return;
    }
    if (livestockCount == null || livestockCount < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative livestock count.';
        _result = '';
      });
      return;
    }
    if (equipmentValue == null || equipmentValue < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative value for equipment.';
        _result = '';
      });
      return;
    }
    if (structuresValue == null || structuresValue < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative value for farm structures.';
        _result = '';
      });
      return;
    }
    if (acreage == null || acreage <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive acreage value.';
        _result = '';
      });
      return;
    }

    // Calculation
    try {
      final double premium = PremiumCalculator.calculateFarmPremium(
        farmValue,
        livestockCount,
        equipmentValue,
        structuresValue,
        acreage,
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
      PdfReport().generateReport('Farm Insurance', premiumValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Insurance')),
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
                    buildTextField(_farmValueController, 'Enter Farm Value', Icons.attach_money, TextInputType.number),
                    const SizedBox(height: 20),
                    buildTextField(_livestockCountController, 'Enter Livestock Count', Icons.pets, TextInputType.number),
                    const SizedBox(height: 20),
                    buildTextField(_equipmentValueController, 'Enter Equipment Value', Icons.account_tree_sharp, TextInputType.number),
                    const SizedBox(height: 20),
                    buildTextField(_structuresValueController, 'Enter Structures Value', Icons.house, TextInputType.number),
                    const SizedBox(height: 20),
                    buildTextField(_acreageController, 'Enter Acreage', Icons.landscape, TextInputType.number),
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
}

// Premium Calculation Logic
class PremiumCalculator {
  static double calculateMotorVehiclePremium(double vehicleValue, int driverAge) {
    double basePremium = vehicleValue * 0.05;
    if (driverAge < 25) {
      basePremium *= 1.2; // Increase for young drivers
    }
    return basePremium;
  }

  static double calculateHomeownerPremium(double propertyValue, double locationRisk) {
    return propertyValue * 0.02 + (locationRisk * 100);
  }

  static double calculateFarmPremium(double farmValue, int livestockCount, double equipmentValue, double structuresValue, double acreage) {
    return (farmValue * 0.03) + (livestockCount * 50) + (equipmentValue * 0.01) + (structuresValue * 0.02) + (acreage * 10);
  }

}
