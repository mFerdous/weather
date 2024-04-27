import 'dart:convert';

class FailureResponseModel {
  final String message;
  final String? error;

  FailureResponseModel(this.message, {this.error});

  factory FailureResponseModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> decodedResponse = json.decode(jsonString);
    String msg = "";
    String? error;
    if (decodedResponse.containsKey("message")) {
      msg = decodedResponse["message"];
    }
    if (decodedResponse.containsKey("error")) {
      error = decodedResponse["error"];
    }
    return FailureResponseModel(msg, error: error);
  }
}
