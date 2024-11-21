import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/motorVehicle');
              },
              child: const Text('Motor Vehicle Insurance'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/homeownerProperty');
              },
              child: const Text('Homeowner Insurance'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/farm');
              },
              child: const Text('Farm Insurance'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cellphone');
              },
              child: const Text('Cellphone Insurance'),
            ),
          ],
        ),
      ),
    );
  }
}

// Motor Vehicle Insurance Screen
class MotorVehicleScreen extends StatefulWidget {
  const MotorVehicleScreen({super.key});

  @override
  State<MotorVehicleScreen> createState() => _MotorVehicleScreenState();
}

class _MotorVehicleScreenState extends State<MotorVehicleScreen> {
  final TextEditingController _vehicleValueController = TextEditingController();
  final TextEditingController _driverAgeController = TextEditingController();
  String _result = '';

  void _calculatePremium() {
    final double? vehicleValue = double.tryParse(_vehicleValueController.text);
    final int? driverAge = int.tryParse(_driverAgeController.text);

    if (vehicleValue != null && driverAge != null) {
      final double premium = PremiumCalculator.calculateMotorVehiclePremium(vehicleValue, driverAge);
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)}';
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

// Homeowner Insurance Screen
class HomeownerPropertyScreen extends StatefulWidget {
  const HomeownerPropertyScreen({super.key});

  @override
  State<HomeownerPropertyScreen> createState() => _HomeownerPropertyScreenState();
}

class _HomeownerPropertyScreenState extends State<HomeownerPropertyScreen> {
  final TextEditingController _propertyValueController = TextEditingController();
  final TextEditingController _locationRiskController = TextEditingController();
  String _result = '';

  void _calculatePremium() {
    final double? propertyValue = double.tryParse(_propertyValueController.text);
    final double? locationRisk = double.tryParse(_locationRiskController.text);

    if (propertyValue != null && locationRisk != null) {
      final double premium = PremiumCalculator.calculateHomeownerPremium(propertyValue, locationRisk);
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)}';
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
      appBar: AppBar(title: const Text('Homeowner Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _propertyValueController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Property Value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationRiskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Location Risk Score (0-1)',
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

// Farm Insurance Screen
class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  final TextEditingController _farmValueController = TextEditingController();
  final TextEditingController _livestockCountController = TextEditingController();
  String _result = '';

  void _calculatePremium() {
    final double? farmValue = double.tryParse(_farmValueController.text);
    final int? livestockCount = int.tryParse(_livestockCountController.text);

    if (farmValue != null && livestockCount != null) {
      final double premium = PremiumCalculator.calculateFarmPremium(farmValue, livestockCount);
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)}';
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
      appBar: AppBar(title: const Text('Farm Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _farmValueController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Farm Value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _livestockCountController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Number of Livestock',
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

// Cellphone Insurance Screen
class CellphoneScreen extends StatefulWidget {
  const CellphoneScreen({super.key});

  @override
  State<CellphoneScreen> createState() => _CellphoneScreenState();
}

class _CellphoneScreenState extends State<CellphoneScreen> {
  final TextEditingController _phoneValueController = TextEditingController();
  String _result = '';

  void _calculatePremium() {
    final double? phoneValue = double.tryParse(_phoneValueController.text);

    if (phoneValue != null) {
      final double premium = PremiumCalculator.calculateCellphonePremium(phoneValue);
      setState(() {
        _result = 'Calculated Premium: \$${premium.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _result = 'Please enter a valid value.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cellphone Insurance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneValueController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Phone Value',
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

// Premium Calculation Logic
class PremiumCalculator {
  static double calculateMotorVehiclePremium(double vehicleValue, int driverAge) {
    // Example calculation logic
    double basePremium = vehicleValue * 0.05;
    if (driverAge < 25) {
      basePremium *= 1.2; // Increase for young drivers
    }
    return basePremium;
  }

  static double calculateHomeownerPremium(double propertyValue, double locationRisk) {
    // Example calculation logic
    return propertyValue * 0.02 + (locationRisk * 100);
  }

  static double calculateFarmPremium(double farmValue, int livestockCount) {
    // Example calculation logic
    return farmValue * 0.03 + (livestockCount * 50);
  }

  static double calculateCellphonePremium(double phoneValue) {
    // Example calculation logic
    return phoneValue * 0.1;
  }
}
