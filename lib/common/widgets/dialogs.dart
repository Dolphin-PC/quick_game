import 'package:flutter/material.dart';
import 'package:quick_game/styles/button_styles.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';

class Dialogs {
  static recordDialog({required BuildContext context, required int resultMilliSecond}) {
    Dialogs.noticeDialog(
      context: context,
      contentWidget: Text(
        '기록 측정 완료!\n$resultMilliSecond ms',
        style: TextStyles.plainTexts(30).copyWith(color: ColorStyles.bgPrimaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  static noticeDialog({
    required BuildContext context,
    String? titleText,
    String succBtnName = "확인",
    Function? succFn,
    required Widget contentWidget,
  }) {
    return customDialog(
      succFn,
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

  static confirmDialog({
    required BuildContext context,
    String titleText = "제목",
    String succBtnName = "확인",
    required Function succFn,
    String cancelBtnName = "취소",
    required Widget contentWidget,
  }) {
    return customDialog(
      succFn,
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

  static customDialog(
    Function? succFn, {
    required BuildContext context,
    String? titleText = "제목",
    required Widget contentWidget,
    String? succBtnName,
    String? cancelBtnName,
  }) {
    return showDialog(
      context: context,
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
                    onPressed: () => Navigator.pop(context),
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
