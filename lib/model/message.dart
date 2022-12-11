import 'package:animated_text_kit/animated_text_kit.dart';

class Message {
  int? id;
  String? text;
  String? srcName;
  String? srcUserUsername;
  bool? srcIsHuman;
  String? srcCharacterAvatarFileName;
  bool? isAlternative;
  String? imageRelPath;
  String? imagePromptText;
  String? responsibleUserUsername;
  String? deleted;
  List<AnimatedTextKit>? animatedTextKits;
  bool? animated;

  Message({
    this.id,
    this.text,
    this.srcName,
    this.srcUserUsername,
    this.srcIsHuman,
    this.srcCharacterAvatarFileName,
    this.isAlternative,
    this.imageRelPath,
    this.imagePromptText,
    this.responsibleUserUsername,
    this.deleted,
    this.animatedTextKits,
    this.animated,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    srcName = json['src__name'];
    srcUserUsername = json['src__user__username'];
    srcIsHuman = json['src__is_human'];
    srcCharacterAvatarFileName = json['src__character__avatar_file_name'];
    isAlternative = json['is_alternative'];
    imageRelPath = json['image_rel_path'];
    imagePromptText = json['image_prompt_text'];
    responsibleUserUsername = json['responsible_user__username'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['src__name'] = this.srcName;
    data['src__user__username'] = this.srcUserUsername;
    data['src__is_human'] = this.srcIsHuman;
    data['src__character__avatar_file_name'] = this.srcCharacterAvatarFileName;
    data['is_alternative'] = this.isAlternative;
    data['image_rel_path'] = this.imageRelPath;
    data['image_prompt_text'] = this.imagePromptText;
    data['responsible_user__username'] = this.responsibleUserUsername;
    data['deleted'] = this.deleted;
    return data;
  }
}
