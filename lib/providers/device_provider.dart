import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../data/models/device_model.dart';
import '../../data/repositories/device_repository.dart';

enum DeviceState {
  initial,
  loading,
  loaded,
  error,
}

class DeviceProvider extends ChangeNotifier {
  final DeviceRepository _deviceRepository = DeviceRepository();
  final Random _random = Random();

  DeviceState _state = DeviceState.initial;
  List<DeviceModel> _devices = [];
  DeviceModel? _selectedDevice;
  String? _errorMessage;
  StreamSubscription? _devicesSubscription;
  bool _useMockData = false;

  DeviceState get state => _state;
  List<DeviceModel> get devices => _devices;
  DeviceModel? get selectedDevice => _selectedDevice;
  String? get errorMessage => _errorMessage;
  bool get hasDevices => _devices.isNotEmpty;

  Future<void> loadDevices(String userId) async {
    _state = DeviceState.loading;
    _useMockData = false;
    notifyListeners();

    try {
      _devicesSubscription?.cancel();
      _devicesSubscription = _deviceRepository.getDevicesStream(userId).listen(
        (devices) {
          _devices = devices;
          _state = DeviceState.loaded;
          
          if (_selectedDevice != null) {
            final updatedSelected = devices.where((d) => d.id == _selectedDevice!.id).firstOrNull;
            if (updatedSelected != null) {
              _selectedDevice = updatedSelected;
            }
          }
          
          notifyListeners();
        },
        onError: (e) {
          _loadMockDevices(userId);
        },
      );
    } catch (e) {
      _loadMockDevices(userId);
    }
  }

  void _loadMockDevices(String userId) {
    _useMockData = true;
    _devices = [DeviceModel.mock(userId)];
    _state = DeviceState.loaded;
    notifyListeners();

    if (_devices.isNotEmpty) {
      _startMockDataStream();
    }
  }

  void _startMockDataStream() {
    if (_devices.isEmpty) return;

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_useMockData && _devices.isNotEmpty) {
        final device = _devices.first;
        if (device.isOn) {
          final newTemp = 28.0 + _random.nextDouble() * 7;
          final updatedDevice = device.copyWith(
            temperature: newTemp,
            lastUpdated: DateTime.now(),
          );
          _devices = [updatedDevice];
          
          if (_selectedDevice != null && _selectedDevice!.id == device.id) {
            _selectedDevice = updatedDevice;
          }
          
          notifyListeners();
        }
      }
    });
  }

  void selectDevice(DeviceModel device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void clearSelectedDevice() {
    _selectedDevice = null;
    notifyListeners();
  }

  Future<void> toggleDevice(String deviceId, bool isOn) async {
    if (_useMockData) {
      final index = _devices.indexWhere((d) => d.id == deviceId);
      if (index != -1) {
        final device = _devices[index];
        final updatedDevice = device.copyWith(
          isOn: isOn,
          lastUpdated: DateTime.now(),
        );
        _devices = List.from(_devices);
        _devices[index] = updatedDevice;
        
        if (_selectedDevice?.id == deviceId) {
          _selectedDevice = updatedDevice;
        }
        
        notifyListeners();
      }
      return;
    }

    try {
      await _deviceRepository.toggleDevice(deviceId, isOn);
    } catch (e) {
      _errorMessage = 'Failed to toggle device';
      notifyListeners();
    }
  }

  Future<void> refreshDevices(String userId) async {
    _devicesSubscription?.cancel();
    await loadDevices(userId);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _devicesSubscription?.cancel();
    _deviceRepository.dispose();
    super.dispose();
  }
}