class CategoriesModel {
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
  List<Null>? tags;
  List<String>? classList;
 
  CategoriesModel(
      {this.id,
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

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? new Guid.fromJson(json['title']) : null;
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
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    categories = json['categories'].cast<int>();
    if (json['tags'] != null) {
      tags = <Null>[];
    }
    classList = json['class_list'].cast<String>();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    if (this.guid != null) {
      data['guid'] = this.guid!.toJson();
    }
    data['modified'] = this.modified;
    data['modified_gmt'] = this.modifiedGmt;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['type'] = this.type;
    data['link'] = this.link;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
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
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['categories'] = this.categories;
    // if (this.tags != null) {
    //   data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    // }
    data['class_list'] = this.classList;
   
    return data;
  }
}
class Guid {
  String? rendered;

  Guid({this.rendered});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
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

class Meta {
  String? footnotes;

  Meta({this.footnotes});

  Meta.fromJson(Map<String, dynamic> json) {
    footnotes = json['footnotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['footnotes'] = this.footnotes;
    return data;
  }
}

