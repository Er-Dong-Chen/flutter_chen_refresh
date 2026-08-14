/*
    Author: ErDongChen
    Email: 1251752648@qq.com
    createTime:2025-07-15 14:39
 */
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER
// ignore_for_file: INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import 'package:flutter_chen_refresh/src/internals/slivers.dart';

/// a scrollPhysics for config refresh scroll effect,enable viewport out of edge whatever physics it is
/// in [ClampingScrollPhysics], it doesn't allow to flip out of edge,but in RefreshPhysics,it will allow to do that,
/// by parent physics passing,it also can attach the different of iOS and Android different scroll effect
/// it also handles interception scrolling when refreshed, or when the second floor is open and closed.
/// with [SpringDescription] passing,you can custom spring back animate,the more paramter can be setting in [RefreshConfiguration]
///
/// see also:
///
/// * [RefreshConfiguration], a configuration for Controlling how SmartRefresher widgets behave in a subtree
// ignore: MUST_BE_IMMUTABLE
class RefreshPhysics extends ScrollPhysics {
  final double? maxOverScrollExtent, maxUnderScrollExtent;
  final double? topHitBoundary, bottomHitBoundary;
  final SpringDescription? springDescription;
  final double? dragSpeedRatio;
  final bool? enableScrollWhenTwoLevel, enableScrollWhenRefreshCompleted;
  final RefreshController? controller;
  final int? updateFlag;

  /// find out the viewport when bouncing,for compute the layoutExtent in header and footer
  /// This does not have any impact on performance. it only  execute once
  RenderViewportBase? viewportRender;

  /// Creates scroll physics that bounce back from the edge.
  RefreshPhysics(
      {ScrollPhysics? parent,
      this.updateFlag,
      this.maxUnderScrollExtent,
      this.springDescription,
      this.controller,
      this.dragSpeedRatio,
      this.topHitBoundary,
      this.bottomHitBoundary,
      this.enableScrollWhenRefreshCompleted,
      this.enableScrollWhenTwoLevel,
      this.maxOverScrollExtent})
      : super(parent: parent);

  @override
  RefreshPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshPhysics(
        parent: buildParent(ancestor),
        updateFlag: updateFlag,
        springDescription: springDescription,
        dragSpeedRatio: dragSpeedRatio,
        enableScrollWhenTwoLevel: enableScrollWhenTwoLevel,
        topHitBoundary: topHitBoundary,
        bottomHitBoundary: bottomHitBoundary,
        controller: controller,
        enableScrollWhenRefreshCompleted: enableScrollWhenRefreshCompleted,
        maxUnderScrollExtent: maxUnderScrollExtent,
        maxOverScrollExtent: maxOverScrollExtent);
  }

  RenderViewportBase? findViewport(BuildContext? context) {
    if (context == null) {
      return null;
    }
    RenderViewportBase? result;
    context.visitChildElements((Element e) {
      if (result != null) return;
      final RenderObject? renderObject = e.findRenderObject();
      if (renderObject is RenderViewportBase) {
        result = renderObject;
      } else {
        result = findViewport(e);
      }
    });
    return result;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // TODO: implement shouldAcceptUserOffset
    if (parent is NeverScrollableScrollPhysics) {
      return false;
    }
    return true;
  }

  //  It seem that it was odd to do so,but I have no choose to do this for updating the state value(enablePullDown and enablePullUp),
  // in Scrollable.dart _shouldUpdatePosition method,it use physics.runtimeType to check if the two physics is the same,this
  // will lead to whether the newPhysics should replace oldPhysics,If flutter can provide a method such as "shouldUpdate",
  // It can work perfectly.
  @override
  // TODO: implement runtimeType
  Type get runtimeType {
    if (updateFlag == 0) {
      return RefreshPhysics;
    } else {
      return BouncingScrollPhysics;
    }
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // TODO: implement applyPhysicsToUserOffset
    viewportRender ??=
        findViewport(controller?.position?.context.storageContext);
    if (controller?.headerStatus == RefreshStatus.twoLeveling) {
      if (offset > 0.0) {
        return super.applyPhysicsToUserOffset(position, offset);
      }
    } else {
      if ((offset > 0.0 &&
              viewportRender?.firstChild is! RenderSliverRefresh) ||
          (offset < 0 && viewportRender?.lastChild is! RenderSliverLoading)) {
        return super.applyPhysicsToUserOffset(position, offset);
      }
    }
    if (position.viewportDimension <= 0.0) {
      return super.applyPhysicsToUserOffset(position, offset);
    }
    if (position.outOfRange ||
        controller?.headerStatus == RefreshStatus.twoLeveling) {
      final double overscrollPastStart =
          math.max(position.minScrollExtent - position.pixels, 0.0);
      final double overscrollPastEnd = math.max(
          position.pixels -
              (controller?.headerStatus == RefreshStatus.twoLeveling
                  ? 0.0
                  : position.maxScrollExtent),
          0.0);
      final double overscrollPast =
          math.max(overscrollPastStart, overscrollPastEnd);
      final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
          (overscrollPastEnd > 0.0 && offset > 0.0);

      final double friction = easing
          // Apply less resistance when easing the overscroll vs tensioning.
          ? frictionFactor(
              (overscrollPast - offset.abs()) / position.viewportDimension)
          : frictionFactor(overscrollPast / position.viewportDimension);
      final double direction = offset.sign;
      return direction *
          _applyFriction(overscrollPast, offset.abs(), friction) *
          (dragSpeedRatio ?? 1.0);
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  double frictionFactor(double overscrollFraction) =>
      0.52 * math.pow(1 - overscrollFraction, 2);

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final ScrollPosition? scrollPosition =
        position is ScrollPosition ? position : null;
    viewportRender ??=
        findViewport(controller?.position?.context.storageContext);
    bool notFull = position.minScrollExtent == position.maxScrollExtent;
    final bool enablePullDown = viewportRender == null
        ? false
        : viewportRender!.firstChild is RenderSliverRefresh;
    final bool enablePullUp = viewportRender == null
        ? false
        : viewportRender!.lastChild is RenderSliverLoading;
    if (controller?.headerStatus == RefreshStatus.twoLeveling) {
      if (position.pixels - value > 0.0) {
        return super.applyBoundaryConditions(position, value);
      }
    } else {
      if ((position.pixels - value > 0.0 && !enablePullDown) ||
          (position.pixels - value < 0 && !enablePullUp)) {
        return super.applyBoundaryConditions(position, value);
      }
    }
    double topExtra = 0.0;
    double bottomExtra = 0.0;
    if (enablePullDown) {
      final RenderSliverRefresh sliverHeader =
          viewportRender!.firstChild as RenderSliverRefresh;
      topExtra = sliverHeader.hasLayoutExtent
          ? 0.0
          : sliverHeader.refreshIndicatorLayoutExtent;
    }
    if (enablePullUp) {
      final RenderSliverLoading sliverFooter =
          viewportRender!.lastChild as RenderSliverLoading;
      final storageContext = controller?.position?.context.storageContext;
      final configuration = storageContext == null
          ? null
          : RefreshConfiguration.of(storageContext);
      bottomExtra =
          (!notFull && (sliverFooter.geometry?.scrollExtent ?? 0.0) != 0.0) ||
                  (notFull &&
                      controller?.footerStatus == LoadStatus.noMore &&
                      !(configuration?.enableLoadingWhenNoData ?? true)) ||
                  (notFull && (configuration?.hideFooterWhenNotFull ?? false))
              ? 0.0
              : sliverFooter.layoutExtent;
    }
    final double maxOver = maxOverScrollExtent ?? double.infinity;
    final double maxUnder = maxUnderScrollExtent ?? double.infinity;
    final double topHit = topHitBoundary ?? double.infinity;
    final double bottomHit = bottomHitBoundary ?? double.infinity;
    final double topBoundary = position.minScrollExtent - maxOver - topExtra;
    final double bottomBoundary =
        position.maxScrollExtent + maxUnder + bottomExtra;

    if (scrollPosition?.activity is BallisticScrollActivity) {
      if (topHit != double.infinity) {
        if (value < -topHit && -topHit <= position.pixels) {
          // hit top edge
          return value + topHit;
        }
      }
      if (bottomHit != double.infinity) {
        if (position.pixels < bottomHit + position.maxScrollExtent &&
            bottomHit + position.maxScrollExtent < value) {
          // hit bottom edge
          return value - bottomHit - position.maxScrollExtent;
        }
      }
    }
    if (maxOver != double.infinity &&
        value < topBoundary &&
        topBoundary < position.pixels) // hit top edge
      return value - topBoundary;
    if (maxUnder != double.infinity &&
        position.pixels < bottomBoundary &&
        bottomBoundary < value) {
      // hit bottom edge
      return value - bottomBoundary;
    }

    // Once the scroll position has reached the configured overscroll limit,
    // do not allow ballistic or drag activities to push it even further out.
    if (maxOver != double.infinity &&
        value < position.pixels &&
        position.pixels <= topBoundary) {
      return value - position.pixels;
    }
    if (maxUnder != double.infinity &&
        bottomBoundary <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // TODO: implement createBallisticSimulation
    viewportRender ??=
        findViewport(controller?.position?.context.storageContext);

    final bool enablePullDown = viewportRender == null
        ? false
        : viewportRender!.firstChild is RenderSliverRefresh;
    final bool enablePullUp = viewportRender == null
        ? false
        : viewportRender!.lastChild is RenderSliverLoading;
    if (controller?.headerStatus == RefreshStatus.twoLeveling) {
      if (velocity < 0.0) {
        return super.createBallisticSimulation(position, velocity);
      }
    } else if (!position.outOfRange) {
      if ((velocity < 0.0 && !enablePullDown) ||
          (velocity > 0 && !enablePullUp)) {
        return super.createBallisticSimulation(position, velocity);
      }
    }
    if ((position.pixels > 0 &&
            controller?.headerStatus == RefreshStatus.twoLeveling) ||
        position.outOfRange) {
      return BouncingScrollSimulation(
        spring: springDescription ?? spring,
        position: position.pixels,
        // -1.0 avoid stop springing back ,and release gesture
        velocity: velocity * 0.91,
        // TODO(abarth): We should move this constant closer to the drag end.
        leadingExtent: position.minScrollExtent,
        trailingExtent: controller?.headerStatus == RefreshStatus.twoLeveling
            ? 0.0
            : position.maxScrollExtent,
        tolerance: toleranceFor(position),
      );
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
