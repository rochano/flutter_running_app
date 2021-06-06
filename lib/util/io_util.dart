import 'dart:io';

import 'package:http/io_client.dart';

class IOUtil {
  static IOClient getIOClient() {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
    return ioClient;
  }
}
