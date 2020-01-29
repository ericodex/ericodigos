import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_splash/custom_splash.dart';
import 'banner_home.dart';
import 'cartoes.dart';
import 'objetos_flare.dart';

void main() async => runApp(MeuAplicativo());

class MeuAplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Widget> op = {1: PaginaInicial(), 2: PaginaInicial()};
    return MaterialApp(
        title: 'Ericódigos',
        theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          primaryColor: Colors.blueGrey,
          fontFamily: 'PressP2'
        ),
        home: CustomSplash(
          imagePath: 'assets/ericodigosSplash.gif',
          backGroundColor: Colors.black,
          animationEffect: 'fade-in',
          logoSize: 200,
          home: PaginaInicial(),
          duration: 4000,
          type: CustomSplashType.StaticDuration,
          outputAndHome: op,
        ));
  }
}

class PaginaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 100,
            floating: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Box(),
            ),
          ),
          SliverFillRemaining(
            fillOverscroll: false,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Botao(),
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

class Botao extends StatelessWidget {
  Botao({Key key}) : super(key: key);

  isEnoughRoomForTypewriter(width) => width > 20;
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
    return Material(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.android),
                color: Colors.greenAccent,
                onPressed: () {
                  //-------------------------------------
                  Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => SegundaPagina()));
                      MaterialPageRoute(builder: (context) => VapowaveSpace()));
                  //-------------------------------------
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.cloud_upload),
                color: Colors.greenAccent,
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
          ),
        ],
      ),
    );
  }
}
