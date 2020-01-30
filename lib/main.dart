import 'dart:core';
import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:flutter/cupertino.dart';

import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

import 'package:flip_card/flip_card.dart';
import 'objetos_flare.dart';

import 'contacts.dart';

void main() async => runApp(MeuAplicativo());

class MeuAplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Widget> op = {1: EricodigosHome(), 2: EricodigosHome()};
    return MaterialApp(
        title: 'Ericódigos',
        theme: ThemeData(
            brightness: Brightness.dark,
            platform: TargetPlatform.iOS,
            backgroundColor: Colors.black,
            primaryColor: Colors.blueGrey,
            fontFamily: 'PressP2'),
        home: CustomSplash(
          imagePath: 'assets/ericodigosSplash.gif',
          backGroundColor: Colors.black,
          animationEffect: 'fade-in',
          logoSize: 200,
          home: EricodigosHome(),
          duration: 4000,
          type: CustomSplashType.StaticDuration,
          outputAndHome: op,
        ));
  }
}

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            backgroundColor: Colors.transparent,
            expandedHeight: 10,
            floating: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Box(),
            ),
          ),

          ///

          SliverFillRemaining(
            fillOverscroll: false,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Botoes(),
                      ],
                    ),

                    /// -> Cartões
                    CartoesApresentacao(),
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}

class EricodigosHome extends StatefulWidget {
  static const String routeName = '/cupertino/refresh';

  @override
  _EricodigosHomeState createState() => _EricodigosHomeState();
}

class _EricodigosHomeState extends State<EricodigosHome> with FlareController {
  List<List<String>> randomizedContacts;

  ActorAnimation _loadingAnimation;
  ActorAnimation _successAnimation;
  ActorAnimation _pullAnimation;
  ActorAnimation _cometAnimation;

  RefreshIndicatorMode _refreshState;
  double _pulledExtent;
  double _refreshTriggerPullDistance;
  double _refreshIndicatorExtent;
  double _successTime = 0.0;
  double _loadingTime = 0.0;
  double _cometTime = 0.0;

  void initialize(FlutterActorArtboard actor) {
    _pullAnimation = actor.getAnimation("pull");
    _successAnimation = actor.getAnimation("success");
    _loadingAnimation = actor.getAnimation("loading");
    _cometAnimation = actor.getAnimation("idle comet");
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    double animationPosition = _pulledExtent / _refreshTriggerPullDistance;
    animationPosition *= animationPosition;
    _cometTime += elapsed;
    _cometAnimation.apply(_cometTime % _cometAnimation.duration, artboard, 1.0);
    _pullAnimation.apply(
        _pullAnimation.duration * animationPosition, artboard, 1.0);
    if (_refreshState == RefreshIndicatorMode.refresh ||
        _refreshState == RefreshIndicatorMode.armed) {
      _successTime += elapsed;
      if (_successTime >= _successAnimation.duration) {
        _loadingTime += elapsed;
      }
    } else {
      _successTime = _loadingTime = 0.0;
    }
    if (_successTime >= _successAnimation.duration) {
      _loadingAnimation.apply(
          _loadingTime % _loadingAnimation.duration, artboard, 1.0);
    } else if (_successTime > 0.0) {
      _successAnimation.apply(_successTime, artboard, 1.0);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    repopulateList();
  }

  void repopulateList() {
    final Random random = Random();
    randomizedContacts = List<List<String>>.generate(100, (int index) {
      return contacts[random.nextInt(contacts.length)]
        // Randomly adds a telephone icon next to the contact or not.
        ..add(random.nextBool().toString());
    });
  }

  Widget buildRefreshWidget(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {
    _refreshState = refreshState;
    _pulledExtent = pulledExtent;
    _refreshTriggerPullDistance = refreshTriggerPullDistance;
    _refreshIndicatorExtent = refreshIndicatorExtent;

    return FlareActor("assets/flares/space_demo.flr",
        alignment: Alignment.center,
        animation: "idle",
        fit: BoxFit.cover,
        controller: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 10.0,
      ),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                backgroundColor: Colors.grey[800],
                expandedHeight: 100,
                floating: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Box(),
                ),
              ),
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 190.0,
                refreshIndicatorExtent: 190.0,
                builder: buildRefreshWidget,
                onRefresh: () {
                  return Future<void>.delayed(const Duration(seconds: 5))
                    ..then<void>((_) {
                      if (mounted) {
                        setState(() => repopulateList());
                      }
                    });
                },
              ),
              SliverSafeArea(
                top: false, // Top safe area is consumed by the navigation bar.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Botoes(),
                              ],
                            ),
                            color: Colors.grey[800],
                          ),

                          /// -> Cartões
                          CartoesApresentacao(),
                        ],
                      );
                    },
                    childCount: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  static final boxDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 15,
            offset: Offset(0, 8),
            spreadRadius: 2)
      ]);

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
      duration: Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 100.0),
      builder: (context, height) {
        return ControlledAnimation(
          duration: Duration(milliseconds: 1200),
          delay: Duration(milliseconds: 500),
          tween: Tween(begin: 2.0, end: 300.0),
          builder: (context, width) {
            return Container(
              decoration: boxDecoration,
              width: width,
              height: height,
              child: isEnoughRoomForTypewriter(width)
                  ? TypewriterText(" Ericódigos")
                  : FittedBox(child: Container()),
            );
          },
        );
      },
    );
  }

  isEnoughRoomForTypewriter(width) => width > 25;
}

class TypewriterText extends StatelessWidget {
  final String text;
  TypewriterText(this.text);

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        duration: Duration(milliseconds: 800),
        delay: Duration(milliseconds: 800),
        tween: IntTween(begin: 0, end: text.length),
        builder: (context, textLength) {
          return FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_android,
                    color: Colors.greenAccent,
                    size: 24.0,
                  ),
                  Text(
                    text.substring(0, textLength),
                    style: TextStyle(fontSize: 20, color: Colors.greenAccent),
                  ),
                  ControlledAnimation(
                    playback: Playback.LOOP,
                    duration: Duration(milliseconds: 600),
                    tween: IntTween(begin: 0, end: 1),
                    builder: (context, oneOrZero) {
                      return Opacity(
                          opacity: oneOrZero == 1 ? 1.0 : 0.0,
                          child: Text(
                            "_",
                            style: TextStyle(
                                fontSize: 20, color: Colors.greenAccent),
                          ));
                    },
                  ),
                  Icon(
                    Icons.code,
                    color: Colors.greenAccent,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CartoesApresentacao extends StatefulWidget {
  CartoesApresentacao({Key key}) : super(key: key);

  @override
  _CartoesApresentacaoState createState() => _CartoesApresentacaoState();
}

class _CartoesApresentacaoState extends State<CartoesApresentacao> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: AspectRatio(
              aspectRatio: 9 / 9,
              child: FlipCard(
                direction: FlipDirection.HORIZONTAL, // default
                front: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Engenheiro e arquiteto de Software. \n\nDesenvolvimento de sistemas Web Cross Plataform de base única.\n\nApps Android e IOS Nativos, Web Sites e aplicativos desktop programados com Dart e Flutter.\n\nSoluções arquitetadas, 100% customizaveis para um novo nível Bussines Intelligence.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12, height: 1.3, color: Colors.blue[100]),
                    ),
                  ),
                ),
                back: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      height: 300,
                      child: Capibara(),
                      
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          //
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: AspectRatio(
              aspectRatio: 14 / 9,
              child: FlipCard(
                direction: FlipDirection.VERTICAL, // default
                front: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'knowledge em: Full-Stack, Dart, Python, Typescript, CSS, .net, flr, SQL, MongoDB, Dax, GIT, SVN, Qlikview, Pentaho, VBA and Excel.\n\nBach Wise Computation, TensorFlow, Pythorch.\n\nContatos no verso!',
                      style: TextStyle(
                          fontSize: 12, height: 1.3, color: Colors.blue[100]),
                    ),
                  ),
                ),
                back: Container(
                  alignment: Alignment.center,
                  color: Colors.blueGrey,
                  child: Text(
                    'Eric Oliveira Lima\n\nericol@outlook.com.br\n\n+55 034 988047387',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Botoes extends StatelessWidget {
  Botoes({Key key}) : super(key: key);

  isEnoughRoomForTypewriter(width) => width > 20;
  static final boxDecoration = BoxDecoration(boxShadow: [
    BoxShadow(
      color: Colors.transparent,
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Ink(
          child: IconButton(
            iconSize: 40,
            tooltip: 'Space!!!',
            icon: Icon(Icons.android),
            color: Colors.greenAccent,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Capibara()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.cloud_upload),
            color: Colors.greenAccent,
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(
                      builder: (context) => InterruptorCicardiano()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.fiber_new),
            color: Colors.greenAccent,
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(
                      builder: (context) => InterruptorCicardiano()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.code),
            color: Colors.greenAccent,
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(
                      builder: (context) => InterruptorCicardiano()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.phone_iphone),
            color: Colors.greenAccent,
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(
                      builder: (context) => InterruptorCicardiano()));
              //-------------------------------------
            },
          ),
        ),
      ],
    );
  }
}
