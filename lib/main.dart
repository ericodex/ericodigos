import 'dart:core';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:flutter/cupertino.dart';

import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flip_card/flip_card.dart';
import 'objetos_flare.dart';
import 'sliderMola.dart';

void main() async => runApp(MeuAplicativo());

class MeuAplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Widget> op = {1: EricodigosHome(), 2: EricodigosHome()};
    return MaterialApp(
        title: 'Ericódigos',
        theme: ThemeData(
            platform: TargetPlatform.iOS, // Para o ScrollViewRefresh
            brightness: Brightness.dark,
            primaryColorDark: Colors.grey[700],
            primaryColorLight: Colors.grey[400],
            backgroundColor: Colors.grey[800],
            primaryColor: Color.fromARGB(255, 34, 34, 34),
            highlightColor: Color.fromARGB(255, 125, 222, 179),
            fontFamily: 'PressP2'),
        home: CustomSplash(
          imagePath: 'assets/ericodigosSplash.gif',
          backGroundColor: Colors.black,
          animationEffect: 'fade-in',
          logoSize: 200,
          home: EricodigosHome(),
          duration: 3000,
          type: CustomSplashType.StaticDuration,
          outputAndHome: op,
        ));
  }
}

class EricodigosHome extends StatefulWidget {
  @override
  _EricodigosHomeState createState() => _EricodigosHomeState();
}

class _EricodigosHomeState extends State<EricodigosHome> with FlareController {
  ActorAnimation _loadingAnimation;
  ActorAnimation _successAnimation;
  ActorAnimation _pullAnimation;
  ActorAnimation _cometAnimation;

  bool _hello = false;

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
        inherit: true,
      ),
      child: Scaffold(
        //backgroundColor: Colors.amber[800],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
              floating: true,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Eric0d3Banner(),
              ),
            ),
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 150.0,
              refreshIndicatorExtent: 150.0,
              builder: buildRefreshWidget,
              onRefresh: () {
                return Future<void>.delayed(const Duration(seconds: 5))
                  ..then<void>((_) {
                    setState(() {
                      _hello = !_hello;
                    });
                  });
              },
            ),
            SliverSafeArea(
              top: false,
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
                          color: Colors.grey[700],
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 15,
                              ),
                              SizedBox(
                                height: 215,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
/*                                       _hello = !_hello;
                                      print('annnnhhhhhh! ${_hello}'); */
                                    });
                                  },
                                  child: AnimatedCrossFade(
                                      firstChild: Container(
                                        width: 200,
                                        height: 200,
                                        child: Center(child: Text('Hello!')),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black38),
                                      ),
                                      secondChild: Container(
                                          width: 200.0,
                                          height: 200.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      "https://avatars2.githubusercontent.com/u/32937165?s=460&v=4")))),
                                      crossFadeState: _hello
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      duration: Duration(seconds: 3)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 30),
                                child: AspectRatio(
                                  aspectRatio: 1.6180, //Golden Ratio
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0, 8.0, 8.0),
                                    child: FlipCard(
                                      direction:
                                          FlipDirection.HORIZONTAL, // default
                                      front: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 8, 8.0, 8.0),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                //height: 500,
                                                width: 1000,
                                                child: Text(
                                                  'Olá sou Eric Oliveira Lima, engenheiro e arquiteto de Software. \n\nTrabalho planejando, desenvolvendo e aperfeiçoando sistemas Web multiplataforma e sistemas de informações.\n\nDesenvolvimento rápido e de baixo custo para Android, IOS nativos, Windows Desktop e web utilizando tecnologia Dart & Flutter.\n\nSoluções interamente customizáveis para um novo nível Business Intelligence.',
                                                  textAlign: TextAlign.start,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      height: 1.3,
                                                      color: Colors.blue[100]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      back: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 300,
                                              child: Capibara(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 30),
                                child: AspectRatio(
                                  aspectRatio: 1.6180,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8,0,8,8),
                                    child: FlipCard(
                                      direction:
                                          FlipDirection.VERTICAL, // default
                                      front: Container(
                                        height: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: 1000,
                                                //height: 200,
                                                                                              child: Text(
                                                  '10 anos de experiência em programação. \n\nFull-Stack, Dart, Python, Typescript, .net, flr, SQL, MongoDB, Dax, GIT, Qlikview, Pentaho, VBA e Excel.\n\nBach Wise Computation, TensorFlow e Keras.\n\nContatos no verso!',
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      height: 1.3,
                                                      color: Colors.blue[100]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      back: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Center(
                                          child: Text(
                                            'Eric Oliveira Lima\n\nericol@outlook.com.br\n\n+55 034 988047387',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.amber),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Eric0d3Banner extends StatelessWidget {
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

/* class CartoesApresentacao extends StatefulWidget {
  CartoesApresentacao({Key key}) : super(key: key);

  @override
  _CartoesApresentacaoState createState() => new _CartoesApresentacaoState();
}

class _CartoesApresentacaoState extends State<CartoesApresentacao> {
  @override
  Widget build(BuildContext context) {
    return ;
  }
  // -- Cartões de visita?

} */

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
            color: Colors.blue[400],
            onPressed: () {
              //-------------------------------------
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestGooblyDoo()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.cloud_upload),
            color: Colors.blue[400],
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(builder: (context) => MinhaMola()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.fiber_new),
            color: Colors.blue[400],
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
            color: Colors.blue[400],
            iconSize: 40,
            onPressed: () {
              //-------------------------------------
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DeixeUmaMensagem()));
              //-------------------------------------
            },
          ),
        ),
        Ink(
          child: IconButton(
            icon: Icon(Icons.phone_iphone),
            color: Colors.blue[400],
            iconSize: 40,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VapowaveSpace()));
            },
          ),
        ),
      ],
    );
  }
}

/// Pagina para mensagem de recado registrado no firebase
class DeixeUmaMensagem extends StatefulWidget {
  DeixeUmaMensagem({Key key}) : super(key: key);

  @override
  _DeixeUmaMensagemState createState() => _DeixeUmaMensagemState();
}

class _DeixeUmaMensagemState extends State<DeixeUmaMensagem> {
  String _msg = '';

  final TextEditingController _controller = new TextEditingController();

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
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: CustomScrollView(slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 100,
                    floating: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Eric0d3Banner(),
                    ),
                  ),
                  SliverSafeArea(
                    top: false,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Text(
                                  'Deixe aqui sua mensagem para mim.',
                                  style: TextStyle(
                                      height: 1.3, color: Colors.greenAccent),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextField(
                                      style: TextStyle(height: 1.6),
                                      cursorColor: Colors.greenAccent,
                                      cursorRadius: Radius.circular(16.0),
                                      cursorWidth: 16.0,
                                      obscureText: false,
                                      maxLines: 5,
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'mgs...',
                                      ),
                                      onChanged: (text) {
                                        _msg = text;
                                      }),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RaisedButton(
                                    color: Colors.greenAccent,
                                    onPressed: () {
                                      Firestore.instance
                                          .collection('Mensagem')
                                          .document()
                                          .setData({'msg': _msg});
                                      _controller.clear();
                                    },
                                    child: const Text(
                                      'Registrar',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                  ),
                ]))));
  }
}

// ------------------- teste areas -------------------

class TestGooblyDoo extends StatefulWidget {
  @override
  _TestGooblyDooState createState() {
    return _TestGooblyDooState();
  }
}

class _TestGooblyDooState extends State<TestGooblyDoo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Votação')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Qual tecnologia você gostaria de ver no seu projeto?'),
          ),
          Container(height: 400, child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('appName').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.name),
            trailing: Text(record.votes.toString()),
            //onTap: () => record.reference.updateData({'votes': record.votes + 1}),
            onTap: () => record.reference
                .updateData({'votes': FieldValue.increment(1)})),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}

// ---------------------------  teste area --------------------------------------
