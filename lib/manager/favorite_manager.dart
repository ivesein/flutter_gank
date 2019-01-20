import 'package:objectdb/objectdb.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/gank_info.dart';

class FavoriteManager {
  static ObjectDB db;

  static init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}gank_favorites.db';
    db = new ObjectDB(path);
    await db.open();
  }

  static void close() async => await db.close();

  static insert(GankInfo gankInfo) async => await db.insert(gankInfo.toJson());

  static delete(GankInfo gankInfo) async =>
      await db.remove({'itemId': gankInfo.itemId});

  static find(Map<dynamic, dynamic> query) async => await db.find(query);
}
