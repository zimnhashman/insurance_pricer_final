import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insurance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/motorVehicle': (context) => const MotorVehicleScreen(),
        '/homeownerProperty': (context) => const HomeownerPropertyScreen(),
        '/farm': (context) => const FarmScreen(),
        '/cellphone': (context) => const CellphoneScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insurance Calculator')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInsuranceButton(context, '/motorVehicle', Icons.directions_car, 'Motor Vehicle Insurance'),
              const SizedBox(height: 20),
              _buildInsuranceButton(context, '/homeownerProperty', Icons.home, 'Homeowner Insurance'),
              const SizedBox(height: 20),
              _buildInsuranceButton(context, '/farm', Icons.agriculture, 'Farm Insurance'),
              const SizedBox(height: 20),
              _buildInsuranceButton(context, '/cellphone', Icons.phone_android, 'Cellphone Insurance'),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildInsuranceButton(BuildContext context, String route, IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: Colors.white,
      ),
    );
  }
}

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

// Similar updates for HomeownerPropertyScreen, FarmScreen, and CellphoneScreen

// Homeowner Property Screen
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

// Farm Screen
class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  final TextEditingController _farmValueController = TextEditingController();
  final TextEditingController _livestockCountController = TextEditingController();
  String _result = '';
  String _errorMessage = '';
  List<String> _previousResults = [];

  void _calculatePremium() {
    final double? farmValue = double.tryParse(_farmValueController.text);
    final int? livestockCount = int.tryParse(_livestockCountController.text);

    if (farmValue == null || farmValue <= 0 || livestockCount == null || livestockCount < 0) {
      setState(() {
        _errorMessage = 'Please enter valid positive values for farm value and non-negative livestock count.';
        _result = '';
      });
      return;
    }

    try {
      final double premium = PremiumCalculator.calculateFarmPremium(farmValue, livestockCount);
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
                    _buildTextField(_farmValueController, 'Enter Farm Value', Icons.attach_money, TextInputType.number),
                    const SizedBox(height: 20),
                    _buildTextField(_livestockCountController, 'Enter Livestock Count', Icons.pets, TextInputType.number),
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
    );
  }
}

// Cellphone Screen
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
      final double premium = PremiumCalculator.calculateCellphonePremium(phoneValue);
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
                    _buildTextField(_phoneValueController, 'Enter Phone Value', Icons.phone, TextInputType.number),
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
    );
  }
}

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
