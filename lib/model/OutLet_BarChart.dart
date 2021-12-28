import 'package:flutter/material.dart';
import 'package:merchandising/api/monthlyvisitschart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import "package:merchandising/Constants.dart";


class BarChatData extends StatefulWidget {
  @override
  _BarChatDataState createState() => _BarChatDataState();
}

class _BarChatDataState extends State<BarChatData> {
  final LinearGradient _linearGradient = LinearGradient(
    colors: <Color>[
      orange,
      pink
    ],
    stops: <double>[0.1,0.5],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  final LinearGradient _linearGradientexp = LinearGradient(
    colors: <Color>[
      iconscolor,
      Colors.grey[400],
    ],
    stops: <double>[0.1, 0.5],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  List<ChartData> data = [
    ChartData('Jan',visits.jan,expectedvisits.jan),
    ChartData('Feb',visits.feb,expectedvisits.feb),
    ChartData('Mar',visits.mar,expectedvisits.mar),
    ChartData('Apr',visits.apr,expectedvisits.apr),
    ChartData('May',visits.may,expectedvisits.may),
    ChartData('Jun',visits.jun,expectedvisits.jun),
    ChartData('Jul',visits.jul,expectedvisits.jul),
    ChartData('Aug',visits.aug,expectedvisits.aug),
    ChartData('Sep',visits.sep,expectedvisits.sep),
    ChartData('Oct',visits.oct,expectedvisits.oct),
    ChartData('Nov',visits.nov,expectedvisits.nov),
    ChartData('Dec',visits.dec,expectedvisits.dec),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.05,
          height: MediaQuery.of(context).size.height / 4,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                 //gradient: _linearGradientexp,
                  color: iconscolor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y
                ),
                ColumnSeries<ChartData, String>(
                    //gradient: _linearGradient,
                  color: orange,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y1
                ),
              ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Monthly Visits"),
              Container(
                margin: EdgeInsets.only(left:10.0,right: 5.0),
                height: 10,
                width: 10,
                decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffffa726), Color(0xfffb8c00)])),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0,bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Monthly Expected Visits"),
              Container(
                margin: EdgeInsets.only(left:10.0,top: 5.0,right: 5.0),
                height: 10,
                width: 10,
                color: iconscolor,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
class ChartData {
  ChartData(this.x, this.y, this.y1,);
  final String x;
  final int y;
  final int y1;

}





