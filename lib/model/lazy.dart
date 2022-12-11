class Lazy {
  bool? success;
  String? token;
  String? uuid;
  bool? chatOnboarding;

  Lazy({this.success, this.token, this.uuid, this.chatOnboarding});

  Lazy.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    uuid = json['uuid'];
    chatOnboarding = json['chat_onboarding'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['uuid'] = this.uuid;
    data['chat_onboarding'] = this.chatOnboarding;
    return data;
  }
}
