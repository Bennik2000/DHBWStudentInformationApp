import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EnterRaplaUrlDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSource;

  final TextEditingController _urlTextController = TextEditingController();
  final ValueNotifier<bool> _hasUrlError = ValueNotifier<bool>(false);
  final ValueNotifier<String> _url = ValueNotifier<String>("");

  EnterRaplaUrlDialog(this._preferencesProvider, this._scheduleSource) {
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
      title: Text(L.of(context).dialogSetRaplaUrlTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Text(
              L.of(context).onboardingRaplaPageDescription,
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
                      Widget child,
                    ) {
                      if (_urlTextController.text != url.value)
                        _urlTextController.text = url.value;

                      return Consumer(
                        builder: (
                          BuildContext context,
                          ValueNotifier<bool> hasUrlError,
                          Widget child,
                        ) =>
                            TextField(
                          controller: _urlTextController,
                          decoration: InputDecoration(
                            errorText: hasUrlError.value
                                ? L.of(context).onboardingRaplaUrlInvalid
                                : null,
                            hintText: L.of(context).onboardingRaplaUrlHint,
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
      FlatButton(
        child: Text(L.of(context).dialogCancel.toUpperCase()),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      ListenableProvider.value(
        value: _hasUrlError,
        child: Consumer(
          builder: (BuildContext context, ValueNotifier<bool> hasUrlError,
                  Widget child) =>
              FlatButton(
            child: Text(L.of(context).dialogOk.toUpperCase()),
            onPressed: hasUrlError.value
                ? null
                : () async {
                    Navigator.of(context).pop();

                    await _saveUrl();
                  },
          ),
        ),
      ),
    ];
  }

  Future _pasteUrl() async {
    ClipboardData data = await Clipboard.getData('text/plain');

    if (data?.text != null) {
      _setUrl(data.text);
    }
  }

  void _setUrl(String url) {
    _url.value = url;
    _validateUrl();
  }

  void _validateUrl() {
    try {
      RaplaScheduleSource().validateEndpointUrl(_url.value);

      _hasUrlError.value = false;
    } catch (e) {
      _hasUrlError.value = true;
    }
  }

  Future _saveUrl() async {
    await _scheduleSource.setupForRapla(_url.value);
  }

  Future _loadUrl() async {
    _setUrl(await _preferencesProvider.getRaplaUrl());
  }
}
