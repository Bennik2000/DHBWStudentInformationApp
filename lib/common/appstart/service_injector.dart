import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/data/preferences/secure_storage_access.dart';
import 'package:dhbwstudentapp/date_management/business/date_entry_provider.dart';
import 'package:dhbwstudentapp/date_management/data/date_entry_repository.dart';
import 'package:dhbwstudentapp/date_management/service/date_management_service.dart';
import 'package:dhbwstudentapp/dualis/service/cache_dualis_service_decorator.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_scraper.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/fake_account_dualis_scraper_decorator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_query_information_repository.dart';
import 'package:kiwi/kiwi.dart';

bool _isInjected = false;

///
/// This function injects all instances into the KiwiContainer. You can get a
/// singleton instance of a registered type using KiwiContainer().resolve()
///
void injectServices(bool isBackground) {
  if (_isInjected) return;

  KiwiContainer c = KiwiContainer();
  c.registerInstance(PreferencesProvider(
    PreferencesAccess(),
    SecureStorageAccess(),
  ));
  c.registerInstance(DatabaseAccess());
  c.registerInstance(ScheduleEntryRepository(
    c.resolve(),
  ));
  c.registerInstance(ScheduleQueryInformationRepository(
    c.resolve(),
  ));
  c.registerInstance(ScheduleSourceProvider(
    c.resolve(),
    isBackground,
  ));
  c.registerInstance(ScheduleProvider(
    c.resolve(),
    c.resolve(),
    c.resolve(),
    c.resolve(),
  ));
  c.registerInstance<DualisScraper>(
    FakeAccountDualisScraperDecorator(DualisScraper()),
  );
  c.registerInstance<DualisService>(CacheDualisServiceDecorator(
    DualisServiceImpl(
      c.resolve(),
    ),
  ));
  c.registerInstance(DateEntryProvider(
    DateManagementService(),
    DateEntryRepository(c.resolve()),
  ));

  _isInjected = true;
}
