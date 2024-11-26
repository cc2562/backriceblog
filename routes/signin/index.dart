import 'dart:io';

import 'package:backriceblog/authenticator.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  final method = context.request.method;
  if (method == HttpMethod.post) {
    return _onPost(context);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final String username = body['username'].toString();
  final String password = body['password'].toString();
  //print(username);
  if (username == null || password.isEmpty) {
    // print("NO Give");
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<Authenticator>();

  final user = authenticator.findByUsernameAndPassword(
      username: username, password: password);
  // print(user!.password);
  if (user == null) {
    // print("unauth");
    return Response(statusCode: HttpStatus.unauthorized);
  } else {
    return Response.json(body: {'token': username});
  }
}
