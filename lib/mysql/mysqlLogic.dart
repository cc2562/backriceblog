import 'dart:io';

import 'package:backriceblog/command.dart';
import 'package:backriceblog/mysql/mysqlConfig.dart';
import 'package:mysql_client/mysql_client.dart';

class Mysqllogic {
  final setSqlConfig = const Mysqlconfig(
    host: '127.0.0.1',
    post: 3306,
    databaseName: 'sql_world_ccrice',
    userName: 'sql_world_ccrice',
    passWord: 'WbNYtYPNyCp7jH4w',
  );
  //连接数据库
  Future<MySQLConnection> ConnectSql() async {
    final conn = await MySQLConnection.createConnection(
      host: setSqlConfig.host,
      port: setSqlConfig.post,
      userName: setSqlConfig.userName,
      password: setSqlConfig.passWord,
      databaseName: setSqlConfig.databaseName,
      secure: false,
    );
    return conn;
  }

  //新的数据
  Future<void> Addnewpost(Poststructure newPostStructure) async {
    final connected = await ConnectSql();
    await connected.connect();
    var stmt = await connected.prepare(
        "INSERT INTO typecho_contents (title,slug,created,modified,text,authorId,type,status,password,commentsNum,allowComment,allowPing,allowFeed,parent,agree,views) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    await stmt.execute(
      [
        newPostStructure.title,
        newPostStructure.slug,
        newPostStructure.created,
        newPostStructure.modified,
        newPostStructure.text,
        newPostStructure.authorId,
        newPostStructure.type,
        newPostStructure.status,
        newPostStructure.password,
        newPostStructure.commentsNum,
        Convertbooltoint(newPostStructure.allowComment),
        Convertbooltoint(newPostStructure.allowPing),
        Convertbooltoint(newPostStructure.allowFeed),
        newPostStructure.parent,
        newPostStructure.agree,
        newPostStructure.views,
      ],
    );
    await stmt.deallocate();
    await connected.close();
  }

  //获取文章列表
  Future<List> GetPosts(int page) async {
    List resultList = [];
    final connected = await ConnectSql();
    await connected.connect();
    //先获取总数量
    IResultSet totalPostsResult = await connected.execute(
        "SELECT COUNT(*) FROM typecho_contents WHERE type = 'post' AND status = 'publish';");
    int totalPosts = int.parse(totalPostsResult.rows.first.colAt(0).toString());
    //计算页数
    double totalPagesCourse = totalPosts / 6;
    int totalPages = totalPagesCourse.ceil();
    if (page > totalPages) {
      page = 1;
      return [
        {'error': "404"}
      ];
    }
    //计算获取范围
    int startPost = (page - 1) * 6;
    int endPost = page * 6;
    //  print('start:$startPost  end:$endPost');
    IResultSet result = await connected.execute(
        "SELECT * FROM typecho_contents WHERE type = 'post' AND status = 'publish' ORDER BY created DESC LIMIT $startPost, 6;");
    for (var row in result.rows) {
      resultList.add(row.assoc());
    }
    await connected.close();
    return resultList;
  }

  //获取单个文章
  Future<Map> GetSinglePost(int cid) async {
    final connected = await ConnectSql();
    await connected.connect();
    var stmt = await connected.prepare(
        "SELECT * FROM typecho_contents WHERE cid = ? AND status = 'publish';");
    try {
      IResultSet result = await stmt.execute([cid]);
      await stmt.deallocate();
      await connected.close();
      //  print(result.rows.first.assoc());
      Map singlePostResult = result.rows.first.assoc();
      return singlePostResult;
    } catch (e) {
      await connected.close();
      return {'errorcode': e.toString()};
    }
    //IResultSet result = await stmt.execute([cid]);
  }

  //获取评论
  Future<List> GetComments(int cid) async {
    List resultList = [];
    final connected = await ConnectSql();
    await connected.connect();
    var stmt = await connected.prepare(
        "SELECT * FROM typecho_comments WHERE cid = ? AND type = 'comment' AND status = 'approved' ORDER BY created DESC;");
    IResultSet result = await stmt.execute([cid]);
    await stmt.deallocate();
    await connected.close();
    for (var row in result.rows) {
      resultList.add(row.assoc());
    }
    return resultList;
  }

  //添加新的评论
  Future<Map<String, String>> AddNewComment(Commentstructure newComment) async {
    try {
      final connected = await ConnectSql();
      await connected.connect();
      var stmt = await connected.prepare(
          "INSERT INTO `typecho_comments` (`cid`, `created`, `author`, `authorId`, `ownerId`, `mail`, `url`, `ip`, `agent`, `text`, `type`, `status`, `parent`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");
      List toAddCommentList = newComment.GetKeyList();
      //  print(toAddCommentList);
      await stmt.execute(toAddCommentList);
      await stmt.deallocate();
      await connected.close();
      return {'code': '200'};
    } catch (e) {
      return {'code': HttpStatus.badRequest.toString()};
    }
  }

  Future<List<dynamic>> GetSinglePostFields(String cid) async {
    List reslutList = [];
    final connected = await ConnectSql();
    await connected.connect();
    var stmt =
        await connected.prepare("SELECT * FROM typecho_fields WHERE cid = ? ");
    IResultSet result = await stmt.execute([cid]);
    await stmt.deallocate();
    await connected.close();
    for (var row in result.rows) {
      reslutList.add(row.assoc());
      //   print(row);
    }
    // print(reslutList);
    return reslutList;
  }

  Future<List<dynamic>> GetLinks() async {
    List<dynamic> reslutList = [];
    final connected = await ConnectSql();
    await connected.connect();
    IResultSet result = await connected.execute(
        "SELECT * FROM `typecho_links` ORDER BY `typecho_links`.`lid` ASC");
    connected.close();
    for (var row in result.rows) {
      reslutList.add(row.assoc());
      //   print(row);
    }
    return reslutList;
  }
}
