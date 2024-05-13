class RelatedAccount {
  final String? userMail;

  RelatedAccount.fromJson(Map<String, dynamic> json) : userMail = json['data'];
}
