import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' show Printing;

class PdfReport {
  Future<void> generateReport(String insuranceType, double premium) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Insurance Quote', style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Insurance Type: $insuranceType', style: const pw.TextStyle(fontSize: 18)),
                pw.Text('Calculated Premium: \$${premium.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF and open it
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
