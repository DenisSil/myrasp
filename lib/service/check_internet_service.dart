import 'dart:isolate';
import 'dart:io';

class CheckInternetService {
  static void checkInternetContection(SendPort internetConnectionPort) async {
    final stopwatch = Stopwatch();
    stopwatch.start();
    while (true) {
      if (stopwatch.elapsedMilliseconds > 3000) {
        stopwatch.reset();
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            internetConnectionPort.send(true);
          }
        } on SocketException catch (_) {
          internetConnectionPort.send(false);
        }
      }
    }
  }
}
