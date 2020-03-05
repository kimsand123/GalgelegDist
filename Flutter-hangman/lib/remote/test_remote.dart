import 'package:http/http.dart' as http;

class TestRemote {
  Future testGetPostPut() async {
    print("Test - 1/5 (_testGetRequest)");
    await _testGetRequest();

    print("Test - 2/5 (_testPostRequest)");
    await _testPostRequest(
        '{"title": "Hello", "body": "body text", "userId": 1}');

    print("Test - 3/5 (_testPutRequest)");
    await _testPutRequest(
        '{"title": "Hello", "body": "body text", "userId": 1}');

    print("Test - 4/5 (_testPatchRequest)");
    await _testPatchRequest('{"title": "Hello"}');

    print("Test - 5/5 (_testDeleteRequest)");
    await _testDeleteRequest();

    return;
  }

  _testGetRequest() async {
    // Setup header, url for http call
    String url = 'https://jsonplaceholder.typicode.com/posts';

    // Make http call, save in response object
    http.Response response = await http.get(url);

    // Print response for testing purposes
    print(
        'Test GET: ${response.statusCode}-${response.reasonPhrase}, ${response.body}');
  }

  _testPostRequest(String json) async {
    // Setup header, url for http call
    String url = 'https://jsonplaceholder.typicode.com/posts';
    Map<String, String> headers = {"Content-type": "application/json"};

    // Make http call, save in response object
    http.Response response = await http.post(url, headers: headers, body: json);

    // Print response for testing purposes
    print(
        'Test POST: ${response.statusCode}-${response.reasonPhrase}, ${response.body}');
  }

  _testPutRequest(String json) async {
    // Setup header, url for http call
    String url = 'https://jsonplaceholder.typicode.com/posts/1';
    Map<String, String> headers = {"Content-type": "application/json"};

    // Make http call, save in response object
    http.Response response = await http.put(url, headers: headers, body: json);

    // Print response for testing purposes
    print(
        'Test PUT: ${response.statusCode}-${response.reasonPhrase}, ${response.body}');
  }

  _testPatchRequest(String json) async {
    // Setup header, url for http call
    String url = 'https://jsonplaceholder.typicode.com/posts/1';
    Map<String, String> headers = {"Content-type": "application/json"};

    // Make http call, save in response object
    http.Response response =
        await http.patch(url, headers: headers, body: json);

    // Print response for testing purposes
    print(
        'Test PATCH: ${response.statusCode}-${response.reasonPhrase}, ${response.body}');
  }

  _testDeleteRequest() async {
    // Setup header, url for http call
    String url = 'https://jsonplaceholder.typicode.com/posts/1';

    // Make http call, save in response object
    http.Response response = await http.delete(url);

    // Print response for testing purposes
    print('Test DELETE: ${response.statusCode}-${response.reasonPhrase}');
  }
}
