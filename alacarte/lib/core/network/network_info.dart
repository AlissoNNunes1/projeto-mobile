import 'package:connectivity_plus/connectivity_plus.dart';

/// [NetworkInfo] é uma abstração para verificar o estado da conectividade.
/// Usada para determinar se o dispositivo está conectado à Internet.
abstract class NetworkInfo {
  /// Retorna `true` se o dispositivo estiver conectado à Internet.
  Future<bool> get isConnected;
}

/// Implementação concreta da classe [NetworkInfo] usando o pacote connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
