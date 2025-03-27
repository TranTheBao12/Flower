import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/Invoice.dart';

class InvoiceAdminPage extends StatefulWidget {
  const InvoiceAdminPage({Key? key}) : super(key: key);

  @override
  _InvoiceAdminPageState createState() => _InvoiceAdminPageState();
}

class _InvoiceAdminPageState extends State<InvoiceAdminPage> {
  late Future<List<Invoice>> invoices;

  Future<List<Invoice>> fetchInvoices() async {
    final response = await http.get(Uri.parse('https://newyellowrock28.conveyor.cloud/api/Invoice'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)['\$values'];
      return jsonData.map((json) => Invoice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  @override
  void initState() {
    super.initState();
    invoices = fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Hóa Đơn'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: FutureBuilder<List<Invoice>>(
        future: invoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có hóa đơn nào'));
          } else {
            final invoiceList = snapshot.data!;
            return ListView.builder(
              itemCount: invoiceList.length,
              itemBuilder: (context, index) {
                final invoice = invoiceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      'Hóa Đơn ID: ${invoice.idinvoice}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Tổng tiền: ${invoice.totalAmount} VND',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ngày lập: ${invoice.billingDate}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          invoice.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        Text(
                          invoice.userEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
