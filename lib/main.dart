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
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/motorVehicle');
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Motor Vehicle Insurance'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/homeownerProperty');
                },
                icon: const Icon(Icons.home),
                label: const Text('Homeowner Insurance'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/farm');
                },
                icon: const Icon(Icons.agriculture),
                label: const Text('Farm Insurance'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/cellphone');
                },
                icon: const Icon(Icons.phone_android),
                label: const Text('Cellphone Insurance'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
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
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _vehicleValueController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Vehicle Value',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _driverAgeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Driver Age',
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculatePremium,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue.shade600,
                      ),
                      child: const Text('Calculate Premium'),
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty)
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _propertyValueController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Property Value',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _locationRiskController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Location Risk Score (0-1)',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculatePremium,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue.shade600,
                      ),
                      child: const Text('Calculate Premium'),
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty)
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _farmValueController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Farm Value',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _livestockCountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Livestock Count',
                        prefixIcon: Icon(Icons.pets),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculatePremium,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue.shade600,
                      ),
                      child: const Text('Calculate Premium'),
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty)
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _phoneValueController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Phone Value',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculatePremium,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                       backgroundColor: Colors.blue.shade600,
                      ),
                      child: const Text('Calculate Premium'),
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty)
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
