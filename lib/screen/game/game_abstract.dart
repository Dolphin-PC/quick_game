import 'package:quick_game/provider/stage_info_provider.dart';

abstract class GameAbstract {
  /// 게임 시작 전, [게임 설명 모달]
  preGameModal();

  /// 게임 초기화
  initGame();

  /// init random 시간 이후, 게임 시작
  /// 측정 시간 시작
  onStart();

  /// 정답 or 실패 시
  /// 측정 시간 종료
  onStop();

  /// 정답 시, 결과값 기록
  /// 측정 성공
  onRecord();
}
