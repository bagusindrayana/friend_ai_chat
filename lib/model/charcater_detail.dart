class CharacterDetail {
  String? externalId;
  String? title;
  String? name;
  String? visibility;
  bool? copyable;
  String? greeting;
  String? description;
  String? identifier;
  String? avatarFileName;
  bool? imgGenEnabled;
  String? baseImgPrompt;
  String? imgPromptRegex;
  bool? stripImgPromptFromMsg;
  String? userUsername;
  String? participantName;
  int? participantNumInteractions;
  String? participantUserUsername;
  dynamic? voiceId;
  String? usage;

  CharacterDetail(
      {this.externalId,
      this.title,
      this.name,
      this.visibility,
      this.copyable,
      this.greeting,
      this.description,
      this.identifier,
      this.avatarFileName,
      this.imgGenEnabled,
      this.baseImgPrompt,
      this.imgPromptRegex,
      this.stripImgPromptFromMsg,
      this.userUsername,
      this.participantName,
      this.participantNumInteractions,
      this.participantUserUsername,
      this.voiceId,
      this.usage});

  CharacterDetail.fromJson(Map<String, dynamic> json) {
    externalId = json['external_id'];
    title = json['title'];
    name = json['name'];
    visibility = json['visibility'];
    copyable = json['copyable'];
    greeting = json['greeting'];
    description = json['description'];
    identifier = json['identifier'];
    avatarFileName = json['avatar_file_name'];

    imgGenEnabled = json['img_gen_enabled'];
    baseImgPrompt = json['base_img_prompt'];
    imgPromptRegex = json['img_prompt_regex'];
    stripImgPromptFromMsg = json['strip_img_prompt_from_msg'];
    userUsername = json['user__username'];
    participantName = json['participant__name'];
    participantNumInteractions = json['participant__num_interactions'];
    participantUserUsername = json['participant__user__username'];
    voiceId = json['voice_id'];
    usage = json['usage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['external_id'] = this.externalId;
    data['title'] = this.title;
    data['name'] = this.name;
    data['visibility'] = this.visibility;
    data['copyable'] = this.copyable;
    data['greeting'] = this.greeting;
    data['description'] = this.description;
    data['identifier'] = this.identifier;
    data['avatar_file_name'] = this.avatarFileName;

    data['img_gen_enabled'] = this.imgGenEnabled;
    data['base_img_prompt'] = this.baseImgPrompt;
    data['img_prompt_regex'] = this.imgPromptRegex;
    data['strip_img_prompt_from_msg'] = this.stripImgPromptFromMsg;
    data['user__username'] = this.userUsername;
    data['participant__name'] = this.participantName;
    data['participant__num_interactions'] = this.participantNumInteractions;
    data['participant__user__username'] = this.participantUserUsername;
    data['voice_id'] = this.voiceId;
    data['usage'] = this.usage;
    return data;
  }
}
