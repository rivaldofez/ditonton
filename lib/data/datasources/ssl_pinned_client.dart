import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

Future<IOClient> createPinnedHttpClient() async {
  final certBytes = await rootBundle.load('assets/certificates.pem');

  final SecurityContext securityContext =
      SecurityContext(withTrustedRoots: false);

  securityContext.setTrustedCertificatesBytes(
    certBytes.buffer.asUint8List(),
  );

  final HttpClient httpClient = HttpClient(context: securityContext);

  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    return host == 'api.themoviedb.org';
  };

  return IOClient(httpClient);
}
