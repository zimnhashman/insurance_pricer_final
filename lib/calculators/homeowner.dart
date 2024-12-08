import 'package:flutter/material.dart';
import 'package:insurance_pricer/services/pdf_report.dart';


class HomeownerPropertyScreen extends StatefulWidget {
  const HomeownerPropertyScreen({super.key});

  @override
  State<HomeownerPropertyScreen> createState() => _HomeownerPropertyScreenState();
}

class _HomeownerPropertyScreenState extends State<HomeownerPropertyScreen> {
  final TextEditingController _propertyValueController = TextEditingController();
  final TextEditingController _homeSizeController = TextEditingController();
  final TextEditingController _constructionMaterialController = TextEditingController();
  final TextEditingController _homeAgeController = TextEditingController();
  final TextEditingController _locationRiskController = TextEditingController();
  final TextEditingController _deductibleAmountController = TextEditingController();
  final TextEditingController _coverageLimitController = TextEditingController();
  final TextEditingController _claimsHistoryController = TextEditingController();
  final TextEditingController _securityFeaturesController = TextEditingController();

  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? propertyValue = double.tryParse(_propertyValueController.text);
    final double? homeSize = double.tryParse(_homeSizeController.text);
    final double? constructionMaterial = double.tryParse(_constructionMaterialController.text);
    final int? homeAge = int.tryParse(_homeAgeController.text);
    final double? locationRisk = double.tryParse(_locationRiskController.text);
    final double? deductibleAmount = double.tryParse(_deductibleAmountController.text);
    final double? coverageLimit = double.tryParse(_coverageLimitController.text);
    final int? claimsHistory = int.tryParse(_claimsHistoryController.text);
    final bool? securityFeatures = _securityFeaturesController.text.toLowerCase() == 'yes';

    // Validation checks
    if (propertyValue == null || propertyValue <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for property value.';
        _result = '';
      });
      return;
    }
    if (homeSize == null || homeSize <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for home size.';
        _result = '';
      });
      return;
    }
    if (constructionMaterial == null || constructionMaterial < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative value for construction materials.';
        _result = '';
      });
      return;
    }
    if (homeAge == null || homeAge < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative age for the home.';
        _result = '';
      });
      return;
    }
    if (locationRisk == null || locationRisk < 0 || locationRisk > 1) {
      setState(() {
        _errorMessage = 'Please enter a valid risk score (0 to 1).';
        _result = '';
      });
      return;
    }
    if (deductibleAmount == null || deductibleAmount < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid non-negative deductible amount.';
        _result = '';
      });
      return;
    }
    if (coverageLimit == null || coverageLimit <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid positive value for coverage limit.';
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
      final double premium = PremiumCalculator.calculateHomeownerPremium(
        propertyValue,
        homeSize,
        constructionMaterial,
        homeAge,
        locationRisk,
        deductibleAmount,
        coverageLimit,
        claimsHistory,
        securityFeatures ?? false,
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
      PdfReport().generateReport('Homeowner Insurance', premiumValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        _propertyValueController,
                        'Enter Property Value',
                        Icons.attach_money,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _homeSizeController,
                        'Enter Home Size (sq ft)',
                        Icons.home,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _constructionMaterialController,
                        'Enter Material Value',
                        Icons.build,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _homeAgeController,
                        'Enter Age of Home (years)',
                        Icons.access_time,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _locationRiskController,
                        'Enter Location Risk Score (0-1)',
                        Icons.location_on,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _deductibleAmountController,
                        'Enter Deductible Amount',
                        Icons.attach_money,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _coverageLimitController,
                        'Enter Coverage Limit',
                        Icons.attach_money,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _claimsHistoryController,
                        'Enter Number of Past Claims',
                        Icons.history,
                        TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _securityFeaturesController,
                        'Security Features (yes/no)',
                        Icons.security,
                        TextInputType.text,
                      ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generatePdf,
        backgroundColor: Colors.green,
        tooltip: 'Generate PDF Report',
        child: const Icon(Icons.picture_as_pdf),
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
  static double calculateHomeownerPremium(
      double propertyValue,
      double homeSize,
      double constructionMaterial,
      int homeAge,
      double locationRisk,
      double deductibleAmount,
      double coverageLimit,
      int claimsHistory,
      bool securityFeatures,
      ) {
    double basePremium = propertyValue * 0.02 + (locationRisk * 100);

    // Adjustments based on additional factors
    basePremium += homeSize * 0.01; // Larger homes increase premium
    basePremium -= constructionMaterial * 0.005; // Better materials can decrease premium
    basePremium += homeAge * 5; // Older homes increase premium
    basePremium -= (securityFeatures ? 50 : 0); // Security features can decrease premium
    basePremium -= deductibleAmount * 0.1; // Higher deductibles lower premium
    basePremium += claimsHistory * 20; // Past claims increase premium
    basePremium += coverageLimit * 0.01; // Higher coverage limits increase premium

    return basePremium;
  }
}
