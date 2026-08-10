import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String chaveMeta = 'meta';

  Future<void> salvarMeta(double meta) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(chaveMeta, meta);
  }

  Future<double> carregarMeta() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(chaveMeta) ?? 1000.0;
  }

  Future<void> apagarMeta() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(chaveMeta);
  }
}