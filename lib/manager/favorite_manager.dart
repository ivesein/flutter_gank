import 'package:objectdb/objectdb.dart';
import 'dart:io';

class FavoriteManager {
  static ObjectDB db;

  static Future<void> init() async {
    final String path = '${Directory.current.path}/gank_favorites.db';
    db = new ObjectDB(path);
    await db.open();
  }

  static void close() async => await db.close();
}
