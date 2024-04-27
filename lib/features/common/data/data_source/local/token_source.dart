import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenSource {
  static const kAccessTokenKey = "access_token";
  static const kRefreshTokenKey = "refresh_token";
  static const kTokenExpTimeKey = "token_exp_time";
  Future<bool> saveToken(String token);
  Future<bool> saveRefreshToken(String refreshToken);
  Future<bool> saveTokenExpTime(int tokenExpTime);
  String getToken();
  String getRefreshToken();
  String getTokenExpTime();
}

class TokenSourceImpl implements TokenSource {
  final SharedPreferences _preference;

  TokenSourceImpl(this._preference);
  @override
  String getToken() {
    return _preference.getString(TokenSource.kAccessTokenKey) ?? "NO_TOKEN";
  }

  @override
  Future<bool> saveToken(String token) {
    return _preference.setString(TokenSource.kAccessTokenKey, token);
  }
  @override
  String getRefreshToken() {
    return _preference.getString(TokenSource.kRefreshTokenKey) ?? "NO_REFRESH_TOKEN";
  }

  @override
  Future<bool> saveRefreshToken(String refreshToken) {
    return _preference.setString(TokenSource.kRefreshTokenKey, refreshToken);
  }



  @override
  String getTokenExpTime() {
    return _preference.getString(TokenSource.kTokenExpTimeKey) ?? "NO_TOKEN_EXP_TIME";
  }

  @override
  Future<bool> saveTokenExpTime(int tokenExpTime) {
    return _preference.setString(TokenSource.kTokenExpTimeKey, tokenExpTime.toString());
  }




}
