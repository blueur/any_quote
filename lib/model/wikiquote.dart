import 'package:json_annotation/json_annotation.dart';

part 'wikiquote.g.dart';

@JsonSerializable()
class WikiquoteResponse {
  final Parse parse;
  final Query query;

  WikiquoteResponse({this.parse, this.query});

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
  final String text;
  final List<Link> links;
  final List<Section> sections;

  Parse({this.title, this.text, this.links, this.sections});

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

  Section({this.toclevel, this.level, this.number, this.index});

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Link {
  final int ns;
  final String title;
  final bool exists;

  Link({this.ns, this.title, this.exists});

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class Query {
  final List<SearchResult> prefixsearch;
  final List<SearchResult> search;

  Query({this.prefixsearch, this.search});

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  Map<String, dynamic> toJson() => _$QueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class SearchResult {
  final String title;

  SearchResult({this.title});

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
