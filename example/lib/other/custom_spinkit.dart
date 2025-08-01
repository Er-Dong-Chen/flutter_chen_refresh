import 'package:flutter/widgets.dart';

class SpinKitFadingCircle extends StatefulWidget {
  SpinKitFadingCircle({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.animationController,
    this.duration = const Duration(milliseconds: 1200),
  })  : assert(
            !(itemBuilder != null && color != null) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final AnimationController? animationController;
  final Duration duration;

  @override
  _SpinKitFadingCircleState createState() => _SpinKitFadingCircleState();
}

class _SpinKitFadingCircleState extends State<SpinKitFadingCircle>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

//    _controller = AnimationController(vsync: this, duration: widget.duration)
//      ..repeat();
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: [
            _circle(1, .0),
            _circle(2, -1.1),
            _circle(3, -1.0),
            _circle(4, -0.9),
            _circle(5, -0.8),
            _circle(6, -0.7),
            _circle(7, -0.6),
            _circle(8, -0.5),
            _circle(9, -0.4),
            _circle(10, -0.3),
            _circle(11, -0.2),
            _circle(12, -0.1),
          ],
        ),
      ),
    );
  }

  Widget _circle(int i, [double? delay]) {
    final _size = widget.size * 0.15, _position = widget.size * .5;

    return Positioned.fill(
      left: _position,
      top: _position,
      child: Transform(
        transform: Matrix4.rotationZ(30.0 * (i - 1) * 0.0174533),
        child: Align(
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0)
                .animate(widget.animationController!),
            child: SizedBox.fromSize(
              size: Size.square(_size),
              child: _itemBuilder(i - 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          );
  }
}
