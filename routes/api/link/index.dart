import 'dart:io';

import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

//获取友情链接
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
  final mysqlLogic = context.read<Mysqllogic>();
  final List<dynamic> result = await mysqlLogic.GetLinks();
  // print(result);
  return Response.json(body: result);
}
