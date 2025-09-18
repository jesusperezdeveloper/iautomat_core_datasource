import 'package:iaut_core_datasource/iaut_core_datasource.dart';
import 'package:test/test.dart';

void main() {
  group('DsFailure', () {
    test('NetworkFailure should have correct message', () {
      const failure = NetworkFailure(message: 'Connection failed');

      expect(failure.message, equals('Connection failed'));
      expect(failure.toString(), equals('NetworkFailure: Connection failed'));
    });

    test('TimeoutFailure should have default message', () {
      const failure = TimeoutFailure();

      expect(failure.message, equals('Tiempo de espera agotado'));
      expect(failure.toString(), equals('TimeoutFailure: Tiempo de espera agotado'));
    });

    test('PermissionDeniedFailure should have custom message', () {
      const failure = PermissionDeniedFailure(message: 'Access denied');

      expect(failure.message, equals('Access denied'));
      expect(failure.toString(), equals('PermissionDeniedFailure: Access denied'));
    });

    test('NotFoundFailure should work correctly', () {
      const failure = NotFoundFailure(message: 'User not found');

      expect(failure.message, equals('User not found'));
      expect(failure.toString(), equals('NotFoundFailure: User not found'));
    });

    test('ConflictFailure should work correctly', () {
      const failure = ConflictFailure(message: 'Data conflict');

      expect(failure.message, equals('Data conflict'));
      expect(failure.toString(), equals('ConflictFailure: Data conflict'));
    });

    test('SerializationFailure should work correctly', () {
      const failure = SerializationFailure(message: 'JSON parse error');

      expect(failure.message, equals('JSON parse error'));
      expect(failure.toString(), equals('SerializationFailure: JSON parse error'));
    });

    test('CancelledFailure should work correctly', () {
      const failure = CancelledFailure(message: 'Operation cancelled');

      expect(failure.message, equals('Operation cancelled'));
      expect(failure.toString(), equals('CancelledFailure: Operation cancelled'));
    });

    test('UnknownFailure should work correctly', () {
      const failure = UnknownFailure(message: 'Something went wrong');

      expect(failure.message, equals('Something went wrong'));
      expect(failure.toString(), equals('UnknownFailure: Something went wrong'));
    });

    test('should handle cause and stackTrace', () {
      final cause = Exception('Original error');
      final stackTrace = StackTrace.current;
      final failure = NetworkFailure(
        message: 'Network error',
        cause: cause,
        stackTrace: stackTrace,
      );

      expect(failure.cause, equals(cause));
      expect(failure.stackTrace, equals(stackTrace));
    });

    group('Equality', () {
      test('should be equal when type and message are same', () {
        const failure1 = NetworkFailure(message: 'Error');
        const failure2 = NetworkFailure(message: 'Error');

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when messages differ', () {
        const failure1 = NetworkFailure(message: 'Error 1');
        const failure2 = NetworkFailure(message: 'Error 2');

        expect(failure1, isNot(equals(failure2)));
      });

      test('should not be equal when types differ', () {
        const failure1 = NetworkFailure(message: 'Error');
        const failure2 = TimeoutFailure(message: 'Error');

        expect(failure1, isNot(equals(failure2)));
      });
    });
  });
}
