class CategoryDetails {
  int? id;
  String? date;
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Guid? title;
  Content? content;
  Content? excerpt;
  int? author;
  int? featuredMedia;
  String? commentStatus;
  String? pingStatus;
  bool? sticky;
  String? template;
  String? format;
  Meta? meta;
  List<int>? categories;
  List<int>? tags; // Fixed issue
  List<String>? classList;

  CategoryDetails({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.meta,
    this.categories,
    this.tags,
    this.classList,
  });

  CategoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? Guid.fromJson(json['title']) : null;
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    excerpt = json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'] ?? false; // Ensure it's a boolean
    template = json['template'];
    format = json['format'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    categories = json['categories'] != null ? List<int>.from(json['categories']) : [];
    tags = json['tags'] != null ? List<int>.from(json['tags']) : [];
    classList = json['class_list'] != null ? List<String>.from(json['class_list']) : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'date_gmt': dateGmt,
      'guid': guid?.toJson(),
      'modified': modified,
      'modified_gmt': modifiedGmt,
      'slug': slug,
      'status': status,
      'type': type,
      'link': link,
      'title': title?.toJson(),
      'content': content?.toJson(),
      'excerpt': excerpt?.toJson(),
      'author': author,
      'featured_media': featuredMedia,
      'comment_status': commentStatus,
      'ping_status': pingStatus,
      'sticky': sticky,
      'template': template,
      'format': format,
      'meta': meta?.toJson(),
      'categories': categories,
      'tags': tags,
      'class_list': classList,
    };
  }
}

class Guid {
  String? rendered;

  Guid({this.rendered});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered};
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
    return {'rendered': rendered, 'protected': protected};
  }
}

class Meta {
  String? footnotes;

  Meta({this.footnotes});

  Meta.fromJson(Map<String, dynamic> json) {
    footnotes = json['footnotes'];
  }

  Map<String, dynamic> toJson() {
    return {'footnotes': footnotes};
  }
}
