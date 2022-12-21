/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myCharacterNode = Character.fromJson(map);
*/
class Character {
  String? externalId;
  String? title;
  String? greeting;
  String? avatarFilename;
  bool? copyable;
  String? participantName;
  String? userUsername;
  int? participantNumInteractions;
  bool? imgGenEnabled;
  String? category;
  String? lasthistoryid;

  Character(
      {this.externalId,
      this.title,
      this.greeting,
      this.avatarFilename,
      this.copyable,
      this.participantName,
      this.userUsername,
      this.participantNumInteractions,
      this.imgGenEnabled,
      this.category,
      this.lasthistoryid});

  Character.fromJson(Map<String, dynamic> json) {
    externalId = json['external_id'];
    title = json['title'];
    greeting = json['greeting'];
    avatarFilename = json['avatar_file_name'];
    copyable = json['copyable'];
    participantName = json['participant__name'];
    userUsername = json['user__username'];
    participantNumInteractions = json['participant__num_interactions'];
    imgGenEnabled = json['img_gen_enabled'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['external_id'] = externalId;
    data['title'] = title;
    data['greeting'] = greeting;
    data['avatar_file_name'] = avatarFilename;
    data['copyable'] = copyable;
    data['participant__name'] = participantName;
    data['user__username'] = userUsername;
    data['participant__num_interactions'] = participantNumInteractions;
    data['img_gen_enabled'] = imgGenEnabled;
    data['category'] = category;
    data['last_history_id'] = lasthistoryid;
    return data;
  }
}
