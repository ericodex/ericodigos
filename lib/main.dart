import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_splash/custom_splash.dart';

import 'banner_home.dart';
import 'cartoes.dart';
import 'controleDeAtualizacao.dart';

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
          fontFamily: 'PressP2'
        ),
        home: CustomSplash(
          imagePath: 'assets/ericodigosSplash.gif',
          backGroundColor: Colors.black,
          animationEffect: 'fade-out',
          logoSize: 200,
          home: EricodigosHome(),
          duration: 4000,
          type: CustomSplashType.StaticDuration,
          outputAndHome: op,
        ));
  }
}


//----




//----

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

