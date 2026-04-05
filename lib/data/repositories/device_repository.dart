import '../models/device_model.dart';
import '../services/device_service.dart';

class DeviceRepository {
  final DeviceService _deviceService = DeviceService();

  Stream<List<DeviceModel>> getDevicesStream(String userId) {
    return _deviceService.getDevicesStream(userId);
  }

  Future<DeviceModel?> getDevice(String deviceId) {
    return _deviceService.getDevice(deviceId);
  }

  Future<void> toggleDevice(String deviceId, bool isOn) {
    return _deviceService.toggleDevice(deviceId, isOn);
  }

  Future<void> updateTemperature(String deviceId, double temperature) {
    return _deviceService.updateTemperature(deviceId, temperature);
  }

  void startMockDataStream(DeviceModel device, Function(DeviceModel) onUpdate) {
    _deviceService.startMockDataStream(device, onUpdate);
  }

  void stopMockDataStream() {
    _deviceService.stopMockDataStream();
  }

  void dispose() {
    _deviceService.dispose();
  }
}