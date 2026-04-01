import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../models/stock_entry.dart';
import '../models/vendor.dart';
import '../models/transaction.dart';
import '../core/utils/app_utils.dart';

class ExportService {
  // ── CSV ──────────────────────────────────────────────────
  Future<String> exportStockToCsv(List<StockEntry> entries) async {
    final rows = [
      ['ID','Name','Category','Karat','Weight(g)','Price/g','Qty','Vendor','Type','Total Value','Date'],
      ...entries.map((e) => [
        e.id, e.name, e.category, e.karat, e.weightGrams, e.pricePerGram,
        e.quantity, e.vendorName, e.transactionType, e.totalValue,
        AppUtils.formatDate(e.createdAt),
      ]),
    ];
    return _saveCsv('stock_export', rows);
  }

  Future<String> exportVendorsToCsv(List<Vendor> vendors) async {
    final rows = [
      ['ID','Name','Phone','Email','Address','Credit','Debit','Balance'],
      ...vendors.map((v) => [
        v.id, v.name, v.phone, v.email ?? '', v.address ?? '',
        v.totalCredit, v.totalDebit, v.balance,
      ]),
    ];
    return _saveCsv('vendors_export', rows);
  }

  Future<String> exportTransactionsToCsv(List<Transaction> txs) async {
    final rows = [
      ['ID','Vendor','Type','Amount','Date','Payment Mode','Reference','Description'],
      ...txs.map((t) => [
        t.id, t.vendorName, t.type, t.amount,
        AppUtils.formatDate(t.date), t.paymentMode,
        t.referenceNumber ?? '', t.description ?? '',
      ]),
    ];
    return _saveCsv('transactions_export', rows);
  }

  Future<String> _saveCsv(String name, List<List<dynamic>> rows) async {
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/${name}_$ts.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  // ── PDF ──────────────────────────────────────────────────
  Future<String> exportStockToPdf(List<StockEntry> entries, String shopName) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(shopName,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text('Stock Report — ${AppUtils.formatDate(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 8),
            pw.Divider(),
          ],
        ),
        build: (ctx) => [
          pw.TableHelper.fromTextArray(
            headers: ['Name','Category','Karat','Weight','Qty','Vendor','Value'],
            data: entries.map((e) => [
              e.name, e.category, e.karat,
              '${e.weightGrams}g', '${e.quantity}',
              e.vendorName, AppUtils.formatCurrency(e.totalValue),
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellHeight: 24,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              6: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Total Value: ${AppUtils.formatCurrency(entries.fold(0.0, (s, e) => s + e.totalValue))}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
    return _savePdf('stock_report', pdf);
  }

  Future<String> exportTransactionsToPdf(List<Transaction> txs, String shopName) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(shopName,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text('Transaction Report — ${AppUtils.formatDate(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 8),
            pw.Divider(),
          ],
        ),
        build: (ctx) => [
          pw.TableHelper.fromTextArray(
            headers: ['Date','Vendor','Type','Amount','Mode'],
            data: txs.map((t) => [
              AppUtils.formatDate(t.date), t.vendorName,
              t.type.toUpperCase(), AppUtils.formatCurrency(t.amount),
              t.paymentMode,
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellHeight: 24,
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Credit: ${AppUtils.formatCurrency(txs.where((t) => t.isCredit).fold(0.0, (s, t) => s + t.amount))}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
              pw.Text(
                'Total Debit: ${AppUtils.formatCurrency(txs.where((t) => t.isDebit).fold(0.0, (s, t) => s + t.amount))}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
    return _savePdf('transaction_report', pdf);
  }

  Future<String> _savePdf(String name, pw.Document pdf) async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/${name}_$ts.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<void> shareFile(String path) async {
    await Share.shareXFiles([XFile(path)]);
  }
}
