import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_clock_manager/models/daily_report_model.dart';
import '../../controllers/daily_reports_controller.dart';

class DailyReportDialog extends StatelessWidget {
  final DailyReportsController controller;

  DailyReportDialog({required this.controller, Key? key}) : super(key: key);

  final deliveryController = TextEditingController();
  final shopController = TextEditingController();
  final pickupController = TextEditingController();
  final manooshOnlineCountController = TextEditingController();
  final manooshOnlineAmountController = TextEditingController();
  final doorDashCountController = TextEditingController();
  final doorDashAmountController = TextEditingController();
  final menulogCountController = TextEditingController();
  final menulogAmountController = TextEditingController();
  final ubereatsCountController = TextEditingController();
  final ubereatsAmountController = TextEditingController();
  final grossSalesController = TextEditingController();
  final netSalesController = TextEditingController();
  final gstController = TextEditingController();
  final cashController = TextEditingController();
  final mobileEftposController = TextEditingController();
  final pceftposController = TextEditingController();
  final paidOnlineController = TextEditingController();
  final deliveryOrdersController = TextEditingController();
  final deliveryAverageController = TextEditingController();
  final shopOrdersController = TextEditingController();
  final shopAverageController = TextEditingController();
  final pickupOrdersController = TextEditingController();
  final pickupAverageController = TextEditingController();
  final totalOrdersController = TextEditingController();
  final totalAverageController = TextEditingController();
  final newCustomersController = TextEditingController();
  final selectedStore = Store.GREENWAY.obs;
  final selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Daily Report",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildTextField(deliveryController, "Delivery Total"),
              _buildTextField(shopController, "Shop Total"),
              _buildTextField(pickupController, "Pickup Total"),
              _buildTextField(
                  manooshOnlineCountController, "Manoosh Online Count"),
              _buildTextField(
                  manooshOnlineAmountController, "Manoosh Online Amount"),
              _buildTextField(doorDashCountController, "DoorDash Count"),
              _buildTextField(doorDashAmountController, "DoorDash Amount"),
              _buildTextField(menulogCountController, "Menulog Count"),
              _buildTextField(menulogAmountController, "Menulog Amount"),
              _buildTextField(ubereatsCountController, "Ubereats Count"),
              _buildTextField(ubereatsAmountController, "Ubereats Amount"),
              _buildTextField(grossSalesController, "Gross Sales"),
              _buildTextField(netSalesController, "Net Sales"),
              _buildTextField(gstController, "GST"),
              _buildTextField(cashController, "Cash Payment"),
              _buildTextField(mobileEftposController, "Mobile Eftpos Payment"),
              _buildTextField(pceftposController, "Pceftpos Payment"),
              _buildTextField(paidOnlineController, "Paid Online Payment"),
              _buildTextField(deliveryOrdersController, "Delivery Orders"),
              _buildTextField(deliveryAverageController, "Delivery Average"),
              _buildTextField(shopOrdersController, "Shop Orders"),
              _buildTextField(shopAverageController, "Shop Average"),
              _buildTextField(pickupOrdersController, "Pickup Orders"),
              _buildTextField(pickupAverageController, "Pickup Average"),
              _buildTextField(totalOrdersController, "Total Orders"),
              _buildTextField(totalAverageController, "Total Average"),
              _buildTextField(newCustomersController, "New Customers"),
              _buildDatePicker(context),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<Store>(
                  value: selectedStore.value,
                  items: Store.values.map((store) {
                    return DropdownMenuItem<Store>(
                      value: store,
                      child: Text(store.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedStore.value = value;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Store",
                    border: OutlineInputBorder(),
                  ),
                ).paddingOnly(bottom: 16);
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      final newReport = DailyReportModel(
                        id: '',
                        date: DateTime.now(),
                        delivery: double.parse(deliveryController.text),
                        shop: double.parse(shopController.text),
                        pickup: double.parse(pickupController.text),
                        onlineOrderSources: {
                          "Manoosh Online": [
                            int.parse(manooshOnlineCountController.text),
                            double.parse(manooshOnlineAmountController.text)
                          ],
                          "DoorDash": [
                            int.parse(doorDashCountController.text),
                            double.parse(doorDashAmountController.text)
                          ],
                          "Menulog": [
                            int.parse(menulogCountController.text),
                            double.parse(menulogAmountController.text)
                          ],
                          "Ubereats": [
                            int.parse(ubereatsCountController.text),
                            double.parse(ubereatsAmountController.text)
                          ],
                        },
                        grossSales: double.parse(grossSalesController.text),
                        netSales: double.parse(netSalesController.text),
                        gst: double.parse(gstController.text),
                        instorePayments: {
                          "Cash": double.parse(cashController.text),
                          "Mobile Eftpos":
                              double.parse(mobileEftposController.text),
                          "Pceftpos": double.parse(pceftposController.text),
                          "Paid Online":
                              double.parse(paidOnlineController.text),
                        },
                        allDayOrderOverview: {
                          "Delivery": [
                            int.parse(deliveryOrdersController.text),
                            double.parse(deliveryAverageController.text)
                          ],
                          "Shop": [
                            int.parse(shopOrdersController.text),
                            double.parse(shopAverageController.text)
                          ],
                          "Pickup": [
                            int.parse(pickupOrdersController.text),
                            double.parse(pickupAverageController.text)
                          ],
                          "Total": [
                            int.parse(totalOrdersController.text),
                            double.parse(totalAverageController.text)
                          ],
                        },
                        newCustomers: int.parse(newCustomersController.text),
                        submittedTime: Timestamp.now(),
                        reportDate: selectedDate.value,
                        store: selectedStore.value,
                      );
                      controller.addDailyReport(newReport);
                      Get.back();
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() {
      return TextField(
        
        controller: TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(selectedDate.value)),
        decoration: InputDecoration(
          labelText: "Report Date",
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate.value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != selectedDate.value) {
            selectedDate.value = pickedDate;
          }
        },
      );
    });
  }
}
