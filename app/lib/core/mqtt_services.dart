import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttService._();
  static final MqttService instance = MqttService._();

  final String broker = 'test.mosquitto.org';
  final int port = 1883;
  final String clientId = 'thedose-client';
  MqttServerClient? _client;

  Future<void> _ensureConnected() async {
    if (_client != null && _client!.connectionStatus?.state == MqttConnectionState.connected) return;

    final client = MqttServerClient(broker, clientId)
      ..port = port
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..secure = false;

    try {
      await client.connect();
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        _client = client;
      } else {
        throw Exception('MQTT connect failed');
      }
    } catch (e) {
      _client = null;
      rethrow;
    }
  }

  Future<void> publishSolution({required String amount, required String duration}) async {
    await _ensureConnected();
    final mlBuilder = MqttClientPayloadBuilder()..addString(amount);
    _client!.publishMessage('syringe/ml', MqttQos.atLeastOnce, mlBuilder.payload!);

    final timeBuilder = MqttClientPayloadBuilder()..addString(duration);
    _client!.publishMessage('syringe/time', MqttQos.atLeastOnce, timeBuilder.payload!);

    final cmdBuilder = MqttClientPayloadBuilder()..addString("1");
    _client!.publishMessage('syringe/cmd', MqttQos.atLeastOnce, cmdBuilder.payload!);
  }

  void listenToStatus(void Function(String) onStatus) {
    _client!.subscribe("syringe/status", MqttQos.atLeastOnce);
    _client!.updates!.listen((messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final msg = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      onStatus(msg);
    });
  }

  void publishStop() async {
    final stopBuilder = MqttClientPayloadBuilder()..addString("0");
    _client!.publishMessage('syringe/cmd', MqttQos.atLeastOnce, stopBuilder.payload!);
  }
}
