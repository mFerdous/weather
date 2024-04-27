import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectionChecker {
  Future<bool> isConnected();
}

class ConnectionCheckerImpl implements ConnectionChecker {
  @override
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}

Future<bool> checkInternetConnection() async {
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
    return true; // Device is connected to the internet via mobile data or Wi-Fi
  } else {
    return false; // Device is not connected to the internet
  }
}

