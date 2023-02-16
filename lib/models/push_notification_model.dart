class PushNotificationModel {
  PushNotificationModel({
    this.title,
    this.body,
  });

  String? title;
  String? body;

  dynamic toJson() => {
    'title': title,
    'body': body,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}