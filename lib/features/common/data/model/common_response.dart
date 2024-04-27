// To parse this JSON data, do
//
//     final commonResponse = commonResponseFromJson(jsonString);

import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
    CommonResponse({
        required this.status,
        required this.code,
        required this.message,
    });

    bool status;
    int code;
    String message;

    factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
    };
}
