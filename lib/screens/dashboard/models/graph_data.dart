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
        dailyPoints!.add(FlSpot(((v['x']/2) - 0.5).toDouble(), v['y'].toDouble()));
      });

    }
    if(json['monthly_graph_points'] != null) {
      monthlyPoints = <FlSpot>[];
      json['monthly_graph_points'].forEach((v) {
        monthlyPoints!.add(FlSpot((v['x']).toDouble(), v['y'].toDouble()));
      });
    }
    if(json['yearly_graph_points'] != null) {
      yearlyPoints = <FlSpot>[];
      json['yearly_graph_points'].forEach((v) {
        yearlyPoints!.add(FlSpot((DateTime.now().year - v['x'] + 11).toDouble(), v['y'].toDouble()));
      });
    }
  }
}