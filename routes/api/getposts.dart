import 'dart:io';

import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

//获取所有文章列表
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  //return Response(body: 'This is a new route!');
  final method = context.request.method;
  if (method == HttpMethod.get) {
    return await _onGetPost(context);
  } else {
    return Response(statusCode: HttpStatus.httpVersionNotSupported);
  }
}

Future<Response> _onGetPost(RequestContext context) async {
  final request = context.request;
  final params = request.uri.queryParameters;
  final getPage = params['page'];
  int page = 1;
  if (getPage == null || getPage == '') {
    page = 1;
  } else {
    page = int.parse(getPage);
  }
  final mysqlLogic = context.read<Mysqllogic>();
  final List result = await mysqlLogic.GetPosts(page);
  // print(result);
  return Response.json(body: result);
}
