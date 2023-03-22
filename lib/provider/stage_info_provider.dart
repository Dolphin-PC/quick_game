import 'package:flutter/cupertino.dart';
import 'package:quick_game/model/stage_info_model.dart';

class StageInfoProvider extends ChangeNotifier {
  List<StageInfoModel> _stageInfoModelList = [];
  StageInfoModel? _currentStageInfoModel;

  set stageInfoModelList(List<StageInfoModel> list) => _stageInfoModelList = list;
  Future<List<StageInfoModel>> getStageInfoModelList() async {
    if (_stageInfoModelList.isEmpty) {
      _stageInfoModelList = await selectList();
    }

    return _stageInfoModelList;
  }

  set currentStageInfoModel(StageInfoModel stageInfoModel) => _currentStageInfoModel = stageInfoModel;
  StageInfoModel get currentStageInfoModel {
    return _currentStageInfoModel!;
  }

  Future<List<StageInfoModel>> selectList() async {
    var list = await StageInfoModel.selectList();
    _currentStageInfoModel = list.first;
    return list;
  }
}
