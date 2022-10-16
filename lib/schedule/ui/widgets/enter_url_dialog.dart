import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

///
/// Shows a dialog to enter and validate an url
///
abstract class EnterUrlDialog {
  final TextEditingController _urlTextController = TextEditingController();
  final ValueNotifier<bool> _hasUrlError = ValueNotifier<bool>(false);
  final ValueNotifier<String> _url = ValueNotifier<String>("");

  EnterUrlDialog() {
    _loadUrl();
  }

  Future show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => _buildDialog(context),
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Text(
              message(context),
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: MultiProvider(
                  providers: [
                    ListenableProvider.value(value: _hasUrlError),
                    ListenableProvider.value(value: _url),
                  ],
                  child: Consumer(
                    builder: (
                      BuildContext context,
                      ValueNotifier<String> url,
                      Widget? child,
                    ) {
                      if (_urlTextController.text != url.value)
                        _urlTextController.text = url.value;

                      return Consumer(
                        builder: (
                          BuildContext context,
                          ValueNotifier<bool> hasUrlError,
                          Widget? child,
                        ) =>
                            TextField(
                          controller: _urlTextController,
                          decoration: InputDecoration(
                            errorText:
                                hasUrlError.value ? invalidUrl(context) : null,
                            hintText: hint(context),
                          ),
                          onChanged: (value) {
                            _setUrl(value);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await _pasteUrl();
                },
                tooltip: L.of(context).onboardingRaplaUrlPaste,
                icon: Icon(Icons.content_paste),
              ),
            ],
          ),
        ],
      ),
      actions: _buildButtons(context),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        child: Text(L.of(context).dialogCancel.toUpperCase()),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      ListenableProvider.value(
        value: _hasUrlError,
        child: Consumer(
          builder: (BuildContext context, ValueNotifier<bool> hasUrlError,
                  Widget? child) =>
              TextButton(
            child: Text(L.of(context).dialogOk.toUpperCase()),
            onPressed: hasUrlError.value
                ? null
                : () async {
                    Navigator.of(context).pop();

                    await saveUrl(_url.value);
                  },
          ),
        ),
      ),
    ];
  }

  Future _pasteUrl() async {
    ClipboardData? data = await Clipboard.getData('text/plain');

    if (data?.text != null) {
      _setUrl(data!.text!);
    }
  }

  Future _loadUrl() async {
    _url.value = await loadUrl() ?? "";
  }

  void _setUrl(String url) {
    _url.value = url;
    _validateUrl();
  }

  void _validateUrl() {
    _hasUrlError.value = !isValidUrl(_url.value);
  }

  bool isValidUrl(String? url);
  Future saveUrl(String? url);
  Future<String?> loadUrl();

  String title(BuildContext context);
  String message(BuildContext context);
  String hint(BuildContext context);
  String invalidUrl(BuildContext context);
}
