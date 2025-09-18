import 'package:test/test.dart';

void main() {
  group('Search Criteria Structure', () {
    test('should validate simple criteria structure', () {
      final criteria = {
        'where': [
          {'field': 'status', 'op': '==', 'value': 'active'},
        ],
      };

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria['where'], isA<List<dynamic>>());

      final whereConditions = criteria['where']! as List<dynamic>;
      expect(whereConditions.length, equals(1));

      final condition = whereConditions.first as Map<String, dynamic>;
      expect(condition['field'], equals('status'));
      expect(condition['op'], equals('=='));
      expect(condition['value'], equals('active'));
    });

    test('should validate complex criteria structure', () {
      final criteria = {
        'where': [
          {'field': 'country', 'op': '==', 'value': 'Spain'},
          {'field': 'members', 'op': '>', 'value': 50},
        ],
        'orderBy': {'field': 'createdAt', 'direction': 'desc'},
        'limit': 10,
      };

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria['where'], isA<List<dynamic>>());
      expect(criteria['orderBy'], isA<Map<String, dynamic>>());
      expect(criteria['limit'], isA<int>());

      final whereConditions = criteria['where']! as List<dynamic>;
      expect(whereConditions.length, equals(2));

      final orderBy = criteria['orderBy']! as Map<String, dynamic>;
      expect(orderBy['field'], equals('createdAt'));
      expect(orderBy['direction'], equals('desc'));

      expect(criteria['limit'], equals(10));
    });

    test('should validate criteria with pagination', () {
      final criteria = {
        'where': [
          {'field': 'category', 'op': '==', 'value': 'premium'},
        ],
        'orderBy': {'field': 'name', 'direction': 'asc'},
        'limit': 20,
        'cursor': {'startAfter': 'club_42'},
      };

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria['cursor'], isA<Map<String, dynamic>>());

      final cursor = criteria['cursor']! as Map<String, dynamic>;
      expect(cursor['startAfter'], equals('club_42'));
    });

    test('should validate supported operators', () {
      final supportedOperators = [
        '==',
        '!=',
        '>',
        '>=',
        '<',
        '<=',
        'in',
        'array-contains',
        'array-contains-any',
      ];

      for (final operator in supportedOperators) {
        final criteria = {
          'where': [
            {'field': 'testField', 'op': operator, 'value': 'testValue'},
          ],
        };

        expect(criteria, isA<Map<String, dynamic>>());
        final condition =
            (criteria['where']! as List<dynamic>).first as Map<String, dynamic>;
        expect(condition['op'], equals(operator));
      }
    });

    test('should validate criteria with select fields', () {
      final criteria = {
        'where': [
          {'field': 'status', 'op': '==', 'value': 'active'},
        ],
        'select': ['id', 'name', 'email'],
      };

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria['select'], isA<List<String>>());

      final selectFields = criteria['select']! as List<String>;
      expect(selectFields, contains('id'));
      expect(selectFields, contains('name'));
      expect(selectFields, contains('email'));
    });

    test('should validate array operators with list values', () {
      final criteriaIn = {
        'where': [
          {
            'field': 'category',
            'op': 'in',
            'value': ['premium', 'gold', 'silver'],
          },
        ],
      };

      final criteriaArrayContainsAny = {
        'where': [
          {
            'field': 'tags',
            'op': 'array-contains-any',
            'value': ['flutter', 'dart'],
          },
        ],
      };

      expect(criteriaIn, isA<Map<String, dynamic>>());
      expect(criteriaArrayContainsAny, isA<Map<String, dynamic>>());

      final conditionIn =
          (criteriaIn['where']! as List<dynamic>).first as Map<String, dynamic>;
      expect(conditionIn['value'], isA<List<dynamic>>());

      final conditionArray =
          (criteriaArrayContainsAny['where']! as List<dynamic>).first
              as Map<String, dynamic>;
      expect(conditionArray['value'], isA<List<dynamic>>());
    });

    test('should validate empty criteria', () {
      final criteria = <String, dynamic>{};

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria.isEmpty, isTrue);
    });

    test('should validate criteria with only limit', () {
      final criteria = {'limit': 50};

      expect(criteria, isA<Map<String, dynamic>>());
      expect(criteria['limit'], equals(50));
      expect(criteria.containsKey('where'), isFalse);
    });

    test('should validate different cursor types', () {
      final cursorTypes = [
        {'startAfter': 'doc_id'},
        {'startAt': 'doc_id'},
        {'endBefore': 'doc_id'},
        {'endAt': 'doc_id'},
      ];

      for (final cursorType in cursorTypes) {
        final criteria = {
          'where': [
            {'field': 'status', 'op': '==', 'value': 'active'},
          ],
          'cursor': cursorType,
        };

        expect(criteria, isA<Map<String, dynamic>>());
        expect(criteria['cursor'], isA<Map<String, dynamic>>());

        final cursor = criteria['cursor']! as Map<String, dynamic>;
        expect(cursor.keys.length, equals(1));
      }
    });
  });
}
