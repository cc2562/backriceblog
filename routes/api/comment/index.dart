import 'dart:io';

import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

//获取对应文章的评论
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  //return Response(body: 'This is a new route!');
  final method = context.request.method;
  if (method == HttpMethod.get) {
    return await _onGetComments(context);
  } else {
    return Response(statusCode: HttpStatus.httpVersionNotSupported);
  }
}

Future<Response> _onGetComments(RequestContext context) async {
  final request = context.request;
  final params = request.uri.queryParameters;
  final getCid = params['cid'];
  int cid = 1;
  if (getCid == null || getCid == '') {
    return Response.json(body: {'errorcode': '404'});
  } else {
    cid = int.parse(getCid);
  }
  final mysqlLogic = context.read<Mysqllogic>();
  final List result = await mysqlLogic.GetComments(cid);
  // print(result);
  return Response.json(body: result);
}
