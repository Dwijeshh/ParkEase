import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

const _canvasWidth = 340.0;
const _canvasHeight = 460.0;

const _entryGate = Offset(170, 14);

const _entrancePoints = {
  'Entrance 1': Offset(84, 90),
  'Entrance 2': Offset(84, 160),
  'Entrance 3': Offset(84, 230),
  'Entrance 4': Offset(84, 300),
  'Entrance 5': Offset(84, 370),
};

// Matches the fixed destinationOptions in models.dart — each option's slot
// maps to a point on this schematic near its real entrance/zone.
const _slotTargets = {
  'B01': Offset(135, 90),
  'B03': Offset(135, 160),
  'B05': Offset(135, 230),
  'B07': Offset(135, 300),
  'E02': Offset(150, 405),
};

class FacilityMap extends StatefulWidget {
  final ParkingAssignment assignment;

  const FacilityMap({super.key, required this.assignment});

  @override
  State<FacilityMap> createState() => _FacilityMapState();
}

class _FacilityMapState extends State<FacilityMap> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset get _target => _slotTargets[widget.assignment.slot] ?? const Offset(170, 230);

  Offset _dotPosition(double t) {
    final target = _target;
    final bend = Offset(_entryGate.dx, target.dy);
    if (t < 0.5) return Offset.lerp(_entryGate, bend, t / 0.5)!;
    return Offset.lerp(bend, target, (t - 0.5) / 0.5)!;
  }

  bool _zoneActive(String zone) => widget.assignment.slot.startsWith(zone);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _canvasWidth / _canvasHeight,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _canvasWidth,
            height: _canvasHeight,
            child: Stack(
              children: [
                const Positioned(
                  left: 100,
                  top: 0,
                  child: _GateLabel('ENTRY GATE'),
                ),
                const Positioned(
                  left: 105,
                  top: 428,
                  child: _GateLabel('EXIT GATE'),
                ),
                Positioned(
                  left: 14,
                  top: 50,
                  width: 70,
                  height: 360,
                  child: _MallBlock(highlightEntrance: widget.assignment.entrance),
                ),
                Positioned(
                  left: 110,
                  top: 50,
                  width: 216,
                  height: 30,
                  child: _ZoneBox(label: 'A', active: _zoneActive('A')),
                ),
                Positioned(
                  left: 110,
                  top: 90,
                  width: 50,
                  height: 290,
                  child: _ZoneBox(label: 'B', active: _zoneActive('B')),
                ),
                Positioned(
                  left: 170,
                  top: 90,
                  width: 90,
                  height: 290,
                  child: _ZoneBox(label: 'C', active: _zoneActive('C')),
                ),
                Positioned(
                  left: 270,
                  top: 90,
                  width: 56,
                  height: 290,
                  child: _ZoneBox(label: 'D', active: _zoneActive('D')),
                ),
                Positioned(
                  left: 110,
                  top: 390,
                  width: 190,
                  height: 30,
                  child: _ZoneBox(label: 'E', active: _zoneActive('E')),
                ),
                Positioned(
                  left: 304,
                  top: 390,
                  width: 22,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.shield_outlined, size: 14, color: Colors.brown),
                  ),
                ),
                ..._entrancePoints.entries.map((e) {
                  final isActive = e.key == widget.assignment.entrance;
                  return Positioned(
                    left: e.value.dx - 9,
                    top: e.value.dy - 9,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.success : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: isActive ? AppColors.success : Colors.grey.shade400, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        e.key.split(' ').last,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final pos = _dotPosition(_controller.value);
                    return Positioned(left: pos.dx - 10, top: pos.dy - 10, child: child!);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.directions_car_filled_rounded, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GateLabel extends StatelessWidget {
  final String text;

  const _GateLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted));
  }
}

class _MallBlock extends StatelessWidget {
  final String highlightEntrance;

  const _MallBlock({required this.highlightEntrance});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E3C3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD9BE8F)),
      ),
      alignment: Alignment.center,
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          'COMMERCIAL BUILDING',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.brown.shade700, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class _ZoneBox extends StatelessWidget {
  final String label;
  final bool active;

  const _ZoneBox({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.success.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppColors.success : Colors.grey.shade300, width: active ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: Text(
        'Zone $label',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? AppColors.success : Colors.grey.shade500,
        ),
      ),
    );
  }
}
