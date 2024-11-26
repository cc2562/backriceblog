import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<Mysqllogic>(
      (_) => Mysqllogic(),
    ),
  );
}
