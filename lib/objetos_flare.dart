import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

/// --- VAPORWAVE FLARE FILE

class VapowaveSpace extends StatefulWidget {
  const VapowaveSpace({Key key}) : super(key: key);

  @override
  _VapowaveSpaceState createState() => _VapowaveSpaceState();
}

class _VapowaveSpaceState extends State<VapowaveSpace> {
  @override
  Widget build(BuildContext context) {
    //var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.deepPurple[900],
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,18.0,8.0,8.0),
              child: Container(
                decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text('Atuações nas áreas de finanças e tecnologia de empresas como Bradesco Cartões, Algar Tecnologia, Alsol e Up Brasil.',
                  style: TextStyle(color: Colors.deepPurpleAccent[900],
                  height: 1.4),
                  ),
                ),
              ),
            ),
            Container(height: 300,
              child: FlareActor("assets/flares/space_vaporwave.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "space'84"),
            ),
          ],
        ));
  }
}

/// --- SWITCH DAY AND NIGHT MODE

class InterruptorCicardiano extends StatefulWidget {
  InterruptorCicardiano({Key key}) : super(key: key);

  @override
  _InterruptorCicardianoState createState() => _InterruptorCicardianoState();
}

String _diaOuNoite = 'day_idle';

class _InterruptorCicardianoState extends State<InterruptorCicardiano> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_diaOuNoite == 'day_idle') {
            _diaOuNoite = 'night_idle';
          } else {
            _diaOuNoite = 'day_idle';
          }
        });
      },
      child: Container(
        child: FlareActor(
          'assets/flares/interruptorCircadiano.flr',
          animation: _diaOuNoite,
        ),
      ),
    );
  }
}

class Capibara extends StatefulWidget {
  Capibara({Key key}) : super(key: key);

  @override
  _CapibaraState createState() => _CapibaraState();
}

class _CapibaraState extends State<Capibara> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(
                    child: Text(
                      'Também faço ilustrações digitais interativas com a tecnologia Flare.',
                      style: TextStyle(
                          height: 1.3,
                          fontSize: 10,
                          fontFamily: 'pressP2',
                          color: Colors.amber[600]),
                    ),
                  ),
                )),
                Container(
                    height: 200,
                    color: Colors.amber[600],
                    child: FlareActor(
                      'assets/flares/capivara.flr',
                      animation: "move",
                    )),
              ],
            ),
          ]),
        )
      ],
    );
  }
}
