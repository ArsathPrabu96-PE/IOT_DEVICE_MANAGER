import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';

class DeviceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();
  StreamSubscription? _mockUpdateSubscription;
  final _temperatureController = StreamController<double>.broadcast();

  Stream<double> get temperatureStream => _temperatureController.stream;

  Stream<List<DeviceModel>> getDevicesStream(String userId) {
    return _firestore
        .collection('devices')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => DeviceModel.fromFirestore(doc)).toList();
        });
  }

  Future<DeviceModel?> getDevice(String deviceId) async {
    try {
      final doc = await _firestore.collection('devices').doc(deviceId).get();
      if (doc.exists) {
        return DeviceModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> toggleDevice(String deviceId, bool isOn) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'status': isOn ? 'on' : 'off',
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTemperature(String deviceId, double temperature) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'temperature': temperature,
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      rethrow;
    }
  }

  void startMockDataStream(DeviceModel device, Function(DeviceModel) onUpdate) {
    _mockUpdateSubscription?.cancel();
    
    _mockUpdateSubscription = Stream.periodic(
      const Duration(seconds: 3),
    ).listen((_) {
      if (device.isOn) {
        final newTemp = 28.0 + _random.nextDouble() * 7;
        _temperatureController.add(newTemp);
        
        final updatedDevice = device.copyWith(
          temperature: newTemp,
          lastUpdated: DateTime.now(),
        );
        onUpdate(updatedDevice);
      }
    });
  }

  void stopMockDataStream() {
    _mockUpdateSubscription?.cancel();
    _mockUpdateSubscription = null;
  }

  void dispose() {
    _mockUpdateSubscription?.cancel();
    _temperatureController.close();
  }
}