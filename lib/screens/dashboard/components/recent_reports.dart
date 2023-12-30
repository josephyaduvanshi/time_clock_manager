import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants.dart';
import '../../../models/recent_week_model.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Reports",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Day"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Hours"),
                ),
              ],
              rows: List.generate(
                recentWeekModelList.length,
                (index) => recentFileDataRow(recentWeekModelList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentWeekModel recentWeekModel) {
  return DataRow(
    cells: [
      DataCell(
        recentWeekModel.title.text.isIntrinsic.blue300.make(),
      ),
      DataCell(recentWeekModel.date.text.isIntrinsic.purple400.make()),
      DataCell(recentWeekModel.hours.text.isIntrinsic.green300.make()),
    ],
  );
}
