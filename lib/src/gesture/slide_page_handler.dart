import 'package:extended_image/src/gesture/slide_page.dart';
import 'package:extended_image/src/gesture/utils.dart';
import 'package:extended_image/src/typedef.dart';
import 'package:extended_image/src/utils.dart';
import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/6/14
///

/// for loading/failed widget
class ExtendedImageSlidePageHandler extends StatefulWidget {
  const ExtendedImageSlidePageHandler({
    super.key,
    this.child,
    this.extendedImageSlidePageState,
    this.heroBuilderForSlidingPage,
  });
  final Widget? child;
  final ExtendedImageSlidePageState? extendedImageSlidePageState;

  ///build Hero only for sliding page
  final HeroBuilderForSlidingPage? heroBuilderForSlidingPage;
  @override
  ExtendedImageSlidePageHandlerState createState() =>
      ExtendedImageSlidePageHandlerState();
}

class ExtendedImageSlidePageHandlerState
    extends State<ExtendedImageSlidePageHandler> {
  late Offset _startingOffset;
  ExtendedImageSlidePageState? _extendedImageSlidePageState;
  @override
  void didChangeDependencies() {
    _extendedImageSlidePageState = widget.extendedImageSlidePageState ??
        context.findAncestorStateOfType<ExtendedImageSlidePageState>();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ExtendedImageSlidePageHandler oldWidget) {
    _extendedImageSlidePageState = widget.extendedImageSlidePageState ??
        context.findAncestorStateOfType<ExtendedImageSlidePageState>();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
    if (_extendedImageSlidePageState != null) {
      result = widget.heroBuilderForSlidingPage?.call(result) ?? result;
    }
    if (_extendedImageSlidePageState != null &&
        _extendedImageSlidePageState!.widget.slideType == SlideType.onlyImage) {
      result = Transform.translate(
        offset: _extendedImageSlidePageState!.offset,
        child: Transform.scale(
          scale: _extendedImageSlidePageState!.scale,
          child: result,
        ),
      );
    }
    return result;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _startingOffset = details.focalPoint;
  }

  Offset? _updateSlidePagePreOffset;
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    ///whether gesture page
    if (_extendedImageSlidePageState != null && details.scale == 1.0) {
      final double delta = (details.focalPoint - _startingOffset).distance;

      if (delta.greaterThan(minGesturePageDelta)) {
        _updateSlidePagePreOffset ??= details.focalPoint;
        _extendedImageSlidePageState!.slide(
            details.focalPoint - _updateSlidePagePreOffset!,
            extendedImageSlidePageHandlerState: this);
        _updateSlidePagePreOffset = details.focalPoint;
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_extendedImageSlidePageState != null &&
        _extendedImageSlidePageState!.isSliding) {
      _updateSlidePagePreOffset = null;
      _extendedImageSlidePageState!.endSlide(details);
      return;
    }
  }

  void slide() {
    if (mounted) {
      setState(() {});
    }
  }
}
