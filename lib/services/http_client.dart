import 'dart:async';
import 'dart:io' as client;

import 'package:http/http.dart' as http;
import 'package:myhoneypott/constant/constant.dart';
import 'package:myhoneypott/models/api_response.dart';
import 'package:myhoneypott/models/delete_model.dart';

class HttpClient {
  Future<String> postHttpRequest(
    Map<String, String> queryParameters,
  ) async {
    try {
      var serviceURL = expenseURL;
      print(serviceURL);

      var uri = Uri.parse(serviceURL);

      var response = await http
          .post(
        uri,
        headers: {
          client.HttpHeaders.acceptHeader: "application/json",
        },
        body: queryParameters,
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        String responseBody =
            "{\"code\":\"9\",\"status\":\"0\",\"msg\":\"Request Timeout\"}";

        return http.Response(responseBody, client.HttpStatus.requestTimeout);
      });

      if (response.statusCode == client.HttpStatus.ok) {
        return response.body;
      } else if (response.statusCode == client.HttpStatus.requestTimeout) {
        throw TimeoutException("Request timeout");
      } else {
        throw Exception("Request failed");
      }
    } on TimeoutException {
      print("Request timeout");
      throw TimeoutException("Request timeout");
    } catch (e) {
      throw Exception(e);
    }
  }

  deleteExpense(int id) async {
    String token = await ApiResponse().getToken();
    var serviceURL = expenseURL;
    var uri = Uri.parse("$serviceURL/$id");

    // print(uri);
    final http.Response response = await http.delete(
      uri,
      headers: {
        client.HttpHeaders.acceptHeader: "application/json",
        'Authorization': 'Bearer $token',
      },
    );
  }
}
