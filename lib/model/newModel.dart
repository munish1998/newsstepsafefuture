class NewModel {
  int? id;
  int? count;
  String? description;
  String? link;
  String? name;
  String? slug;
  String? taxonomy;
  int? parent;
  List<dynamic>? meta; // Changed from List<Null> to List<dynamic>
  Links? lLinks;

  NewModel({
    this.id,
    this.count,
    this.description,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.parent,
    this.meta,
    this.lLinks,
  });

  NewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = json['count'];
    description = json['description'];
    link = json['link'];
    name = json['name'];
    slug = json['slug'];
    taxonomy = json['taxonomy'];
    parent = json['parent'];
    meta = json['meta']; // No need to map null objects
    lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['count'] = count;
    data['description'] = description;
    data['link'] = link;
    data['name'] = name;
    data['slug'] = slug;
    data['taxonomy'] = taxonomy;
    data['parent'] = parent;
    if (meta != null) {
      data['meta'] = meta;
    }
    if (lLinks != null) {
      data['_links'] = lLinks?.toJson();
    }
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;
  List<About>? about;
  List<WpPostType>? wpPostType;
  List<Curies>? curies;

  Links({this.self, this.collection, this.about, this.wpPostType, this.curies});

  Links.fromJson(Map<String, dynamic> json) {
    self = (json['self'] as List?)?.map((v) => Self.fromJson(v)).toList();
    collection = (json['collection'] as List?)?.map((v) => Collection.fromJson(v)).toList();
    about = (json['about'] as List?)?.map((v) => About.fromJson(v)).toList();
    wpPostType = (json['wp:post_type'] as List?)?.map((v) => WpPostType.fromJson(v)).toList();
    curies = (json['curies'] as List?)?.map((v) => Curies.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (self != null) data['self'] = self?.map((v) => v.toJson()).toList();
    if (collection != null) data['collection'] = collection?.map((v) => v.toJson()).toList();
    if (about != null) data['about'] = about?.map((v) => v.toJson()).toList();
    if (wpPostType != null) data['wp:post_type'] = wpPostType?.map((v) => v.toJson()).toList();
    if (curies != null) data['curies'] = curies?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class About {
  String? href;

  About({this.href});

  About.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class WpPostType {
  String? href;

  WpPostType({this.href});

  WpPostType.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class Curies {
  String? name;
  String? href;
  bool? templated;

  Curies({this.name, this.href, this.templated});

  Curies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    href = json['href'];
    templated = json['templated'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'href': href, 'templated': templated};
  }
}
