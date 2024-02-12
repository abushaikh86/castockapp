// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:http/http.dart' as http;
import 'package:stock_audit/util/constants.dart' as constants;

class SyncronizationData {
  static Future<bool> isInternet() async {
    if (await ConnectivityWrapper.instance.isConnected) {
      return true;
    } else {
      return false;
    }
  }

  static Future<dynamic> update_audit(postedData) async {
    var response = await http.post(
      Uri.parse('${constants.apiBaseURL}/update_audit'),
      body: {
        'posted_data': jsonEncode(postedData),
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }

  static Future<dynamic> update_audit_entries(postedData) async {
    var response = await http.post(
      Uri.parse('${constants.apiBaseURL}/update_audit_entries'),
      body: {
        'posted_data': jsonEncode(postedData),
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to Fetch Data: ${response.statusCode}');
    }
  }
}
