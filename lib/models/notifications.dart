class NotificationObj {

  final String title;
  final String subtitle;
  final String type;
  final Map<String, dynamic> additionalInfo;
  final DateTime expireAt;
  final List<dynamic> subscribed;

  NotificationObj({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.additionalInfo,
    required this.expireAt,
    required this.subscribed
  });

}
