import 'package:flutter/material.dart';
import 'package:quick_game/styles/button_styles.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';

class Dialogs {
  static preGameModal({required BuildContext context, required Function startFn, required String msg}) {
    Dialogs.confirmDialog(
      succBtnName: "게임시작",
      succFn: startFn,
      cancelBtnName: "나가기",
      cancelFn: () => Navigator.pop(context),
      context: context,
      contentWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '3~7초 뒤에 게임이 시작돼요',
              style: TextStyles.plainTexts(25).copyWith(color: ColorStyles.bgPrimaryColor),
              textAlign: TextAlign.center,
            ),
            Divider(height: 5, color: ColorStyles.borderColor),
            Text(
              msg,
              style: TextStyles.plainTexts(15).copyWith(color: ColorStyles.bgSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

  }

  /// 기록 성공 dialog
  static recordDialog({required BuildContext context, required int resultMilliSecond}) {
    Dialogs.noticeDialog(
      succFn: () {
        Navigator.pop(context);
      },
      context: context,
      contentWidget: Text(
        '기록 측정 완료\n$resultMilliSecond ms',
        style: TextStyles.plainTexts(30).copyWith(color: ColorStyles.bgPrimaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 기록 실패 dialog
  static recordFailDialog({required BuildContext context, required Function retryFn, required String subMsg}) {
    Dialogs.confirmDialog(
      succBtnName: "다시하기",
      succFn: retryFn,
      cancelBtnName: "나가기",
      cancelFn: () => Navigator.pop(context),
      context: context,
      contentWidget: Column(
        children: [
          Text(
            '기록 측정 실패!',
            style: TextStyles.plainTexts(30).copyWith(color: ColorStyles.bgPrimaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            subMsg,
            style: TextStyles.plainTexts(20).copyWith(color: ColorStyles.bgPrimaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// [template] 버튼 하나만 있는 customDialog
  static noticeDialog({
    required BuildContext context,
    String? titleText,
    String succBtnName = "확인",
    Function? succFn,
    Function? cancelFn,
    required Widget contentWidget,
  }) {
    return customDialog(
      succFn,
      cancelFn,
      context: context,
      titleText: titleText,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentWidget,
        ],
      ),
      succBtnName: succBtnName,
    );
  }

  /// [template] 버튼 두개 있는 customDialog
  static confirmDialog({
    required BuildContext context,
    String? titleText,
    String succBtnName = "확인",
    Function? succFn,
    Function? cancelFn,
    String cancelBtnName = "취소",
    required Widget contentWidget,
  }) {
    return customDialog(
      succFn,
      cancelFn,
      context: context,
      titleText: titleText,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentWidget,
        ],
      ),
      succBtnName: succBtnName,
      cancelBtnName: cancelBtnName,
    );
  }

  /// [template] 디자인 없는 기본 dialog
  static defaultDialog({
    required BuildContext context,
    required String contentText,
    required String succBtnName,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          content: Text(contentText, style: TextStyles.plainTexts(15), textAlign: TextAlign.center),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButtonStyles.positive,
              child: Text(succBtnName),
            ),
          ],
        );
      },
    );
  }

  /// [template] 디자인 있는 기본 dialog
  static customDialog(
    Function? succFn,
    Function? cancelFn, {
    required BuildContext context,
    String? titleText,
    required Widget contentWidget,
    String? succBtnName,
    String? cancelBtnName,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (build) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: titleText == null ? Text('') : Text(titleText, textAlign: TextAlign.center),
          contentPadding: EdgeInsets.zero,
          content: contentWidget,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            cancelBtnName == null
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (cancelFn != null) {
                        cancelFn();
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButtonStyles.negative,
                    child: Text(cancelBtnName),
                  ),
            succBtnName == null
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (succFn != null) {
                        succFn();
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButtonStyles.positive,
                    child: Text(succBtnName),
                  ),
          ],
        );
      },
    );
  }
}
