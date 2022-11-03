import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DonateListTile extends StatefulWidget {
  const DonateListTile({Key? key}) : super(key: key);

  @override
  _DonateListTileState createState() => _DonateListTileState();
}

class _DonateListTileState extends State<DonateListTile> {
  final InAppPurchaseManager inAppPurchaseManager;

  late SettingsViewModel model;

  bool isPurchasing = false;

  _DonateListTileState() : inAppPurchaseManager = KiwiContainer().resolve();

  @override
  void initState() {
    super.initState();

    inAppPurchaseManager.addPurchaseCallback(null, purchaseCallback);
  }

  @override
  void dispose() {
    super.dispose();

    inAppPurchaseManager.removePurchaseCallback(null, purchaseCallback);
  }

  void purchaseCallback(String? productId, PurchaseResultEnum result) {
    if (!mounted) return;

    setState(() {
      isPurchasing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model = PropertyChangeProvider.of<SettingsViewModel, String>(
      context,
      properties: const [
        "didPurchaseWidget",
      ],
    )!
        .value;

    if (model.widgetPurchaseState == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (model.widgetPurchaseState == PurchaseStateEnum.NotPurchased) {
      return ListTile(
        title: Text(L.of(context).donateButtonTitle),
        subtitle: isPurchasing
            ? const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
            : Text(L.of(context).donateButtonSubtitle),
        trailing: const Icon(Icons.free_breakfast),
        onTap: _purchaseClicked,
      );
    }

    return Container();
  }

  Future<void> _purchaseClicked() async {
    if (isPurchasing ||
        model.widgetPurchaseState == PurchaseStateEnum.Purchased) return;

    setState(() {
      isPurchasing = true;
    });

    await model.donate();
  }
}
