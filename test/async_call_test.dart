import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unit_testing/counter.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

//Tests go into main method
main() {
  final Counter counter = Counter();
  group('fetchPost', () {
    test('returns a Post if the http call completes successfully', () async {
      final client = MockClient();

      // Using Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
          .thenAnswer(
              (_) async => http.Response(json.encode({"title": "Test"}), 200));

      Post post = await counter.fetchPost(client);
      expect(post.title, "Test");
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      // Using Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(counter.fetchPost(client), throwsException);
    });
  });
}
