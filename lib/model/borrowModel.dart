class BorrowModel
{
  final int id;
  final String month;
  final String year;
  final int date;
  final String day;
  final String amount;
  final String lenderName;
  final String description;
  final String lastMonth;
  final String lastYear;
  final int lastDate;
  final int sendAmount;
  final int status;

  BorrowModel({this.id,this.month,this.year, this.date, this.day, this.amount, this.lenderName, this.description,this.lastMonth, this.lastYear, this.lastDate, this.sendAmount,this.status});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'date': date,
      'day': day,
      'amount': amount,
      'lenderName': lenderName,
      'description': description,
      'lastMonth': lastMonth,
      'lastYear': lastYear,
      'lastDate': lastDate,
      'sendAmount': sendAmount,
      'status': status,
    };
  }
}