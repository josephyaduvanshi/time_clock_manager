import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/enployee_model.dart';

class UserAvailabilityCard extends StatefulWidget {
  final EmployeeModel employee;

  const UserAvailabilityCard({
    required this.employee,
    Key? key,
  }) : super(key: key);

  @override
  _UserAvailabilityCardState createState() => _UserAvailabilityCardState();
}

class _UserAvailabilityCardState extends State<UserAvailabilityCard> {
  bool _isExpanded = false;
  late Map<String, bool> _isAvailable;
  late Map<String, RangeValues> _availability;

  @override
  void initState() {
    super.initState();
    _initializeAvailability();
  }

  void _updateAvailabilityInFirestore() async {
    try {
      final employeeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.employee.id);

      final updatedAvailability = {
        'SUN': _isAvailable['SUN']!
            ? _convertRangeValuesToMap(_availability['SUN']!)
            : {'start': 0.0, 'finish': 0.0},
        'MON': _isAvailable['MON']!
            ? _convertRangeValuesToMap(_availability['MON']!)
            : {'start': 0.0, 'finish': 0.0},
        'TUE': _isAvailable['TUE']!
            ? _convertRangeValuesToMap(_availability['TUE']!)
            : {'start': 0.0, 'finish': 0.0},
        'WED': _isAvailable['WED']!
            ? _convertRangeValuesToMap(_availability['WED']!)
            : {'start': 0.0, 'finish': 0.0},
        'THU': _isAvailable['THU']!
            ? _convertRangeValuesToMap(_availability['THU']!)
            : {'start': 0.0, 'finish': 0.0},
        'FRI': _isAvailable['FRI']!
            ? _convertRangeValuesToMap(_availability['FRI']!)
            : {'start': 0.0, 'finish': 0.0},
        'SAT': _isAvailable['SAT']!
            ? _convertRangeValuesToMap(_availability['SAT']!)
            : {'start': 0.0, 'finish': 0.0},
      };

      await employeeRef.update({'availability': updatedAvailability});
    } catch (e) {
      print('Error updating availability in Firestore: $e');
    }
  }

  Map<String, dynamic> _convertRangeValuesToMap(RangeValues range) {
    return {
      'start': _convertValueToTime(range.start),
      'finish': _convertValueToTime(range.end),
    };
  }

  void _initializeAvailability() {
    _isAvailable = {
      "SUN": true,
      "MON": true,
      "TUE": true,
      "WED": true,
      "THU": true,
      "FRI": true,
      "SAT": true,
    };

    _availability = {
      "SUN": _convertToRangeValues(widget.employee.availability?.sun),
      "MON": _convertToRangeValues(widget.employee.availability?.mon),
      "TUE": _convertToRangeValues(widget.employee.availability?.tue),
      "WED": _convertToRangeValues(widget.employee.availability?.wed),
      "THU": _convertToRangeValues(widget.employee.availability?.thu),
      "FRI": _convertToRangeValues(widget.employee.availability?.fri),
      "SAT": _convertToRangeValues(widget.employee.availability?.sat),
    };
  }

  RangeValues _convertToRangeValues(Fri? availability) {
    if (availability == null) {
      return RangeValues(0, 0);
    }
    return RangeValues(
      _convertTimeToValue(availability.start),
      _convertTimeToValue(availability.finish),
    );
  }

  double _convertTimeToValue(double time) {
    int hours = time.floor();
    int minutes = ((time - hours) * 60).round();
    return hours * 12 + minutes / 5;
  }

  double _convertValueToTime(double value) {
    int hours = (value / 12).floor();
    int minutes = ((value % 12) * 5).round();
    return hours + minutes / 60.0;
  }

  String _formatTime(double value) {
    final time = _convertValueToTime(value);
    final hours = time.floor();
    final minutes = ((time - hours) * 60).round();
    final period = hours < 12 ? 'AM' : 'PM';
    final formattedHours = hours % 12 == 0 ? 12 : hours % 12;
    return '${formattedHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
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
            title: Text(widget.employee.name,
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: !_isExpanded
                ? "Availability: ".richText.withTextSpanChildren([
                    TextSpan(
                      text: "${_calculateAvailabilityPercentage()}%",
                      style: TextStyle(
                        color: _calculateAvailabilityPercentage() > 60
                            ? Vx.green400
                            : _calculateAvailabilityPercentage() > 30
                                ? Vx.yellow400
                                : Vx.red400,
                      ),
                    )
                  ]).make()
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
                children: _buildAvailabilitySliders(),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildAvailabilitySliders() {
    List<String> days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    return days.map((day) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day),
              CupertinoSwitch(
                value: _isAvailable[day]!,
                onChanged: (bool value) {
                  setState(() {
                    _isAvailable[day] = value;
                    if (!value) {
                      _availability[day] = RangeValues(0, 0);
                    }
                  });
                  _updateAvailabilityInFirestore();
                },
              ),
            ],
          ),
          if (_isAvailable[day]!)
            RangeSlider(
              values: _availability[day]!,
              min: 0.0,
              max: 288.0,
              divisions: 288,
              labels: RangeLabels(
                _formatTime(_availability[day]!.start),
                _formatTime(_availability[day]!.end),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _availability[day] = values;
                });
                _updateAvailabilityInFirestore();
              },
            ),
          const Divider(),
        ],
      );
    }).toList();
  }

  double _calculateAvailabilityPercentage() {
    int totalHours = 0;
    int availableHours = 0;

    _availability.forEach((day, range) {
      totalHours += 24;
      if (_isAvailable[day]!) {
        availableHours +=
            (_convertValueToTime(range.end) - _convertValueToTime(range.start))
                .round();
      }
    });

    return ((availableHours / totalHours) * 100).toPrecision(2);
  }
}
