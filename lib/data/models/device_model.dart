import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String id;
  final String userId;
  final String name;
  final double temperature;
  final bool isOn;
  final DateTime lastUpdated;
  final DateTime createdAt;
  final bool isOnline;

  DeviceModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.temperature,
    required this.isOn,
    required this.lastUpdated,
    required this.createdAt,
    this.isOnline = true,
  });

  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeviceModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Unknown Device',
      temperature: (data['temperature'] as num?)?.toDouble() ?? 0.0,
      isOn: data['status'] == 'on',
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: data['isOnline'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'temperature': temperature,
      'status': isOn ? 'on' : 'off',
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'createdAt': Timestamp.fromDate(createdAt),
      'isOnline': isOnline,
    };
  }

  DeviceModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? temperature,
    bool? isOn,
    DateTime? lastUpdated,
    DateTime? createdAt,
    bool? isOnline,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      temperature: temperature ?? this.temperature,
      isOn: isOn ?? this.isOn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  static DeviceModel mock(String userId) {
    final now = DateTime.now();
    return DeviceModel(
      id: 'mock-device-001',
      userId: userId,
      name: 'Living Room Sensor',
      temperature: 31.5,
      isOn: true,
      lastUpdated: now,
      createdAt: now.subtract(const Duration(days: 7)),
      isOnline: true,
    );
  }
}