import 'package:flutter/foundation.dart';
import 'package:quick_game/data/datas.dart';
import 'package:quick_game/db/db_helper.dart';
import 'package:sqflite/sqlite_api.dart';

const String tableName = "stage_info";

class StageInfoModel {
  StageInfoModel({
    Key? key,
    this.id,
    this.stageId,
    required this.stageName,
    this.recordTime,
    this.trainingLevel,
  });

  final int? id;
  final String? stageId;
  final String stageName;
  final int? recordTime, trainingLevel;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage_id': stageId,
      'stage_name': stageName,
      'record_time': recordTime,
      'training_level': trainingLevel,
    };
  }

  static Future<List<StageInfoModel>> selectList() async {
    final db = await DBHelper().database;
    final List<dynamic> maps = await db.query(tableName);

    var list = List.generate(maps.length, (i) {
      return StageInfoModel(
        id: maps[i]['id'],
        stageId: maps[i]['stage_id'],
        stageName: maps[i]['stage_name'],
        recordTime: maps[i]['record_time'],
        trainingLevel: maps[i]['training_level'],
      );
    });

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      tableName,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    await update({'is_delete': true});
  }

  Future<StageInfoModel> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(tableName, prmMap, where: 'id = ?', whereArgs: [id]);

    final List<dynamic> maps = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    List<StageInfoModel> list = List.generate(maps.length, (i) {
      return StageInfoModel(
        id: maps[i]['id'],
        stageId: maps[i]['stage_id'],
        stageName: maps[i]['stage_name'],
        recordTime: maps[i]['record_time'],
        trainingLevel: maps[i]['training_level'],
      );
    });

    return list.first;
  }

  /// 초기 데이터 세팅
  static initData() async {
    var list = await selectList();

    if (list.isNotEmpty) return;

    // List<StageInfoModel> initDataList = [
    //   StageInfoModel(stageName: "반응속도"),
    //   StageInfoModel(stageName: "똑같은 카드 누르기"),
    //   StageInfoModel(stageName: "순서대로 누르기"),
    //   StageInfoModel(stageName: "카드 나누기"),
    //   StageInfoModel(stageName: "짝맞추기"),
    // ];

    for (String key in Datas.stageMap.keys) {
      await StageInfoModel(stageId: key, stageName: Datas.stageMap[key]!).insert();
    }
  }
}
