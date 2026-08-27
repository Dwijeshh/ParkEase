import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'popup.dart';

/// Natural image dimensions of FLOORPLAN.jpeg (px).
/// DB node coordinates are in this same pixel space.
const double _imgW = 1300.0;
const double _imgH = 900.0;

class FacilityMap extends StatefulWidget {
  final ParkingAssignment assignment;

  const FacilityMap({super.key, required this.assignment});

  @override
  State<FacilityMap> createState() => _FacilityMapState();
}

class _FacilityMapState extends State<FacilityMap>
    with SingleTickerProviderStateMixin {
  // ── Route data ─────────────────────────────────────────────
  List<_Node> _path = [];
  bool _isLoadingRoute = true;
  String? _routeError;

  // ── Animation ──────────────────────────────────────────────
  late final AnimationController _controller;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_popupShown) {
        _popupShown = true;
        _showArrivalPopup();
      }
    });
    _loadRoute();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Load route from API ────────────────────────────────────

  Future<void> _loadRoute() async {
    final parkingNodeId = widget.assignment.parkingNodeId;
    if (parkingNodeId <= 0) {
      // No node ID — show image without route
      setState(() => _isLoadingRoute = false);
      return;
    }

    try {
      final data = await CustomerApiService.getEntryRoute(parkingNodeId);
      if (data == null || data['path'] == null) {
        throw Exception('Route not found for node $parkingNodeId');
      }
      final rawPath = data['path'] as List;
      final path = rawPath
          .whereType<Map>()
          .map((n) => _Node(
                id: (n['nodeId'] as num).toInt(),
                x: (n['x'] as num).toDouble(),
                y: (n['y'] as num).toDouble(),
              ))
          .toList();

      if (!mounted) return;
      setState(() {
        _path = path;
        _isLoadingRoute = false;
      });
      // Short delay then animate
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) _controller.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingRoute = false;
        _routeError = e.toString();
      });
    }
  }

  // ── Coordinate scaling ─────────────────────────────────────

  Offset _scale(_Node n, Size canvasSize) {
    return Offset(
      n.x * canvasSize.width / _imgW,
      n.y * canvasSize.height / _imgH,
    );
  }

  /// Interpolate smoothly along the polyline path.
  Offset _interpolate(double t, Size canvasSize) {
    if (_path.isEmpty) return Offset(canvasSize.width / 2, canvasSize.height / 2);
    if (_path.length == 1) return _scale(_path.first, canvasSize);

    final points = _path.map((n) => _scale(n, canvasSize)).toList();
    double totalLen = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalLen += (points[i + 1] - points[i]).distance;
    }

    final target = t * totalLen;
    double accumulated = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final segLen = (points[i + 1] - points[i]).distance;
      if (accumulated + segLen >= target) {
        final segT = (target - accumulated) / segLen;
        return Offset.lerp(points[i], points[i + 1], segT)!;
      }
      accumulated += segLen;
    }
    return points.last;
  }

  // ── Arrival popup ──────────────────────────────────────────

  void _showArrivalPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showParkHereDialog(context, slotId: widget.assignment.slot);
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _imgW / _imgH,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                // ── FLOORPLAN image ─────────────────────────
                Positioned.fill(
                  child: Image.asset(
                    'FLOORPLAN.jpeg',
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF3F6FB),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map_outlined,
                              size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Floor plan not available',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Route polyline + dots ───────────────────
                if (!_isLoadingRoute && _path.isNotEmpty)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RoutePainter(_path, canvasSize),
                    ),
                  ),

                // ── Animated car ────────────────────────────
                if (!_isLoadingRoute && _path.length >= 2)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final pos = _interpolate(
                        Curves.easeInOut.transform(_controller.value),
                        canvasSize,
                      );
                      return Positioned(
                        left: pos.dx - 14,
                        top: pos.dy - 14,
                        child: child!,
                      );
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_car_filled_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // ── Destination slot pin ─────────────────────
                if (!_isLoadingRoute && _path.isNotEmpty)
                  Builder(builder: (context) {
                    final dest = _scale(_path.last, canvasSize);
                    return Positioned(
                      left: dest.dx - 18,
                      top: dest.dy - 40,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              widget.assignment.slot,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                              width: 2, height: 8, color: AppColors.success),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.success,
                          ),
                        ],
                      ),
                    );
                  }),

                // ── Loading overlay ──────────────────────────
                if (_isLoadingRoute)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 10),
                          Text(
                            'Calculating route…',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Route error badge ────────────────────────
                if (_routeError != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Route unavailable — showing floor plan only',
                        style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Route painter
// ─────────────────────────────────────────────────────────────

class _RoutePainter extends CustomPainter {
  final List<_Node> path;
  final Size canvasSize;

  const _RoutePainter(this.path, this.canvasSize);

  Offset _s(_Node n) => Offset(
        n.x * canvasSize.width / _imgW,
        n.y * canvasSize.height / _imgH,
      );

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;
    final points = path.map(_s).toList();

    // Dashed background lane
    final dashPaint = Paint()
      ..color = const Color(0xFF2F6FED).withValues(alpha: 0.35)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final bgPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      bgPath.lineTo(p.dx, p.dy);
    }
    _drawDashed(canvas, bgPath, dashPaint, 10, 5);

    // Solid route line
    final linePaint = Paint()
      ..color = const Color(0xFF2F6FED).withValues(alpha: 0.9)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      routePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(routePath, linePaint);

    // Junction dots (intermediate)
    final dotFill = Paint()
      ..color = const Color(0xFF2F6FED)
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < points.length - 1; i++) {
      canvas.drawCircle(points[i], 5, dotFill);
      canvas.drawCircle(points[i], 5, dotBorder);
    }

    // Entry dot (green)
    final entryFill = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points.first, 7, entryFill);
    canvas.drawCircle(points.first, 7, dotBorder);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint,
      double dashLen, double gapLen) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLen).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.path != path || old.canvasSize != canvasSize;
}

// ─────────────────────────────────────────────────────────────
// Node data class
// ─────────────────────────────────────────────────────────────

class _Node {
  final int id;
  final double x;
  final double y;
  const _Node({required this.id, required this.x, required this.y});
}
