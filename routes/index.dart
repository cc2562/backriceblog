import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final request = context.request;
  final method = request.method.value;
  final header = request.headers;

  //获取Params
  final params = request.uri.queryParameters;
  final name = params['name'];
  /*
 return Response(
      body:
          'Welcome to CCRICE\nThe method is:' + method + 'Your name is $name');
          */
  if (name == null || name == "") {
    // print("NO");
    return Response(statusCode: HttpStatus.httpVersionNotSupported);
  }
  return Response.json(body: {'hello': 'world', 'name': name});
}
