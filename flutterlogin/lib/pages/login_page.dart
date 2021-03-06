import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterlogin/StringUtils.dart';
import 'package:flutterlogin/bean/UserResult.dart';
import 'package:flutterlogin/constant/constant.dart';
import 'package:flutterlogin/http/http_api.dart';
import 'package:flutterlogin/router.dart';
import 'package:flutterlogin/widgets/CountDownWidget.dart';
import 'package:flutterlogin/widgets/EditTextFieldWidget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.white,
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: LoginView(),
        ));
  }
}

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginView();
  }
}

class _LoginView extends State<LoginView> {
  String hintPhone = '';
  String hintCode = '';
  MethodChannel _methodChannel = MethodChannel("MethodChannelPlugin");
  bool isLoging=false;
  @override
  void initState() {
    // ignore: missing_return
    _methodChannel.setMethodCallHandler((handler) => Future<String>(() {
          print("_methodChannel：${handler}");
          //监听native发送的方法名及参数
          switch (handler.method) {
            case "send":
              _send(handler.arguments); //handler.arguments表示native传递的方法参数
              break;
          }
        }));
    super.initState();
  }

  //native调用的flutter方法
  void _send(arg) {
    setState(() {
//      _content = arg;
    });
  }

  String _resultContent = "";

  //flutter调用native的相应方法
  void _sendToNative(String method, [ dynamic tips ]) {
    Future<String> future = _methodChannel.invokeMethod(method, tips);
    future.then((message) {
      setState(() {
        //message是native返回的数据
        _resultContent = "返回值：" + message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _sendToNative("loadingTips", 'false');
    return Scaffold(
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 30.0),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(Constant.ASSETS_IMG + 'logoin_close.png',
                      width: 15, height: 15),
                  onTap: () {
                    _sendToNative("onBackProgress", "");
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                      height: 100,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25,
                          child: Text(
                            "登录/注册",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: const Color(0xff323232), //字体颜色
                                fontSize: 25, //字体大小
                                height: 1),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                          height: 20,
                        ),
                        Container(
                          height: 13,
                          child: Text("注册领取免费优惠券",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: const Color(0xffea4c44), //字体颜色
                                  fontSize: 13, //字体大小
                                  height: 1)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                      height: 55,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 50,
                          alignment: AlignmentDirectional.center,
                          child: Text("+86",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: const Color(0xff323232), //字体颜色
                                  fontSize: 16, //字体大小
                                  height: 1)),
                        ),
                        SizedBox(
                          width: 5,
                          height: 50,
                        ),
                        Image.asset(Constant.ASSETS_IMG + 'login_arrow.png',
                            width: 5, height: 5),
                        SizedBox(
                          width: 10,
                          height: 50,
                        ),
                        SizedBox(
                          //垂直分割线
                          width: 1,
                          height: 20,
                          child: DecoratedBox(
                            decoration:
                                BoxDecoration(color: const Color(0xff323232)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          height: 50,
                        ),
                        EditTextFieldWidget(
                          margin: EdgeInsets.all(0),
                          hintText: '手机号',
                          inputFormatter: [WhitelistingTextInputFormatter.digitsOnly],
                          onChange: (str) {
                            hintPhone = str;
                          },
                        ),
                      ],
                    ),
                    Divider(
                        //水平分割线
                        height: 10.0,
                        indent: 0.0,
                        color: const Color(0xffc4c4c4)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        EditTextFieldWidget(
                          margin: EdgeInsets.all(0),
                          hintText: '请输入验证码',
                          inputFormatter: [WhitelistingTextInputFormatter.digitsOnly] ,
                          onChange: (str) {
                            hintCode = str;
                          },
                        ),
                        CountDownWidget(chargeCodePhone: () {
                          return hintPhone.isEmpty;
                        }, onCountDownFinishCallBack: (bool isFinish) {
                          if (isFinish) {
                          } else {
                            if (hintPhone.isEmpty) {
                              _sendToNative("onToast", "请输入手机号");
                           //  Scaffold.of(context).showSnackBar(SnackBar(content:Text('请输入手机号')));//SnackBar方式提示 感觉有点丑
                              return;
                            }
                            if(!StringUtils.checkPhone(hintPhone)){
                              _sendToNative("onToast", "请输入正确的手机号");
                              return;
                            }
                          }
                        }),
                      ],
                    ),
                    Divider(
                        //水平分割线
                        height: 0.0,
                        indent: 0.0,
                        color: const Color(0xffc4c4c4)),
                    SizedBox(
                      width: 10,
                      height: 35,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),

                          ///圆角
                          color: const Color(0xffea4c44),
                        ),
                        child: Text("确认",
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: const Color(0xffffffff), //字体颜色
                                fontSize: 14, //字体大小
                                height: 1)),
                      ),
                      onTap: () {
                        if(isLoging) return;
                        if (hintPhone.isEmpty) {
                          _sendToNative("onToast", "请输入手机号");
                          return;
                        }

                        if(!StringUtils.checkPhone(hintPhone)){
                          _sendToNative("onToast", "请输入正确的手机号");
                          return;
                        }

                        if (hintCode.isEmpty) {
                          _sendToNative("onToast", "请输入验证码");
                          return;
                        }
                        _loginSubmit(hintPhone);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "使用密码登录",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 13,
                            height: 3,
                            color: const Color(0xff5a7cab)),
                      ),
                      onTap: () {
                        Router.pushAndResult(context, Router.passwordPage,hintPhone,(String result){
                          _sendToNative("onToast", result);
                        });
                      },
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: Divider(
                                    //水平分割线
                                    height: 0.0,
                                    indent: 0.0,
                                    color: const Color(0xffc4c4c4)),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 1,
                            ),
                            Text(
                              "第三方账号登录",
                              style: TextStyle(
                                  color: const Color(0xffa9a9a9), fontSize: 13),
                            ),
                            SizedBox(
                              width: 20,
                              height: 1,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                child: Divider(
                                    //水平分割线
                                    height: 0.0,
                                    indent: 0.0,
                                    color: const Color(0xffc4c4c4)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    Constant.ASSETS_IMG + 'huawei_login.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text(
                                    "华为",
                                    style: TextStyle(
                                        color: const Color(0xff909090),
                                        fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    Constant.ASSETS_IMG + 'login_wechat.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text(
                                    "微信",
                                    style: TextStyle(
                                        color: const Color(0xff909090),
                                        fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    Constant.ASSETS_IMG + 'login_weibo.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text(
                                    "微博",
                                    style: TextStyle(
                                        color: const Color(0xff909090),
                                        fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    Constant.ASSETS_IMG + 'login_qq.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text(
                                    "QQ",
                                    style: TextStyle(
                                        color: const Color(0xff909090),
                                        fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'icon_selected1.png',
                              alignment: Alignment.centerLeft,
                              width: 20,
                              height: 16,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: " 登录即表示同意 ",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xff999999)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "《用户协议》",
                                      style:
                                          TextStyle(color: Color(0xff5a7cab)),
                                    ),
                                    TextSpan(
                                      text: "《隐私政策》",
                                      style:
                                          TextStyle(color: Color(0xff5a7cab)),
                                    )
                                  ]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  _loginSubmit(String phone) {
    isLoging=true;
    _sendToNative("loadingTips", 'true');
    API.login(phone,(String data) {
      /*将字符串转成json  返回的是键值对的形式*/
      Map<String, dynamic> news = jsonDecode(data);
      var userResult = UserResult.fromJson(news);
      print('result='+userResult.msg);
      FocusScope.of(context).requestFocus(FocusNode());
      _sendToNative("onLoginSuccess", userResult.user.toJson());
      isLoging=false;
    }, (String error) {
      print('error==='+error);
      _sendToNative("loadingTips", 'false');
      isLoging=false;
    });
  }
}
