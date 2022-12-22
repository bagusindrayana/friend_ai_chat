class User {
  String? username;
  int? id;
  String? firstName;
  Account? account;
  bool? isStaff;

  User({this.username, this.id, this.firstName, this.account, this.isStaff});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['id'];
    firstName = json['first_name'];
    account =
        json['account'] != null ? new Account.fromJson(json['account']) : null;
    isStaff = json['is_staff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    if (this.account != null) {
      data['account'] = this.account!.toJson();
    }
    data['is_staff'] = this.isStaff;
    return data;
  }
}

class Account {
  String? name;
  String? avatarType;
  bool? onboardingComplete;
  String? avatarFileName;

  Account(
      {this.name,
      this.avatarType,
      this.onboardingComplete,
      this.avatarFileName});

  Account.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatarType = json['avatar_type'];
    onboardingComplete = json['onboarding_complete'];
    avatarFileName = json['avatar_file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar_type'] = this.avatarType;
    data['onboarding_complete'] = this.onboardingComplete;
    data['avatar_file_name'] = this.avatarFileName;
    return data;
  }
}
