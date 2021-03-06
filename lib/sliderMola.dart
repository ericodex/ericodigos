import 'dart:math';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

import 'main.dart';


class MinhaMola extends StatefulWidget {
  @override
  _MinhaMolaState createState() => _MinhaMolaState();
}

class _MinhaMolaState extends State<MinhaMola> {

  Widget _buildTextButton(String title, bool isOnLight) {
    return new FlatButton(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isOnLight
                ? Theme.of(context).highlightColor
                : Theme.of(context).primaryColor,
          )),
      onPressed: () {
        print('gostei...');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: new AppBar(
          flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Eric0d3Banner(),
                ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light,
          iconTheme: new IconThemeData(color: Theme.of(context).highlightColor),
          leading: new IconButton(
            icon: new Icon(Icons.favorite),
            onPressed: () {

              
            },
          ),
          actions: <Widget>[_buildTextButton('@'.toUpperCase(), true)],
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: SpringSlider(
                  markCount: 12,
                  positiveColor: Theme.of(context).highlightColor,
                  negativeColor: Theme.of(context).primaryColor),
            ),
            new Container(
              color: Theme.of(context).highlightColor,
              child: new Row(
                children: <Widget>[
                  _buildTextButton('Dart'.toUpperCase(), false),
                  new Expanded(child: new Container(
                    child: _buildTextButton('+'.toUpperCase(), false),
                  )),
                  _buildTextButton('Flutter'.toUpperCase(), false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SpringSlider extends StatefulWidget {
  final int markCount;
  final Color positiveColor;
  final Color negativeColor;

  SpringSlider({this.markCount, this.negativeColor, this.positiveColor});

  @override
  _SpringSliderState createState() => _SpringSliderState();
}

class _SpringSliderState extends State<SpringSlider>
    with TickerProviderStateMixin {
  final double paddingTop = 50.0;
  final double paddingBottom = 50.0;

  SpringySliderController sliderController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderController = new SpringySliderController(
      sliderPercent: 0.5,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double sliderPercent = sliderController.sliderValue;
    if (sliderController.state == SpringSliderState.springing) {
      sliderPercent = sliderController.springingPercent;
    }

    return SliderDragger(
      paddingBottom: paddingBottom,
      paddingTop: paddingTop,
      sliderController: sliderController,
      child: Stack(
        children: <Widget>[
          new SliderMarks(
            markCount: widget.markCount,
            color: widget.positiveColor,
            backgroundColor: widget.negativeColor,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ),
          new SliderGoo(
            child: new SliderMarks(
              markCount: widget.markCount,
              color: widget.negativeColor,
              paddingTop: paddingTop,
              backgroundColor: widget.positiveColor,
              paddingBottom: paddingBottom,
            ),
            sliderController: sliderController,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ),
          new SliderPoints(
            sliderController: sliderController,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ),
          /* new SliderDebug(
            sliderPercent: sliderController.state == SpringSliderState.dragging
                ? sliderController.draggingPercent
                : sliderPercent,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
          ) */
        ],
      ),
    );
  }
}

class SliderDebug extends StatelessWidget {
  final double sliderPercent;
  final double paddingTop;
  final double paddingBottom;

  const SliderDebug(
      {Key key, this.sliderPercent, this.paddingTop, this.paddingBottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight - paddingBottom - paddingTop;

        return new Stack(
          children: <Widget>[
            new Positioned(
              left: 0.0,
              right: 0.0,
              top: height * (1.0 - sliderPercent) + paddingTop,
              child: Container(
                height: 2.0,
                color: Colors.white,
              ),
            )
          ],
        );
      },
    );
  }
}

class SliderDragger extends StatefulWidget {
  final SpringySliderController sliderController;
  final Widget child;
  final double paddingTop;
  final double paddingBottom;

  SliderDragger(
      {this.child, this.sliderController, this.paddingBottom, this.paddingTop});

  @override
  _SliderDraggerState createState() => _SliderDraggerState();
}

class _SliderDraggerState extends State<SliderDragger> {
  double sliderPercent;
  double startDragY;
  double startDragPercent;

  @override
  void initState() {
    super.initState();
  }

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    startDragPercent = widget.sliderController.sliderValue;

    final sliderWidth = context.size.width;
    final sliderLeftPosition = (context.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0))
        .dx;
    final draggingHorizontalPercent =
        (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.onDragStart(draggingHorizontalPercent);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragDistance = startDragY - details.globalPosition.dy;
    final sliderHeight =
        context.size.height - widget.paddingTop - widget.paddingBottom;
    final dragPercent = dragDistance / sliderHeight;

    final sliderWidth = context.size.width;
    final sliderLeftPosition = (context.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0))
        .dx;
    final draggingHorizontalPercent =
        (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.draggingPercents =
        new Offset(draggingHorizontalPercent, startDragPercent + dragPercent);
  }

  void _onPanEnd(DragEndDetails details) {
    startDragY = null;
    startDragPercent = null;

    widget.sliderController.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}

class SliderGoo extends StatelessWidget {
  final SpringySliderController sliderController;
  final double paddingTop;
  final double paddingBottom;
  final Widget child;

  const SliderGoo(
      {Key key,
      this.sliderController,
      this.paddingTop,
      this.paddingBottom,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        // custom CLIP
        clipper: new SliderClipper(
          sliderController: sliderController,
          paddingTop: paddingTop,
          paddingBottom: paddingBottom,
        ),
        child: child);
  }
}

class SliderMarks extends StatelessWidget {
  final int markCount;
  final Color color;
  final Color backgroundColor;
  final double paddingTop;
  final double paddingBottom;

  SliderMarks(
      {this.color,
      this.markCount,
      this.backgroundColor,
      this.paddingBottom,
      this.paddingTop});

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new SliderMarksPainter(
          markCount: markCount,
          markColor: color,
          markThickness: 2.0,
          backgroundColor: backgroundColor,
          paddingTop: paddingTop,
          paddingRight: 20.0,
          paddingBottom: paddingBottom),
      child: Container(),
    );
  }
}

class SliderMarksPainter extends CustomPainter {
  final double largeMarkWidth = 30.0;
  final double smallMarkWidth = 10.0;

  final int markCount;
  final Color markColor;
  final Color backgroundColor;
  final double markThickness;
  final double paddingTop;
  final double paddingBottom;
  final double paddingRight;
  final Paint markPaint;
  final Paint backgroundPaint;

  SliderMarksPainter(
      {this.markColor,
      this.markCount,
      this.backgroundColor,
      this.markThickness,
      this.paddingBottom,
      this.paddingRight,
      this.paddingTop})
      : markPaint = new Paint()
          ..color = markColor
          ..strokeWidth = markThickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        backgroundPaint = new Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        backgroundPaint);

    final paintHeight = size.height - paddingTop - paddingBottom;
    final gap = paintHeight / (markCount - 1);

    for (int i = 0; i < markCount; ++i) {
      double markWidth = smallMarkWidth;
      if (i == 0 || i == markCount - 1) {
        // first or last
        markWidth = largeMarkWidth;
      } else if (i == 1 || i == markCount - 2) {
        // second or second last
        markWidth = prefix0.lerpDouble(
            smallMarkWidth, largeMarkWidth, 0.5); // divide double by 2
      }

      final markY = i * gap + paddingTop;

      canvas.drawLine(new Offset(size.width - paddingRight - markWidth, markY),
          new Offset(size.width - paddingRight, markY), markPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SliderClipper extends CustomClipper<Path> {
  final SpringySliderController sliderController;
  final double paddingTop;
  final double paddingBottom;

  SliderClipper({this.paddingBottom, this.paddingTop, this.sliderController});

  @override
  prefix0.Path getClip(prefix0.Size size) {
    switch (sliderController.state) {
      case SpringSliderState.idle:
        return _clipIdle(size);
      case SpringSliderState.dragging:
        return _clipDragging(size);
      case SpringSliderState.springing:
        return _clipSpringing(size);
    }
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<prefix0.Path> oldClipper) {
    return true;
  }

  Path _clipIdle(Size size) {
    Path rect = new Path();

    final top = paddingTop;
    final bottom = size.height;
    final height = (bottom - paddingTop) - top;
    final percentFromBottom = 1.0 - sliderController.sliderValue;

    rect.addRect(new Rect.fromLTRB(
        0.0, top + (percentFromBottom * height), size.width, bottom));

    return rect;
  }

  Path _clipDragging(Size size) {
    Path compositePath = new Path();

    final top = paddingTop;
    final bottom = size.height - paddingBottom;
    final height = bottom - top;
    final basePercentFromBottom = 1.0 - sliderController.sliderValue;
    final dragPercentFromBottom = 1.0 - sliderController.draggingPercent;

    final baseY = top + (basePercentFromBottom * height);
    final leftX = -0.15 * size.width;
    final leftPoint = Point(leftX, baseY);
    final rightX = 1.15 * size.width;
    final rightPoint = Point(rightX, baseY);

    final dragX = sliderController.draggingHorizontalPercent * size.width;
    final dragY = top + (dragPercentFromBottom * height);
    final crestPoint = new Point(dragX, dragY.clamp(top, bottom));

    double excessDrag = 0.0;
    if (sliderController.draggingPercent < 0.0) {
      excessDrag = sliderController.draggingPercent;
    } else if (sliderController.draggingPercent > 1.0) {
      excessDrag = sliderController.draggingPercent - 1.0;
    }

    final baseControlPointWidth = 150.0;
    final thickeningFactor = excessDrag * height * 0.05;
    final controlPointWidth =
        (200.0 * thickeningFactor).abs() + baseControlPointWidth;

    final rect = new Path();
    rect.moveTo(leftPoint.x, leftPoint.y);
    rect.lineTo(rightPoint.x, rightPoint.y);
    rect.lineTo(rightPoint.x, size.height);
    rect.lineTo(leftPoint.x, size.height);
    rect.lineTo(leftPoint.x, leftPoint.y);
    rect.close();

    compositePath.addPath(rect, Offset(0.0, 0.0));

    final curve = Path();
    curve.moveTo(crestPoint.x, crestPoint.y);
    curve.quadraticBezierTo(
      crestPoint.x - controlPointWidth,
      crestPoint.y,
      leftPoint.x,
      leftPoint.y,
    );
    curve.moveTo(crestPoint.x, crestPoint.y);
    curve.quadraticBezierTo(
      crestPoint.x + controlPointWidth,
      crestPoint.y,
      rightPoint.x,
      rightPoint.y,
    );

    curve.lineTo(leftPoint.x, leftPoint.y);
    curve.close();

    if (dragPercentFromBottom > basePercentFromBottom) {
      compositePath.fillType = PathFillType.evenOdd;
    }

    compositePath.addPath(curve, const Offset(0.0, 0.0));

    return compositePath;
  }

  Path _clipSpringing(Size size) {
    Path compositePath = new Path();

    final top = paddingTop;
    final bottom = size.height - paddingBottom;
    final height = bottom - top;
    final basePercentFromBottom = 1.0 - sliderController.springingPercent;
    final crestSpringPercentFromBottom =
        1.0 - sliderController.crestSpringingPercent;

    final baseY = top + (basePercentFromBottom * height);
    final leftX = -0.85 * size.width;
    final leftPoint = Point(leftX, baseY);

    final centerX = 0.15 * size.width;
    final centerPoint = Point(centerX,baseY);

    final rightX = 1.15 * size.width;
    final rightPoint = Point(rightX, baseY);

    final crestY = top + (crestSpringPercentFromBottom * height);
    final crestPoint = Point((rightX - centerX)/2+ centerX, crestY);

    final troughY = baseY + (baseY-crestY);
    final troughPoint = Point((centerX-leftX)/2 +leftX, troughY);
    
    final controlPointWidth = 100.0;
    
    final rect = new Path();
    rect.moveTo(leftPoint.x, leftPoint.y);
    rect.lineTo(rightPoint.x, rightPoint.y);
    rect.lineTo(rightPoint.x, size.height);
    rect.lineTo(leftPoint.x, size.height);
    rect.lineTo(leftPoint.x, leftPoint.y);
    rect.close();

    compositePath.addPath(rect, Offset(0.0, 0.0));

    final leftCurve = Path();
    leftCurve.moveTo(troughPoint.x, troughPoint.y);
    leftCurve.quadraticBezierTo(
      troughPoint.x - controlPointWidth,
      troughPoint.y,
      leftPoint.x,
      leftPoint.y,
    );
    leftCurve.moveTo(troughPoint.x, troughPoint.y);
    leftCurve.quadraticBezierTo(
      troughPoint.x + controlPointWidth,
      troughPoint.y,
      centerPoint.x,
      centerPoint.y,
    );

    leftCurve.lineTo(leftPoint.x, leftPoint.y); 
    leftCurve.close();

    if (crestSpringPercentFromBottom < basePercentFromBottom) {
      compositePath.fillType = PathFillType.nonZero;
    }

    compositePath.addPath(leftCurve ,const Offset(0.0, 0.0));

    final rightCurve = Path();
    rightCurve.moveTo(crestPoint.x, crestPoint.y);
    rightCurve.quadraticBezierTo(
      crestPoint.x - controlPointWidth,
      crestPoint.y,
      centerPoint.x,
      centerPoint.y,
    );
    rightCurve.moveTo(crestPoint.x, crestPoint.y);
    rightCurve.quadraticBezierTo(
      crestPoint.x + controlPointWidth,
      crestPoint.y,
      rightPoint.x,
      rightPoint.y,
    );

    rightCurve.lineTo(centerPoint.x, centerPoint.y); 
    rightCurve.close();

    if (crestSpringPercentFromBottom > basePercentFromBottom) {
      compositePath.fillType = PathFillType.evenOdd;
    }

    compositePath.addPath(rightCurve, const Offset(0.0, 0.0));

    return compositePath;
  }
}

class SliderPoints extends StatelessWidget {
  final SpringySliderController sliderController;
  final double paddingTop;
  final double paddingBottom;

  const SliderPoints(
      {Key key, this.sliderController, this.paddingTop, this.paddingBottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double sliderPercent = sliderController.sliderValue ;
        if ( sliderController.state == SpringSliderState.dragging){
          sliderPercent =  sliderController.draggingPercent.clamp(0.0001, 1.0);
        }

        final height = constraints.maxHeight - paddingTop - paddingBottom;
        final sliderY = height * (1.0 - sliderPercent) + paddingTop;
        final pointsYouNeed = (100 * (1.0 - sliderPercent)).round();
        final pointsYouHave = (100 - pointsYouNeed);
        final pointsYouNeedPercent = 1.0 - sliderPercent;
        final pointsYouHavePercent = sliderPercent;

        return new Stack(
          children: <Widget>[
            new Positioned(
              left: 30.0,
              top: sliderY - 10.0 - (40.0 * pointsYouNeedPercent),
              child: FractionalTranslation(
                  translation: Offset(0.0, -1.0),
                  child: new Points(
                    points: pointsYouNeed,
                    isAboveSlider: true,
                    isPointsYouNeed: true,
                    color: Theme.of(context).highlightColor,
                  )),
            ),
            new Positioned(
              left: 30.0,
              top: sliderY + 10 +(40.0 * pointsYouHavePercent),
              child: new Points(
                points: pointsYouHave,
                isAboveSlider: false,
                isPointsYouNeed: false,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        );
      },
    );
  }
}

class Points extends StatelessWidget {
  final int points;
  final bool isAboveSlider;
  final bool isPointsYouNeed;
  final Color color;

  Points({this.color, this.isAboveSlider, this.isPointsYouNeed, this.points});

  @override
  Widget build(BuildContext context) {
    final percent = points / 100.0;
    final pointTextSize = 50.0 + (50.0 * percent);

    return Row(
      crossAxisAlignment:
          isAboveSlider ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        FractionalTranslation(
          translation: Offset(-0.05 * percent, isAboveSlider ? -100 : -0.18),
          child: new Text(
            "$points",
            style: new TextStyle(
              fontSize: pointTextSize,
              color: color,
            ),
          ),
        ),
        new Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Pontos',
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, color: isAboveSlider ? color : Colors.transparent),
                ),
              ),
              new Text(isPointsYouNeed ? '^.^' : '',
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, color: color))
            ],
          ),
        )
      ],
    );
  }
}

class SpringySliderController extends ChangeNotifier {
  final SpringDescription sliderSpring = new SpringDescription(
    mass: 50.0,
    stiffness: 80.0,
    damping: 10.0,
  );

  final SpringDescription crestSpring = new SpringDescription(
    mass: 2.0,
    stiffness: 5.0,
    damping: 0.1,
  );

  final TickerProvider _vsync;

  SpringSliderState _state = SpringSliderState.idle;

  // Stable slider value.
  double _sliderPercent;

  // Slider value during user drag
  double _draggingPercent;
  // Slider horizontal value during user drag;
  double _draggingHorizontalPercent;

  // when springing to new slider value, this is where the UI is springing from.
  double _springStartPercent;
  // when springing to new slider value, this is where the UI is springing to.
  double _springEndPercent;
  // current slider value during spring effect
  double _springingPercent;
  //physics spring
  SpringSimulation _sliderSpringSimulation;

  double _crestSpringingStartPercent;
  double _crestSpringingEndPercent;
  double _crestSpringingPercent;
  SpringSimulation _crestSpringSimulation;

  // Ticker that computes current spring position based on time.
  Ticker _springTicker;
  // Elapsed time that has passed since the start of the spring
  double _springTime;

  SpringySliderController({
    double sliderPercent = 0.0,
    vsync,
  })  : _vsync = vsync,
        _sliderPercent = sliderPercent;

  void dispose() {
    if (_springTicker != null) {
      _springTicker.dispose();
    }
    super.dispose();
  }

  SpringSliderState get state => _state;

  double get sliderValue => _sliderPercent;

  set sliderValue(double newValue) {
    _sliderPercent = newValue;
    notifyListeners();
  }

  double get draggingPercent => _draggingPercent;

  double get draggingHorizontalPercent => _draggingHorizontalPercent;

  set draggingPercents(Offset draggingPercent) {
    _draggingHorizontalPercent = draggingPercent.dx;
    _draggingPercent = draggingPercent.dy;
    notifyListeners();
  }

  void onDragStart(double draggingHorizontalPercent) {
    if (_springTicker != null) {
      _springTicker
        ..stop()
        ..dispose();
    }

    _state = SpringSliderState.dragging;
    _draggingPercent = _sliderPercent;
    _draggingHorizontalPercent = draggingHorizontalPercent;

    notifyListeners();
  }

  void onDragEnd() {
    _state = SpringSliderState.springing;
    _springingPercent = _sliderPercent;
    _springStartPercent = _sliderPercent;
    _springEndPercent = _draggingPercent.clamp(0.0, 1.0);

    _crestSpringingPercent = draggingPercent;
    _crestSpringingStartPercent = draggingPercent;
    _crestSpringingEndPercent = _springStartPercent;

    _draggingPercent = null;

    _sliderPercent = _springEndPercent;

    _startSpringing();
    print(_sliderPercent);
    notifyListeners();
  }

  void _startSpringing() {
    if (_springStartPercent == _springEndPercent) {
      _state = SpringSliderState.idle;
      notifyListeners();
    }

    _sliderSpringSimulation = new SpringSimulation(
        sliderSpring, _springStartPercent, _springEndPercent, 0.0);

    final crestSpringNormal =
        (_crestSpringingEndPercent - _crestSpringingStartPercent) /
            (_crestSpringingEndPercent - _crestSpringingStartPercent).abs();

    _crestSpringSimulation = new SpringSimulation(
        crestSpring,
        _crestSpringingStartPercent,
        _crestSpringingEndPercent,
        0.4 * crestSpringNormal * (_crestSpringingStartPercent - _crestSpringingEndPercent).abs());

    _springTime = 0.0;

    _springTicker = _vsync.createTicker(_springTick)..start();
    notifyListeners();
  }

  void _springTick(Duration deltaTime) {
    final lastFrameTime = deltaTime.inMilliseconds.toDouble() / 1680.0;

    _springTime += lastFrameTime;
    _springingPercent = _sliderSpringSimulation.x(_springTime);

    _crestSpringingPercent = _crestSpringSimulation.x(lastFrameTime);
    _crestSpringSimulation = new SpringSimulation(
        crestSpring,
        _crestSpringingPercent,
        _springingPercent,
        _crestSpringSimulation.dx(lastFrameTime));

    if (_sliderSpringSimulation.isDone(_springTime) && _crestSpringSimulation.isDone(lastFrameTime)) {
      _springTicker
        ..stop()
        ..dispose();
      _springTicker = null;

      _state = SpringSliderState.idle;
    }

    notifyListeners();
  }

  double get springingPercent => _springingPercent;

  double get crestSpringingPercent => _crestSpringingPercent;


}

enum SpringSliderState {
  idle,
  dragging,
  springing,
}