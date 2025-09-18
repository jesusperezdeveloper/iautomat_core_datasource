import 'package:iaut_core_datasource/iaut_core_datasource.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create success result', () {
        const result = Result.success(42);

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.getOrNull(), equals(42));
        expect(result.getOrElse(0), equals(42));
      });

      test('should map value correctly', () {
        const result = Result.success(5);
        final mapped = result.map((value) => value * 2);

        expect(mapped.isSuccess, isTrue);
        expect(mapped.getOrNull(), equals(10));
      });

      test('should flatMap correctly', () {
        const result = Result.success(5);
        final flatMapped = result.flatMap((value) => Result.success(value * 3));

        expect(flatMapped.isSuccess, isTrue);
        expect(flatMapped.getOrNull(), equals(15));
      });

      test('should handle when with onSuccess', () {
        const result = Result.success('test');

        final output = result.when(
          onSuccess: (value) => 'Success: $value',
          onFailure: (failure) => 'Failure: ${failure.message}',
        );

        expect(output, equals('Success: test'));
      });
    });

    group('Failure', () {
      test('should create failure result', () {
        const failure = NetworkFailure(message: 'Network error');
        const result = Result<int>.failure(failure);

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.getOrNull(), isNull);
        expect(result.getOrElse(42), equals(42));
      });

      test('should preserve failure in map', () {
        const failure = NetworkFailure(message: 'Network error');
        const result = Result<int>.failure(failure);
        final mapped = result.map((value) => value * 2);

        expect(mapped.isFailure, isTrue);
        expect(mapped.getOrNull(), isNull);
      });

      test('should preserve failure in flatMap', () {
        const failure = NetworkFailure(message: 'Network error');
        const result = Result<int>.failure(failure);
        final flatMapped = result.flatMap((value) => Result.success(value * 3));

        expect(flatMapped.isFailure, isTrue);
        expect(flatMapped.getOrNull(), isNull);
      });

      test('should handle when with onFailure', () {
        const failure = NetworkFailure(message: 'Network error');
        const result = Result<String>.failure(failure);

        final output = result.when(
          onSuccess: (value) => 'Success: $value',
          onFailure: (failure) => 'Failure: ${failure.message}',
        );

        expect(output, equals('Failure: Network error'));
      });
    });

    group('Equality', () {
      test('should be equal when success values are equal', () {
        const result1 = Result.success(42);
        const result2 = Result.success(42);

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should be equal when failure types and messages are equal', () {
        const failure1 = NetworkFailure(message: 'Error');
        const failure2 = NetworkFailure(message: 'Error');
        const result1 = Result<int>.failure(failure1);
        const result2 = Result<int>.failure(failure2);

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should not be equal when values differ', () {
        const result1 = Result.success(42);
        const result2 = Result.success(24);

        expect(result1, isNot(equals(result2)));
      });
    });
  });
}
