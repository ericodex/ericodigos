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
        body: Center(
            child: FlareActor("assets/flares/space_vaporwave.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "space'84")));
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
    return Container(
      child: FlareActor(
        'assets/flares/interruptorCircadiano.flr',
        animation: _diaOuNoite,
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
          child: Container(
            color: Colors.amber[600],
          child: FlareActor(
        'assets/flares/capivara.flr',
        animation: "move",
      )),
        )
      ],
    );
  }
}
