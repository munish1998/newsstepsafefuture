class WaterScienceModel {
  int? id;
  String? date;
  String? dateGmt;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  String? commentStatus;
  String? pingStatus;
  bool? sticky;
  String? template;
  String? format;
  List<int>? categories;
  List<Null>? tags;
  List<String>? classList;

  WaterScienceModel({
    this.id,
    this.date,
    this.dateGmt,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.categories,
    this.tags,
    this.classList,
  });

  WaterScienceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    // guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    // title = json['title'] != null ? new Guid.fromJson(json['title']) : null;
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    excerpt =
        json['excerpt'] != null ? new Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'];
    template = json['template'];
    format = json['format'];

    categories = json['categories'].cast<int>();
    if (json['tags'] != null) {
      tags = <Null>[];
      json['tags'].forEach((v) {
        // tags!.add(new Null.fromJson(v));
      });
    }
    classList = json['class_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;

    data['modified'] = this.modified;
    data['modified_gmt'] = this.modifiedGmt;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['type'] = this.type;
    data['link'] = this.link;

    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.excerpt != null) {
      data['excerpt'] = this.excerpt!.toJson();
    }
    data['author'] = this.author;
    data['featured_media'] = this.featuredMedia;
    data['comment_status'] = this.commentStatus;
    data['ping_status'] = this.pingStatus;
    data['sticky'] = this.sticky;
    data['template'] = this.template;
    data['format'] = this.format;

    data['categories'] = this.categories;
    if (this.tags != null) {
      //  data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['class_list'] = this.classList;

    return data;
  }
}

class Content {
  String? rendered;
  bool? protected;

  Content({this.rendered, this.protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    data['protected'] = this.protected;
    return data;
  }
}

class Self {
  String? href;
  TargetHints? targetHints;

  Self({this.href, this.targetHints});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    targetHints = json['targetHints'] != null
        ? new TargetHints.fromJson(json['targetHints'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    if (this.targetHints != null) {
      data['targetHints'] = this.targetHints!.toJson();
    }
    return data;
  }
}

class TargetHints {
  List<String>? allow;

  TargetHints({this.allow});

  TargetHints.fromJson(Map<String, dynamic> json) {
    allow = json['allow'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allow'] = this.allow;
    return data;
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class Author {
  bool? embeddable;
  String? href;

  Author({this.embeddable, this.href});

  Author.fromJson(Map<String, dynamic> json) {
    embeddable = json['embeddable'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    return data;
  }
}
