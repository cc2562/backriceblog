import 'dart:convert';
import 'dart:io';

import 'package:backriceblog/mysql/mysqlConfig.dart';
import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  if (method == HttpMethod.post) {
    return await _addNewComment(context);
  } else {
    return Response(statusCode: HttpStatus.httpVersionNotSupported);
  }
}

Future<Response> _addNewComment(RequestContext context) async {
  final requset = context.request;
  // ignore: strict_raw_type
  final Map<String, dynamic> postBody =
      await requset.json() as Map<String, dynamic>;
  late Commentstructure newCommentStructure;
  // print(postBody);

  //判断请求是否合法
  if (postBody.containsKey('cid') &&
      postBody.containsKey('created') &&
      postBody.containsKey('author') &&
      postBody.containsKey('text') &&
      postBody.containsKey('key') &&
      postBody.containsKey('code')) {
    //  print('合法');
    //进行key判断
    var checkcode =
        encodeComment(postBody['text'].toString(), postBody['code'].toString());
    if (checkcode != postBody['key'].toString()) {
      return Response.json(body: {'errorcode': HttpStatus.notAcceptable});
    }
    //初始化基础评论数据
    newCommentStructure = Commentstructure(
        cid: int.parse(postBody['cid'].toString()),
        created: int.parse(postBody['created'].toString()),
        author: postBody['author'].toString(),
        text: postBody['text'].toString());
  } else {
    return Response.json(body: {'errorcode': HttpStatus.methodNotAllowed});
  }
  if (postBody.containsKey('authorId')) {
    newCommentStructure.authorId = int.parse(postBody['authorId'].toString());
  }
  if (postBody.containsKey('mail')) {
    newCommentStructure.mail = postBody['mail'].toString();
  }
  if (postBody.containsKey('url')) {
    newCommentStructure.url = postBody['url'].toString();
  }
  if (postBody.containsKey('ip')) {
    newCommentStructure.ip = postBody['ip'].toString();
  }
  if (postBody.containsKey('agent')) {
    newCommentStructure.agent = postBody['agent'].toString();
  }
  if (postBody.containsKey('parent')) {
    newCommentStructure.parent = int.parse(postBody['parent'].toString());
  }
  final mysqlLogic = context.read<Mysqllogic>();
  final Map<String, String> result =
      await mysqlLogic.AddNewComment(newCommentStructure);

  return Response.json(body: result);
}

final String code = "zBt6VliP7If5eG6U17n6D6Scwn7kLy5V";
String encodeComment(String comment, String code) {
  String encode = "";
  for (int i = 0; i < comment.length; i++) {
    encode += String.fromCharCode(comment.codeUnitAt(i) + int.parse(code));
    //进行便宜
  }
  // print('code:$code \n org = $comment');
  // print(encode);
  encode = encode + code;
  encode = md5.convert(utf8.encode(encode)).toString();
//  print(encode);
  return encode;
}
