import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTestTab extends StatefulWidget {
  const ApiTestTab({super.key});

  @override
  State<ApiTestTab> createState() => _ApiTestTabState();
}

class _ApiTestTabState extends State<ApiTestTab> {
  String _result = 'Tap a button to test API.';
  bool _loading = false;

  Future<void> _callOkApi() async {
    setState(() {
      _loading = true;
      _result = 'Loading OK API...';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final prettyBody = const JsonEncoder.withIndent('  ').convert(body);

        setState(() {
          _result = 'OK (${response.statusCode})\nbody: $prettyBody';
        });
      } else {
        setState(() {
          _result = 'Unexpected status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Request failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _callFailedApi() async {
    setState(() {
      _loading = true;
      _result = 'Loading failed API...';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/unknown-endpoint'),
      );

      setState(() {
        _result =
            'Failed API response\nstatus: ${response.statusCode}\nbody: ${response.body}';
      });
    } catch (e) {
      setState(() {
        _result = 'Request failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _callOkApi,
              child: const Text('Call OK API'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _callFailedApi,
              child: const Text('Call Failed API'),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(child: SelectableText(_result)),
            ),
          ],
        ),
      ),
    );
  }
}
