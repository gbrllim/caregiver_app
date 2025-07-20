import 'package:flutter_test/flutter_test.dart';
import 'package:caregiver_app/models/caretakee_profile.dart';

void main() {
  group('ProfileService Tests', () {
    setUp(() {
      // Note: These are unit tests that focus on the model logic
      // Integration tests with Firebase would require proper setup
    });

    test('CaretakeeProfile model should serialize/deserialize correctly', () {
      final now = DateTime.now();
      final profile = CaretakeeProfile(
        id: 'test-id',
        caretakerId: 'caretaker-123',
        name: 'Test Profile',
        relationship: 'Brother',
        age: 25,
        createdAt: now,
        updatedAt: now,
      );

      // Test toJson
      final json = profile.toJson();
      expect(json['id'], equals('test-id'));
      expect(json['caretakerId'], equals('caretaker-123'));
      expect(json['name'], equals('Test Profile'));
      expect(json['relationship'], equals('Brother'));
      expect(json['age'], equals(25));
      expect(json['createdAt'], isA<String>());
      expect(json['updatedAt'], isA<String>());

      // Test fromJson
      final recreatedProfile = CaretakeeProfile.fromJson(json);
      expect(recreatedProfile.id, equals(profile.id));
      expect(recreatedProfile.caretakerId, equals(profile.caretakerId));
      expect(recreatedProfile.name, equals(profile.name));
      expect(recreatedProfile.relationship, equals(profile.relationship));
      expect(recreatedProfile.age, equals(profile.age));
    });

    test('CaretakeeProfile copyWith should work correctly', () {
      final now = DateTime.now();
      final original = CaretakeeProfile(
        id: 'test-id',
        caretakerId: 'caretaker-123',
        name: 'Original Name',
        relationship: 'Brother',
        age: 25,
        createdAt: now,
        updatedAt: now,
      );

      final updated = original.copyWith(name: 'Updated Name', age: 26);

      expect(updated.id, equals(original.id));
      expect(updated.caretakerId, equals(original.caretakerId));
      expect(updated.name, equals('Updated Name'));
      expect(updated.relationship, equals(original.relationship));
      expect(updated.age, equals(26));
      expect(updated.createdAt, equals(original.createdAt));
      expect(updated.updatedAt, equals(original.updatedAt));
    });

    test(
      'CaretakeeProfile fromJson should handle missing fields gracefully',
      () {
        final jsonWithMissingFields = <String, dynamic>{
          'id': 'test-id',
          'name': 'Test Name',
        };

        final profile = CaretakeeProfile.fromJson(jsonWithMissingFields);

        expect(profile.id, equals('test-id'));
        expect(profile.name, equals('Test Name'));
        expect(profile.caretakerId, equals(''));
        expect(profile.relationship, equals(''));
        expect(profile.age, equals(0));
        expect(profile.avatarUrl, isNull);
        expect(profile.createdAt, isA<DateTime>());
        expect(profile.updatedAt, isA<DateTime>());
      },
    );
  });
}
