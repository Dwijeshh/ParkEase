import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'exit_qr.dart';

/// Natural image dimensions of FLOORPLAN.jpeg (px).
const double _imgW = 1300.0;
const double _imgH = 900.0;

class ExitMapScreen extends StatefulWidget {
  final ParkingAssignment assignment;
  final double amount;
  final DateTime entryTime;
  final DateTime exitTime;

  const ExitMapScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.entryTime,
    required this.exitTime,
  });

  @override
  State<ExitMapScreen> createState() => _ExitMapScreenState();
}

class _ExitMapScreenState extends State<ExitMapScreen>
    with SingleTickerProviderStateMixin {
  // ── Route data ─────────────────────────────────────────────
  List<_ExitNode> _path = [];
  bool _isLoadingRoute = true;
  String? _routeError;

  // ── Animation ──────────────────────────────────────────────
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _loadExitRoute();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Load exit route from API ───────────────────────────────

  Future<void> _loadExitRoute() async {
    final parkingNodeId = widget.assignment.parkingNodeId;
    if (parkingNodeId <= 0) {
      setState(() => _isLoadingRoute = false);
      return;
    }

    try {
      final data = await CustomerApiService.getExitRoute(parkingNodeId);
      if (data == null || data['path'] == null) {
        throw Exception('Exit route not found for node $parkingNodeId');
      }
      final rawPath = data['path'] as List;
      final path = rawPath
          .whereType<Map>()
          .map((n) => _ExitNode(
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

  Offset _scale(_ExitNode n, Size canvasSize) {
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

  void _continueToQr(BuildContext context) {
    Navigator.of(context).push(
      slideRoute(
        ExitQrScreen(
          assignment: widget.assignment,
          amount: widget.amount,
          entryTime: widget.entryTime,
          exitTime: widget.exitTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Exit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // TOP INFORMATION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route to Parking Exit',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Leaving Slot ${widget.assignment.slot} to EXIT Gate',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FLOORPLAN MAP WITH EXIT ROUTE
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FB),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
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
                                  painter: _ExitRoutePainter(_path, canvasSize),
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

                            // ── Start Slot Pin ────────────────────────────
                            if (!_isLoadingRoute && _path.isNotEmpty)
                              Builder(builder: (context) {
                                final start = _scale(_path.first, canvasSize);
                                return Positioned(
                                  left: start.dx - 18,
                                  top: start.dy - 40,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withValues(alpha: 0.4),
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
                                          width: 2, height: 8, color: AppColors.primary),
                                      const CircleAvatar(
                                        radius: 4,
                                        backgroundColor: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                );
                              }),

                            // ── EXIT PIN ──────────────────────────
                            if (!_isLoadingRoute && _path.isNotEmpty)
                              Builder(builder: (context) {
                                final dest = _scale(_path.last, canvasSize);
                                return Positioned(
                                  left: dest.dx - 22,
                                  top: dest.dy - 40,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
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
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.logout_rounded, size: 10, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              'EXIT',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
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
                                        'Calculating exit route…',
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
                                    'Route to exit unavailable — showing floor plan only',
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
                ),
              ),

              const SizedBox(height: 16),

              // ROUTE INFORMATION
              Row(
                children: [
                  const Icon(
                    Icons.route_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Follow the animated path from slot ${widget.assignment.slot} to the parking exit gate.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // REACHED EXIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _continueToQr(context),
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                  ),
                  label: const Text(
                    "I've Reached the Exit - Scan QR",
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Exit Route painter
// ─────────────────────────────────────────────────────────────

class _ExitRoutePainter extends CustomPainter {
  final List<_ExitNode> path;
  final Size canvasSize;

  const _ExitRoutePainter(this.path, this.canvasSize);

  Offset _s(_ExitNode n) => Offset(
        n.x * canvasSize.width / _imgW,
        n.y * canvasSize.height / _imgH,
      );

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;
    final points = path.map(_s).toList();

    // Dashed background lane
    final dashPaint = Paint()
      ..color = const Color(0xFFE11D48).withValues(alpha: 0.3) // soft red/crimson
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
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.9) // solid red line for exiting
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
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;
    final dotBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < points.length - 1; i++) {
      canvas.drawCircle(points[i], 5, dotFill);
      canvas.drawCircle(points[i], 5, dotBorder);
    }

    // Start slot dot (blue)
    final startFill = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(points.first, 7, startFill);
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
  bool shouldRepaint(_ExitRoutePainter old) =>
      old.path != path || old.canvasSize != canvasSize;
}

// ─────────────────────────────────────────────────────────────
// Exit Node data class
// ─────────────────────────────────────────────────────────────

class _ExitNode {
  final int id;
  final double x;
  final double y;
  const _ExitNode({required this.id, required this.x, required this.y});
}