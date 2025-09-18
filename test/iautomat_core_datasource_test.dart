import 'package:test/test.dart';
import 'package:iaut_core_datasource/iaut_core_datasource.dart';

void main() {
  test('package exports work correctly', () {
    // Test that we can create basic types
    const success = Result.success(42);
    const failure = NetworkFailure(message: 'Test error');
    const page = Page<int>.empty();
    const cursor = PageCursor('test');
    const spec = QuerySpec.empty();

    expect(success.isSuccess, isTrue);
    expect(failure.message, equals('Test error'));
    expect(page.isEmpty, isTrue);
    expect(cursor.value, equals('test'));
    expect(spec.hasWhere, isFalse);
  });
}
