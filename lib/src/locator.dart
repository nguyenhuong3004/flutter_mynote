import 'package:get_it/get_it.dart';
import 'package:mynote/src/views/editNote/edit_note_view_model.dart';
import 'package:mynote/src/services/auth_service.dart';
import 'package:mynote/src/services/database_service.dart';
import 'package:mynote/src/services/navigation_service.dart';
import 'package:mynote/src/services/prefs_service.dart';

GetIt locator = GetIt.instance;
//khoi tao locator de goi service trong moi widget
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => DatabaseService());
  locator
      .registerSingletonAsync<PrefsService>(() => PrefsService.getInstance());

  locator.registerFactory<EditNoteViewModel>(() => EditNoteViewModel());
}
