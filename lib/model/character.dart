/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myCharacterNode = Character.fromJson(map);
*/
class Character {
  String? externalid;
  String? title;
  String? greeting;
  String? avatarfilename;
  bool? copyable;
  String? participantname;
  String? userusername;
  int? participantnuminteractions;
  bool? imggenenabled;
  String? category;

  Character(
      {this.externalid,
      this.title,
      this.greeting,
      this.avatarfilename,
      this.copyable,
      this.participantname,
      this.userusername,
      this.participantnuminteractions,
      this.imggenenabled,
      this.category});

  Character.fromJson(Map<String, dynamic> json) {
    externalid = json['external_id'];
    title = json['title'];
    greeting = json['greeting'];
    avatarfilename = json['avatar_file_name'];
    copyable = json['copyable'];
    participantname = json['participant__name'];
    userusername = json['user__username'];
    participantnuminteractions = json['participant__num_interactions'];
    imggenenabled = json['img_gen_enabled'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['external_id'] = externalid;
    data['title'] = title;
    data['greeting'] = greeting;
    data['avatar_file_name'] = avatarfilename;
    data['copyable'] = copyable;
    data['participant__name'] = participantname;
    data['user__username'] = userusername;
    data['participant__num_interactions'] = participantnuminteractions;
    data['img_gen_enabled'] = imggenenabled;
    data['category'] = category;
    return data;
  }
}
