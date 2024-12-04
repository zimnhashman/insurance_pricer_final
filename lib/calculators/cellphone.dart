import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';
import 'package:insurance_pricer/widgets/textField.dart';
import 'package:printing/printing.dart';


class CellphoneScreen extends StatefulWidget {
  const CellphoneScreen({super.key});

  @override
  State<CellphoneScreen> createState() => _CellphoneScreenState();
}

class _CellphoneScreenState extends State<CellphoneScreen> {
  final TextEditingController _phoneValueController = TextEditingController();
  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? phoneValue = double.tryParse(_phoneValueController.text);

    if (phoneValue == null || phoneValue <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for phone value.';
        _result = '';
      });
      return;
    }

    try {
      final double premium = calculateCellphonePremium(phoneValue);
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

  double calculateCellphonePremium(double phoneValue) {
    return phoneValue * 0.13; // Your premium calculation logic
  }

  void _generatePdf() {
    if (_result.isNotEmpty) {
      // Extract the premium amount from the result
      double premiumValue = double.tryParse(_result.split('\$')[1]) ?? 0;
      PdfReport().generateReport('Cellphone Insurance', premiumValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cellphone Insurance')),
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
                    buildTextField(_phoneValueController, 'Enter Phone Value', Icons.phone, TextInputType.number),
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
}
