import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_website_model.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/access_denied_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/login_redirect_url_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/timeout_extract.dart';
import 'package:dhbwstudentapp/dualis/service/parsing/urls_from_main_page_extract.dart';
import 'package:dhbwstudentapp/dualis/service/session.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:http/http.dart';

///
/// This class handles the dualis authentication. To make api calls first login
/// with the username and password and then use the [authenticatedGet] method.
///
class DualisAuthentication {
  final RegExp _tokenRegex = RegExp("ARGUMENTS=-N([0-9]{15})");

  String _username;
  String _password;

  DualisUrls _dualisUrls;
  DualisUrls get dualisUrls => _dualisUrls;

  String _authToken;
  Session _session;

  LoginResult _loginState = LoginResult.LoggedOut;
  LoginResult get loginState => _loginState;

  Future<LoginResult> login(
    String username,
    String password,
    CancellationToken cancellationToken,
  ) async {
    username = username ?? this._username;
    password = password ?? this._password;

    _dualisUrls = dualisUrls ?? DualisUrls();

    this._username = username;
    this._password = password;

    _session = Session();

    var loginResponse = await _makeLoginRequest(
      username,
      password,
      cancellationToken,
    );

    if (loginResponse == null ||
        loginResponse.statusCode != 200 ||
        !loginResponse.headers.containsKey("refresh")) {
      _loginState = LoginResult.LoginFailed;
      return loginState;
    }

    // TODO: Test for login failed page

    var redirectUrl = LoginRedirectUrlExtract().getUrlFromHeader(
      loginResponse.headers['refresh'],
      dualisEndpoint,
    );

    if (redirectUrl == null) {
      _loginState = LoginResult.LoginFailed;
      return loginState;
    }

    var redirectPage = await _session.get(
      redirectUrl,
      cancellationToken,
    );

    dualisUrls.mainPageUrl = LoginRedirectUrlExtract().readRedirectUrl(
      redirectPage,
      dualisEndpoint,
    );

    if (dualisUrls.mainPageUrl == null) {
      _loginState = LoginResult.LoginFailed;
      return loginState;
    }

    _updateAccessToken(dualisUrls.mainPageUrl);

    var mainPage = await _session.get(
      dualisUrls.mainPageUrl,
      cancellationToken,
    );

    UrlsFromMainPageExtract().parseMainPage(
      mainPage,
      dualisUrls,
      dualisEndpoint,
    );

    _loginState = LoginResult.LoggedIn;
    return loginState;
  }

  Future<Response> _makeLoginRequest(
    String user,
    String password, [
    CancellationToken cancellationToken,
  ]) async {
    var loginUrl = dualisEndpoint + "/scripts/mgrqispi.dll";

    var data = {
      "usrname": user,
      "pass": password,
      "APPNAME": "CampusNet",
      "PRGNAME": "LOGINCHECK",
      "ARGUMENTS": "clino,usrname,pass,menuno,menu_type,browser,platform",
      "clino": "000000000000001",
      "menuno": "000324",
      "menu_type": "classic",
    };

    try {
      var loginResponse = await _session.rawPost(
        loginUrl,
        data,
        cancellationToken,
      );
      return loginResponse;
    } on ServiceRequestFailed {
      return null;
    }
  }

  ///
  /// Use this method to make GET requests to the dualis service.
  ///
  /// This method handles the authentication cookie and token. If the session
  /// timed out, it will renew the session by logging in again
  ///
  Future<String> authenticatedGet(
    String url,
    CancellationToken cancellationToken,
  ) async {
    var result = await _session.get(
      _fillUrlWithAuthToken(url),
      cancellationToken,
    );

    cancellationToken?.throwIfCancelled();

    if (!TimeoutExtract().isTimeoutErrorPage(result) &&
        !AccessDeniedExtract().isAccessDeniedPage(result)) {
      return result;
    }

    var loginResult = await login(_username, _password, cancellationToken);

    if (loginResult == LoginResult.LoggedIn) {
      return await _session.get(
        _fillUrlWithAuthToken(url),
        cancellationToken,
      );
    }

    return null;
  }

  Future<void> logout([
    CancellationToken cancellationToken,
  ]) async {
    var logoutRequest = _session.get(dualisUrls.logoutUrl, cancellationToken);

    _session = null;
    _dualisUrls = null;

    await logoutRequest;
  }

  ///
  /// After the login sequence call this method with an url which contains the
  /// new authentication token. The url of every subsequent api call must be
  /// wrapped in a [fillUrlWithAuthToken()] call
  ///
  void _updateAccessToken(String urlWithNewToken) {
    var tokenMatch = _tokenRegex.firstMatch(urlWithNewToken);

    if (tokenMatch == null) return;

    _authToken = tokenMatch.group(1);
  }

  ///
  /// The dualis urls contain an authentication token which changes with every new login.
  /// When an api call is made with an old authentication token it will result in a
  /// permission denied error. So before every api call you have to fill in the
  /// updated api token
  ///
  String _fillUrlWithAuthToken(String url) {
    var match = _tokenRegex.firstMatch(url);
    if (match != null) {
      return url.replaceRange(
          match.start, match.end, "ARGUMENTS=-N$_authToken");
    }

    return url;
  }
}
