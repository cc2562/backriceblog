// lib/_middleware.dart

import 'package:backriceblog/authenticator.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<Authenticator>(
      (_) => Authenticator(),
    ),
  );
}
