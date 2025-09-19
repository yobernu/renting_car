import 'dart:async';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final http.Client _client;

  NetworkInfoImpl({
    required Connectivity connectivity,
    required http.Client client,
  }) : _connectivity = connectivity,
       _client = client;

  @override
  Future<bool> get isConnected async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      try {
        final response = await _client
            .get(Uri.parse('https://www.gstatic.com/generate_204'))
            .timeout(const Duration(seconds: 3));
        return response.statusCode == 204;
      } catch (e) {
        return false;
      }
    } catch (e) {
      developer.log('Network check error: $e');
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) => isConnected);
  }
}
