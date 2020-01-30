import 'dart:core';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'objetos_flare.dart';

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
                        'Engenheiro e arquiteto de Software. \n\nDesenvolvimento de sistemas Web Cross Plataform de base única.\n\nApps Android, IOS Nativos, Web Sites e aplicativos desktop com Dart e Flutter.\n\nSoluções customizadas para um novo tipo bussines inteligence.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                    color: Colors.blue[100]),
                        ),
                  ),
                      
                ),
                back: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Space_copy(),
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
                          fontSize: 12,
                          height: 1.3,
                    color: Colors.blue[100]),
                        ),
                  ),
                ),
                back: Container(
                  alignment: Alignment.center,
                  color: Colors.blueGrey,
                  child: Text(
                      'Eric Oliveira Lima\n\nericol@outlook.com.br\n\n+55 034 988047387',
                      textAlign: TextAlign.center,),
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
  static final boxDecoration = BoxDecoration(

      boxShadow: [
        BoxShadow(
            color: Colors.transparent,)
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
                  //MaterialPageRoute(builder: (context) => SegundaPagina()));
                  MaterialPageRoute(builder: (context) => Space_copy()));
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
