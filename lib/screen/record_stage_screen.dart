import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quick_game/data/datas.dart';
import 'package:quick_game/model/stage_info_model.dart';
import 'package:quick_game/provider/stage_info_provider.dart';
import 'package:quick_game/styles/color_styles.dart';
import 'package:quick_game/styles/text_styles.dart';

class RecordStageScreen extends StatefulWidget {
  const RecordStageScreen({Key? key}) : super(key: key);

  @override
  State<RecordStageScreen> createState() => _RecordStageScreenState();
}

class _RecordStageScreenState extends State<RecordStageScreen> {
  late StageInfoProvider stageInfoProvider;

  Column getCurrentStageInfo() {
    String recordTimeStr = "미측정";
    if (stageInfoProvider.currentStageInfoModel.recordTime != null) {
      recordTimeStr = "${stageInfoProvider.currentStageInfoModel.recordTime} ms";
    }

    return Column(
      children: [
        Text(stageInfoProvider.currentStageInfoModel.stageName, style: TextStyles.titleText),
        Text(recordTimeStr, style: TextStyles.plainText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    stageInfoProvider = Provider.of(context, listen: true);

    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      body: Center(
        child: FutureBuilder(
          future: stageInfoProvider.getStageInfoModelList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('...loading');

            List<StageInfoModel> list = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.5,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) {
                      stageInfoProvider.currentStageInfoModel = list[index];
                      setState(() {});
                    },
                  ),
                  items: list.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Widget screenWidget = Datas.stageScreenStringMap[stageInfoProvider.currentStageInfoModel.stageId]!;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => screenWidget));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(5.0, 5.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Lottie.asset('assets/lotties/${item.stageId}.json'),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                getCurrentStageInfo()
              ],
            );
          },
        ),
      ),
    );
  }
}
