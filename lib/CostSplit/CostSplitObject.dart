
class CostSplitObject {

  final String id;
  final String title;
  final String description;
  final DateTime time;
  final String amount;
  final String creator;
  final String howMuchDoesEachPersonOwe;
  final List<String> whoNeedsToPay;
  final List<String> whoHasPaid;

  CostSplitObject({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.amount,
    required this.creator,
    required this.howMuchDoesEachPersonOwe,
    required this.whoNeedsToPay,
    required this.whoHasPaid,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'time': time,
    'amount': amount,
    'creator': creator,
    'howMuchDoesEachPersonOwe': howMuchDoesEachPersonOwe,
    'whoNeedsToPay' : whoNeedsToPay,
    'whoHasPaid' : whoHasPaid,
  };

  static CostSplitObject fromJson(Map<String, dynamic> json) => CostSplitObject(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    time: json['time'].toDate(),
    amount: json['amount'],
    creator: json['creator'],
    howMuchDoesEachPersonOwe: json['howMuchDoesEachPersonOwe'],
    whoNeedsToPay: json['whoNeedsToPay'].cast<String>(),
    whoHasPaid: json['whoHasPaid'].cast<String>(),
  );

}