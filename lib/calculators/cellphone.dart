import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';
import 'package:insurance_pricer/widgets/textField.dart';


class CellphoneScreen extends StatefulWidget {
  const CellphoneScreen({super.key});

  @override
  State<CellphoneScreen> createState() => _CellphoneScreenState();
}

class _CellphoneScreenState extends State<CellphoneScreen> {
  final TextEditingController _phoneValueController = TextEditingController();
  final TextEditingController _planFeaturesController = TextEditingController();
  final TextEditingController _contractLengthController = TextEditingController();
  final TextEditingController _creditScoreController = TextEditingController();

  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? phoneValue = double.tryParse(_phoneValueController.text);
    final int? planFeatures = int.tryParse(_planFeaturesController.text);
    final int? contractLength = int.tryParse(_contractLengthController.text);
    final double? creditScore = double.tryParse(_creditScoreController.text);

    // Validation checks
    if (phoneValue == null || phoneValue <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for phone value.';
        _result = '';
      });
      return;
    }
    if (planFeatures == null || planFeatures < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative number of plan features.';
        _result = '';
      });
      return;
    }
    if (contractLength == null || contractLength <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive contract length.';
        _result = '';
      });
      return;
    }
    if (creditScore == null || creditScore < 0 || creditScore > 850) {
      setState(() {
        _errorMessage = 'Please enter a valid credit score (0-850).';
        _result = '';
      });
      return;
    }

    // Calculation
    try {
      final double premium = calculateCellphonePremium(phoneValue, planFeatures, contractLength, creditScore);
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

  double calculateCellphonePremium(double phoneValue, int planFeatures, int contractLength, double creditScore) {
    double basePremium = phoneValue * 0.13; // Base premium based on phone value
    double featurePremium = planFeatures * 5; // Additional fee per feature
    double contractAdjustment = (contractLength < 2) ? -10 : 10; // Adjust based on contract length
    double creditAdjustment = (creditScore > 700) ? -10 : 0; // Adjust based on credit score

    return basePremium + featurePremium + contractAdjustment + creditAdjustment;
  }

  void _generatePdf() {
    if (_result.isNotEmpty) {
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
                    buildTextField(_planFeaturesController, 'Number of Plan Features', Icons.featured_play_list, TextInputType.number),
                    buildTextField(_contractLengthController, 'Contract Length (years)', Icons.access_time, TextInputType.number),
                    buildTextField(_creditScoreController, 'Credit Score', Icons.credit_score, TextInputType.number),
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
