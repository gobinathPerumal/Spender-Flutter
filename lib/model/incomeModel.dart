class IncomeModel
{
  final int id;
  final String month;
  final String year;
  final String amount;
  final String title;


  IncomeModel({this.id,this.month,this.year,this.amount, this.title});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'amount': amount,
      'title': title,
    };
  }
}