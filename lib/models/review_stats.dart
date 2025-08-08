class ReviewStats {
  int? total;
  double? oneStar;
  double? twoStar;
  double? threeStar;
  double? fourStar;
  double? fiveStar;

  ReviewStats({
    this.total,
    this.oneStar,
    this.twoStar,
    this.threeStar,
    this.fourStar,
    this.fiveStar,
  });

  ReviewStats.fromJson(Map<String, dynamic> json) {
    total = json['total_ratings'];
    oneStar = json['one_star']?.toDouble();
    twoStar = json['two_star']?.toDouble();
    threeStar = json['three_star']?.toDouble();
    fourStar = json['four_star']?.toDouble();
    fiveStar = json['five_star']?.toDouble();
  }
}