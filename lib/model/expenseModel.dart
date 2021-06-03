class ExpenseModel
{
  final int id;
  final String month;
  final String year;
  final int date;
  final String day;
  final String amount;
  final String title;
  final String description;
  final int week;

  ExpenseModel({this.id,this.month,this.year, this.date, this.day, this.amount, this.title, this.description,this.week});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'date': date,
      'day': day,
      'amount': amount,
      'title': title,
      'description': description,
      'week': week,
    };
  }
}