
import 'package:flutter/material.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/util/toast.dart';
import 'package:flutter_deer/util/utils.dart';
import 'package:flutter_deer/widgets/app_bar.dart';
import 'package:flutter_deer/widgets/my_button.dart';
import 'package:flutter_deer/widgets/my_card.dart';

import 'models/freight_config_model.dart';
import 'price_input_dialog.dart';
import 'range_price_input_dialog.dart';

class FreightConfigPage extends StatefulWidget {
  @override
  _FreightConfigPageState createState() => _FreightConfigPageState();
}

class _FreightConfigPageState extends State<FreightConfigPage> {
  
  List<FreightConfigModel> list = [];
  
  @override
  void initState() {
    super.initState();
    _reset();
  }

  _reset(){
    list.clear();
    list.add(FreightConfigModel("0", "", 1, false, ""));
    list.add(FreightConfigModel("", "", 1, true, ""));
    list.add(FreightConfigModel("", "-1", 1, false, ""));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "运费比例配置",
        actionName: "重置",
        onPressed: (){
          setState(() {
            _reset();
          });
        },
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
            child: MyButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              text: "完成",
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 64.0,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              itemBuilder: (_, index){
                return _buildItem(index);
              },
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
  
  // 暂时没有对输入数据进行校验
  _buildItem(int index){
    return list[index].isAdd ? 
    InkWell(
      onTap: (){
        var config = list[index - 1];
        if (config.max.isNotEmpty && config.min.isNotEmpty) {
          setState(() {
            list.insert(list.length - 2, FreightConfigModel("", "", 1, false, ""));
          });
        } else {
          Toast.show("请先完善上一个区间金额！");
          return;
        }
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
          height: 100.0,
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          decoration: BoxDecoration(
            color: Colours.bg_gray,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Image.asset(Utils.getImgPath("shop/tj"))
      ),
    ) : Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 103.0,
      child: MyCard(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(index == 0 ? "订单金额小于" : (index == list.length - 1 ? "订单金额不小于" : "订单金额区间"), style: TextStyles.textDark14),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if (index == 0 || index == list.length - 1){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return PriceInputDialog(
                                  title: "订单金额",
                                  onPressed: (value){
                                    setState(() {
                                      if (index == 0){
                                        list[index].max = value;
                                      }else{
                                        list[index].min = value;
                                      }
                                    });
                                  },
                                );
                              });
                        }else{
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return RangePriceInputDialog(
                                  title: "订单金额",
                                  onPressed: (min, max){
                                    setState(() {
                                      list[index].min = min;
                                      list[index].max = max;
                                    });
                                  },
                                );
                              });
                        }
                      },
                      child: Text(
                        _getPriceText(index).isEmpty ? "订单金额" : _getPriceText(index),
                        textAlign: TextAlign.end,
                        style: _getPriceText(index).isEmpty ? TextStyles.textGray14 : TextStyles.textDark14),
                    )),
                  Gaps.hGap5,
                  Text("元", style: TextStyles.textDark14),
                ],
              ),
              Gaps.vGap15,
              Gaps.line,
              Gaps.vGap15,
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        list[index].type = 1;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(Utils.getImgPath(list[index].type == 1 ? "shop/xzyf" : "shop/wxzyf"), width: 16.0,),
                        Gaps.hGap4,
                        Text("比率"),
                      ],
                    ),
                  ),
                  Gaps.hGap16,
                  InkWell(
                    onTap: (){
                      setState(() {
                        list[index].type = 0;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(Utils.getImgPath(list[index].type == 0 ? "shop/xzyf" : "shop/wxzyf"), width: 16.0),
                        Gaps.hGap4,
                        Text("金额"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return PriceInputDialog(
                                title: list[index].type == 1 ? "运费比率" : "运费金额",
                                onPressed: (value){
                                  setState(() {
                                    list[index].price = value;
                                  });
                                },
                              );
                            });
                      },
                      child: Text(
                        list[index].price.isEmpty ? (list[index].type == 1 ? "运费比率" : "运费金额"): list[index].price,
                        textAlign: TextAlign.end,
                        style: list[index].price.isEmpty ? TextStyles.textGray14 : TextStyles.textDark14),
                    )),
                  Gaps.hGap5,
                  Text(list[index].type == 1 ? "%" : "元", style: TextStyles.textDark14),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
  String _getPriceText(int index){
    if (index == 0){
      if (list[index].max.isEmpty){
        return "";
      }else{
        return list[index].max;
      }
    }else if (index == list.length - 1){
      if (list[index].min.isEmpty){
        return "";
      }else{
        return list[index].min;
      }
    }else{
      if (list[index].min.isEmpty || list[index].max.isEmpty){
        return "";
      }else{
        return list[index].min + "~" + list[index].max;
      }
    }
  }
}