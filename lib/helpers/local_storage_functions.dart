import 'package:get_storage/get_storage.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

class LocalStorageFunctions {

  static GetStorage userDataContainer = GetStorage(userDataContainerName);
  static GetStorage languageContainer = GetStorage(languageContainerName);

  static Future<void> writeToStorage({
    required String key,
    required dynamic value,
    String? container,
  }) async {
    if(container != null && await GetStorage(container).initStorage) {
      await GetStorage().write(key, value);
    } else {
      if (container != null && await GetStorage(container).initStorage == false) {
        await GetStorage.init(container);
        await GetStorage(container).write(key, value);
      } else {
        await userDataContainer.write(key, value);
      }
    }
  }

  static Future<dynamic> readFromStorage({required String key, String? container}) async {
    if(container != null && await GetStorage(container).initStorage) {
      return await GetStorage().read(key);
    } else {
      if (container != null && await GetStorage(container).initStorage == false) {
        await GetStorage.init(container);
        return await GetStorage(container).read(key);
      } else {
        return await userDataContainer.read(key);
      }
    }
  }

  static void clearContainerData({required String containerName}) async {
    if(await GetStorage(containerName).initStorage == false) {
      await GetStorage.init(containerName);
      await GetStorage(containerName).erase();
    }
  }

  static void removeKey({required String key, String? container}) async {
    if(container != null && await GetStorage(container).initStorage) {
      await GetStorage().remove(key);
    } else {
      if (container != null && await GetStorage(container).initStorage == false) {
        await GetStorage.init(container);
        await GetStorage(container).remove(key);
      } else {
        await userDataContainer.remove(key);
      }
    }
  }

  static void clearCompleteStorage() async {
    await GetStorage().erase();
    await languageContainer.erase();
    await userDataContainer.erase();
  }
}