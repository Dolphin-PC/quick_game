import 'package:flutter/cupertino.dart';
import 'package:quick_game/model/stage_info_model.dart';

class StageInfoProvider extends ChangeNotifier {
  List<StageInfoModel> _stageInfoModelList = [];
  StageInfoModel? _currentStageInfoModel;

  set stageInfoModelList(List<StageInfoModel> list) => _stageInfoModelList = list;
  Future<List<StageInfoModel>> getStageInfoModelList() async {
    /// 최초 1회만 실행
    if (_stageInfoModelList.isEmpty) {
      _stageInfoModelList = await selectList();
      _currentStageInfoModel = _stageInfoModelList.first;
    }

    return _stageInfoModelList;
  }

  set currentStageInfoModel(StageInfoModel stageInfoModel) => _currentStageInfoModel = stageInfoModel;
  StageInfoModel get currentStageInfoModel => _currentStageInfoModel!;

  Future<List<StageInfoModel>> selectList() async {
    return await StageInfoModel.selectList();
  }

  Future<void> setRecordTime(int time) async {
    _currentStageInfoModel = await _currentStageInfoModel?.update({"record_time" : time});
    _stageInfoModelList = await selectList();

    notifyListeners();
  }
}
