import 'package:backriceblog/mysql/mysqlLogic.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<Mysqllogic>(
          (_) => Mysqllogic(),
        ),
      )
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            },
          ),
        ),
      );
}
