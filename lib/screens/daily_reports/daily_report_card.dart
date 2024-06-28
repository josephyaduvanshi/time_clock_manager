import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:time_clock_manager/models/daily_report_model.dart';

class ReportCard extends StatefulWidget {
  final DailyReportModel report;

  const ReportCard({
    required this.report,
    Key? key,
  }) : super(key: key);

  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _isExpanded = false;

  String get formattedDate {
    final now = DateTime.now();
    if (widget.report.reportDate.year == now.year &&
        widget.report.reportDate.month == now.month &&
        widget.report.reportDate.day == now.day) {
      return "Today";
    } else if (widget.report.reportDate.year == now.year &&
        widget.report.reportDate.month == now.month &&
        widget.report.reportDate.day == now.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat('dd MMMM, yyyy').format(widget.report.reportDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(formattedDate,
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: !_isExpanded
                ? Text(
                    "Gross: \$${_formatAmount(widget.report.grossSales)} | Net: \$${_formatAmount(widget.report.netSales)}")
                : null,
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalRow("Delivery", widget.report.delivery),
                  _buildTotalRow("Shop", widget.report.shop),
                  _buildTotalRow("Pickup", widget.report.pickup),
                  Divider(),
                  Text("Online Order Sources",
                      style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8.0,
                    children:
                        widget.report.onlineOrderSources.entries.map((entry) {
                      return Chip(
                        color: entry.key == "Manoosh Online"
                            ? MaterialStateProperty.all(Colors.green)
                            : entry.key == "DoorDash"
                                ? MaterialStateProperty.all(Colors.pink)
                                : entry.key == "Menulog"
                                    ? MaterialStateProperty.all(
                                        const Color.fromARGB(255, 255, 143, 7))
                                    : MaterialStateProperty.all(Colors.teal),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromRGBO(77, 77, 205, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Column(
                          children: [
                            Text(
                              "${entry.key}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${entry.value[0]} orders",
                              style: TextStyle(fontSize: 12),
                            ).py(3),
                            Text(
                              "\$${_formatAmount(entry.value[1])}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ).py(8);
                    }).toList(),
                  ).py(8),
                  Divider(),
                  _buildTotalRow("Gross Sales", widget.report.grossSales),
                  _buildTotalRow("Net Sales", widget.report.netSales),
                  _buildTotalRow("GST", widget.report.gst),
                  Divider(),
                  Text("In-Store Payments",
                      style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8.0,
                    children:
                        widget.report.instorePayments.entries.map((entry) {
                      return Chip(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromRGBO(77, 77, 205, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Column(
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "\$${_formatAmount(entry.value)}",
                              style: TextStyle(fontSize: 12),
                            ).py(3),
                          ],
                        ),
                      ).py(8);
                    }).toList(),
                  ).py(8),
                  Divider(),
                  Text("All Day Order Overview",
                      style: Theme.of(context).textTheme.titleMedium),
                  Wrap(
                    spacing: 8.0,
                    children:
                        widget.report.allDayOrderOverview.entries.map((entry) {
                      return Chip(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromRGBO(77, 77, 205, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Column(
                          children: [
                            Text(
                              "${entry.key}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${entry.value[0]} orders",
                              style: TextStyle(fontSize: 12),
                            ).py(3),
                            Text(
                              "Avg \$${_formatAmount(entry.value[1])}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ).py(8);
                    }).toList(),
                  ).py(8),
                  Divider(),
                  _buildTotalRow(
                      "New Customers", widget.report.newCustomers.toDouble()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          "\$${_formatAmount(value)}".text.lg.medium.make(),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(amount);
  }
}
