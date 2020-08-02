import 'package:dhbwstudentapp/common/data/database_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_access.dart';
import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/data/preferences/secure_storage_access.dart';
import 'package:dhbwstudentapp/dualis/service/cache_dualis_service_decorator.dart';
import 'package:dhbwstudentapp/dualis/service/dualis_service.dart';
import 'package:dhbwstudentapp/dualis/service/error_report_dualis_decorator.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_provider.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_entry_repository.dart';
import 'package:dhbwstudentapp/schedule/data/schedule_query_information_repository.dart';
import 'package:dhbwstudentapp/schedule/service/error_report_schedule_source_decorator.dart';
import 'package:dhbwstudentapp/schedule/service/rapla/rapla_schedule_source.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';
import 'package:kiwi/kiwi.dart';

bool _isInjected = false;

void injectServices() {
  if (_isInjected) return;

  KiwiContainer c = KiwiContainer();
  c.registerInstance(PreferencesProvider(
    PreferencesAccess(),
    SecureStorageAccess(),
  ));
  c.registerInstance<ScheduleSource>(
    ErrorReportScheduleSourceDecorator(RaplaScheduleSource()),
  );
  c.registerInstance(DatabaseAccess());
  c.registerInstance(ScheduleEntryRepository(
    c.resolve(),
  ));
  c.registerInstance(ScheduleQueryInformationRepository(
    c.resolve(),
  ));
  c.registerInstance(ScheduleProvider(
    c.resolve(),
    c.resolve(),
    c.resolve(),
  ));
  c.registerInstance<DualisService>(ErrorReportDualisDecorator(
    CacheDualisServiceDecorator(
      DualisServiceImpl(),
    ),
  ));

  _isInjected = true;
}
