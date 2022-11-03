import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_helper.dart';
import 'package:dhbwstudentapp/common/iap/in_app_purchase_manager.dart';
import 'package:dhbwstudentapp/ui/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PurchaseWidgetListTile extends StatefulWidget {
  const PurchaseWidgetListTile({Key? key}) : super(key: key);

  @override
  _PurchaseWidgetListTileState createState() => _PurchaseWidgetListTileState();
}

class _PurchaseWidgetListTileState extends State<PurchaseWidgetListTile> {
  final InAppPurchaseManager inAppPurchaseManager;
  late SettingsViewModel model;

  bool isPurchasing = false;

  _PurchaseWidgetListTileState()
      : inAppPurchaseManager = KiwiContainer().resolve();

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
        "areWidgetsSupported",
      ],
    )!
        .value;

    if (!model.areWidgetsSupported! ||
        model.widgetPurchaseState == PurchaseStateEnum.Unknown ||
        model.widgetPurchaseState == null) {
      return Container();
    }

    return ListTile(
      title: Text(L.of(context).settingsWidgetPurchase),
      trailing: const Icon(Icons.add_to_home_screen_outlined),
      subtitle: _buildWidgetSubtitle(),
      onTap: _purchaseClicked,
    );
  }

  Widget? _buildWidgetSubtitle() {
    if (isPurchasing) {
      return const Align(
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
      );
    }

    if (model.widgetPurchaseState == PurchaseStateEnum.Purchased) {
      return Row(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(
              Icons.check,
              color: Colors.green,
              size: 16,
            ),
          ),
          Text(
            L.of(context).settingsWidgetDidPurchase,
            style: const TextStyle(color: Colors.green),
          ),
        ],
      );
    }
    return null;
  }

  Future<void> _purchaseClicked() async {
    if (isPurchasing ||
        model.widgetPurchaseState == PurchaseStateEnum.Purchased) return;

    setState(() {
      isPurchasing = true;
    });

    await model.purchaseWidgets();
  }
}
