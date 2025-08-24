import 'package:fl_chart/fl_chart.dart';

class GraphData {

  int? min;
  int? avg;
  int? max;
  List<FlSpot>? dailyPoints;
  List<FlSpot>? monthlyPoints;
  List<FlSpot>? yearlyPoints;

  GraphData({this.min, this.avg, this.max, this.dailyPoints});

  GraphData.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    avg = json['avg'];
    max = json['max'];
    if(json['daily_graph_points'] != null) {
      dailyPoints = <FlSpot>[];
      json['daily_graph_points'].forEach((v) {
        dailyPoints!.add(FlSpot((v['x']/2).toDouble(), v['y'].toDouble()));
      });
      dailyPoints!.insert(0, FlSpot(0, 0));
      // points!.insert(points!.length, FlSpot(11, 0));

    }
    if(json['monthly_graph_points'] != null) {
      monthlyPoints = <FlSpot>[];
      json['monthly_graph_points'].forEach((v) {
        monthlyPoints!.add(FlSpot((v['x']/2).toDouble(), v['y'].toDouble()));
      });
      monthlyPoints!.insert(0, FlSpot(0, 0));
      // points!.insert(points!.length, FlSpot(11, 0));
    }
    if(json['yearly_graph_points'] != null) {
      yearlyPoints = <FlSpot>[];
      json['yearly_graph_points'].forEach((v) {
        yearlyPoints!.add(FlSpot((v['x']/2).toDouble(), v['y'].toDouble()));
      });
      yearlyPoints!.insert(0, FlSpot(0, 0));
      // points!.insert(points!.length, FlSpot(11, 0));
    }
  }
}