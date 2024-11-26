class Mysqlconfig {
  final String host;
  final int post;
  final String userName;
  final String passWord;
  final String databaseName;
  final bool secure;

  const Mysqlconfig({
    required this.host,
    required this.post,
    required this.databaseName,
    required this.userName,
    required this.passWord,
    this.secure = false,
  });
}

class Poststructure {
  final String title;
  final String slug;
  final int created;
  final int? modified;
  final String text;

  final int authorId;
  //final String template;
  final String type;
  final String status;
  final String? password;
  final int commentsNum;
  final bool allowComment;
  final bool allowPing;
  final bool allowFeed;
  final int parent;
  final int agree;
  final int views;

  const Poststructure({
    required this.title,
    required this.slug,
    required this.created,
    this.modified,
    required this.text,
    required this.authorId,
    this.type = 'post',
    this.status = 'publish',
    this.password,
    this.commentsNum = 0,
    this.allowComment = true,
    this.allowFeed = true,
    this.allowPing = true,
    this.parent = 0,
    this.agree = 0,
    this.views = 0,
  });
}

class Commentstructure {
  final int cid;
  final int created;
  final String author;
  int? authorId;
  final int ownerId;
  String? mail;
  String? url;
  String? ip;
  String? agent;
  final String text;
  final String? type;
  final String? status;
  int? parent;

  Commentstructure({
    required this.cid,
    required this.created,
    required this.author,
    this.authorId = 0,
    this.ownerId = 1,
    this.mail,
    this.url,
    this.ip,
    this.agent,
    required this.text,
    this.type = 'comment',
    this.status = 'approved',
    this.parent,
  });

  Map GetMap() {
    return {
      'cid': this.cid,
      'created': this.created,
      'author': this.author,
      'authorId': this.authorId,
      'ownerId': this.ownerId,
      'mail': this.mail,
      'url': this.url,
      'ip': this.ip,
      'agent': this.agent,
      'text': this.text,
      'type': this.type,
      'status': this.status,
      'parent': this.parent,
    };
  }

  List GetKeyList() {
    List Keylist = [];
    Map tmpeMap = GetMap();
    tmpeMap.forEach((key, value) {
      Keylist.add(value);
    });
    return Keylist;
  }
}
