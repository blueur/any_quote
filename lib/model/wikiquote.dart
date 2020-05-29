import 'package:json_annotation/json_annotation.dart';

part 'wikiquote.g.dart';

@JsonSerializable()
class WikiquoteResponse {
  final Parse parse;

  WikiquoteResponse(this.parse);

  factory WikiquoteResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiquoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WikiquoteResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Parse {
  final String title;
  final Text text;
  final List<Link> links;
  final List<Section> sections;

  Parse(this.title, this.text, this.links, this.sections);

  factory Parse.fromJson(Map<String, dynamic> json) => _$ParseFromJson(json);

  Map<String, dynamic> toJson() => _$ParseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Section {
  final int toclevel;
  final String level;
  final String number;
  final String index;

  Section(this.toclevel, this.level, this.number, this.index);

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Text {
  @JsonKey(name: '*')
  final String all;

  Text(this.all);

  factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);

  Map<String, dynamic> toJson() => _$TextToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Link {
  final int ns;
  final String exists;
  @JsonKey(name: '*')
  final String all;

  Link(this.ns, this.exists, this.all);

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
