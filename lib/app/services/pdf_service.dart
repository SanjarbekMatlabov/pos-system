import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfCheckService {
  static Future<Uint8List> generateCheck(
      Map<String, dynamic> sale, List<Map<String, dynamic>> items) async {
    final doc = pw.Document();
    final formatter = NumberFormat('#,###', 'uz_UZ');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Kassa apparati qog'ozi o'lchami
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Chek sarlavhasi
              pw.Center(
                  child: pw.Text("SMART POS",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16))),
              pw.Center(
                  child:
                      pw.Text("Xarid cheki", style: const pw.TextStyle(fontSize: 12))),
              pw.SizedBox(height: 20),

              // Chek ma'lumotlari
              pw.Text("Chek №: ${sale['id']}"),
              pw.Text(
                  "Sana: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(sale['date']))}"),
              
              // XATO TUZATILDI: Divider'ni Padding bilan o'radik
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Divider(),
              ),

              // Mahsulotlar jadvali
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(4),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3), // Nomi ustuni kengroq
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
                headers: ['Nomi', 'Miqdor', 'Narx', 'Summa'],
                data: items.map((item) {
                  final price = item['unit_price'];
                  final quantity = item['quantity'];
                  return [
                    item['product_name'],
                    quantity.toString(),
                    formatter.format(price),
                    formatter.format(price * quantity),
                  ];
                }).toList(),
              ),
              
              // XATO TUZATILDI: Divider'ni Padding bilan o'radik
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Divider(),
              ),

              // Jami summa
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Jami: ${formatter.format(sale['total_amount'])} so'm",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
              pw.SizedBox(height: 20),

              // Yakuniy matn
              // XATO TUZATILDI: `const` olib tashlandi
              pw.Center(
                  child: pw.Text("Xaridingiz uchun rahmat!",
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic))),
            ],
          );
        },
      ),
    );

    return doc.save();
  }
}