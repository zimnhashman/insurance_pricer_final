import 'package:flutter/material.dart';
import 'package:insurance_pricer/calculators/farm.dart';
import 'package:insurance_pricer/services/pdf_report.dart'; // Ensure this path is correct
import 'package:printing/printing.dart';

class MotorVehicleScreen extends StatefulWidget {
  const MotorVehicleScreen({super.key});

  @override
  State<MotorVehicleScreen> createState() => _MotorVehicleScreenState();
}

class _MotorVehicleScreenState extends State<MotorVehicleScreen> {
  final TextEditingController _vehicleValueController = TextEditingController();
  final TextEditingController _driverAgeController = TextEditingController();
  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? vehicleValue = double.tryParse(_vehicleValueController.text);
    final int? driverAge = int.tryParse(_driverAgeController.text);

    if (vehicleValue == null || vehicleValue <= 0 || driverAge == null || driverAge < 0) {
      setState(() {
        _errorMessage = 'Please enter valid positive values for vehicle value and non-negative age.';
        _result = '';
      });
      return;
    }

    try {
      final double premium = PremiumCalculator.calculateMotorVehiclePremium(vehicleValue, driverAge);
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
      // Extract the premium amount from the result
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
                      onPressed: _generatePdf, // Call PDF generation
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
