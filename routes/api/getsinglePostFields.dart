import 'dart:io';

import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

//获取单个文章Fields
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  //return Response(body: 'This is a new route!');
  final method = context.request.method;
  if (method == HttpMethod.post) {
    return await _onGetPost(context);
  } else {
    return Response(statusCode: HttpStatus.httpVersionNotSupported);
  }
}

Future<Response> _onGetPost(RequestContext context) async {
  final requset = context.request;
  List result = [];
  String cid = '0';
  // ignore: strict_raw_type
  final Map<String, dynamic> postBody =
      await requset.json() as Map<String, dynamic>;
  final mysqlLogic = context.read<Mysqllogic>();

  if (postBody.containsKey('cid')) {
    cid = postBody['cid'].toString();
    result = await mysqlLogic.GetSinglePostFields(cid);
    if (result.isEmpty) {
      result = [
        {'status': 'nothing'}
      ];
    }
  } else {
    result = [
      {'errorcode': HttpStatus.methodNotAllowed}
    ];
  }
  // print(result);
  return Response.json(body: result);
}
