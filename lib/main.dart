import 'package:flutter/material.dart';
import 'package:insurance_pricer/calculators/cellphone.dart';
import 'package:insurance_pricer/calculators/farm.dart';
import 'package:insurance_pricer/calculators/homeowner.dart';
import 'package:insurance_pricer/calculators/motor_vehicle_calculator.dart';

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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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

  static double calculateFarmPremium(double farmValue, int livestockCount) {
    return farmValue * 0.03 + (livestockCount * 50);
  }

  static double calculateCellphonePremium(double phoneValue) {
    return phoneValue * 0.1;
  }
}
