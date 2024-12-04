import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';


class HomeownerPropertyScreen extends StatefulWidget {
  const HomeownerPropertyScreen({super.key});

  @override
  State<HomeownerPropertyScreen> createState() => _HomeownerPropertyScreenState();
}

class _HomeownerPropertyScreenState extends State<HomeownerPropertyScreen> {
  final TextEditingController _propertyValueController = TextEditingController();
  final TextEditingController _locationRiskController = TextEditingController();
  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? propertyValue = double.tryParse(_propertyValueController.text);
    final double? locationRisk = double.tryParse(_locationRiskController.text);

    if (propertyValue == null || propertyValue <= 0 || locationRisk == null || locationRisk < 0 || locationRisk > 1) {
      setState(() {
        _errorMessage = 'Please enter valid positive values for property value and risk (0-1).';
        _result = '';
      });
      return;
    }

    try {
      // Update the premium calculation method to match your logic
      final double premium = PremiumCalculator.calculateHomeownerPremium(propertyValue, locationRisk);
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
      PdfReport().generateReport('Homeowner Insurance', premiumValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner Insurance')),
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
                    _buildTextField(_propertyValueController, 'Enter Property Value', Icons.attach_money, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_locationRiskController, 'Enter Location Risk Score (0-1)', Icons.location_on, TextInputType.number),
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

  static double calculateFarmPremium(double farmValue, int livestockCount) {
    return farmValue * 0.03 + (livestockCount * 50);
  }

  static double calculateCellphonePremium(double phoneValue) {
    return phoneValue * 0.1;
  }
}
