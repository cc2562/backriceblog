import 'dart:io';

import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

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
  final getCid = params['cid'];
  int cid = 1;
  if (getCid == null || getCid == '') {
    cid = 1;
  } else {
    cid = int.parse(getCid);
  }
  final mysqlLogic = context.read<Mysqllogic>();
  Map result = await mysqlLogic.GetSinglePost(cid);
  List toReturn = [];
  toReturn.add(result);
  // print(result);
  return Response.json(body: toReturn);
}
