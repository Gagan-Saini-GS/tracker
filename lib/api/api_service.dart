import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  // Optional: You can pass your JWT token here
  final String? authToken;

  ApiService({required this.baseUrl, this.authToken});

  // GET request
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(),
    );
    return _processResponse(response);
  }

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    debugPrint(
      "Base URL ${Uri.parse('$baseUrl$endpoint')}, Body ${jsonEncode(body)}",
    );
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(),
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Builds the request headers
  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    debugPrint("Header $headers");
    return headers;
  }

  // Handles status codes & errors
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    debugPrint("Response $body");

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw Exception('API Error: $statusCode - ${response.body}');
    }
  }
}
