import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Entry point
// ─────────────────────────────────────────────
void main() => runApp(const GaugeDemoApp());

class GaugeDemoApp extends StatelessWidget {
  const GaugeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segmented Gauge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GaugeDemoScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  Demo screen
// ─────────────────────────────────────────────
class GaugeDemoScreen extends StatefulWidget {
  const GaugeDemoScreen({super.key});

  @override
  State<GaugeDemoScreen> createState() => _GaugeDemoScreenState();
}

class _GaugeDemoScreenState extends State<GaugeDemoScreen> {
  double _value = 72; // matches the image (~70–75% mark)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark slate-blue background matching the image
      backgroundColor: const Color.fromARGB(255, 76, 227, 6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SegmentedGauge(value: _value, size: 320),

            const SizedBox(height: 24),

            Text(
              _value.toStringAsFixed(0),
              style: const TextStyle(
                color: Color.fromARGB(179, 0, 0, 0),
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 32),

            // Interactive slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Slider(
                value: _value,
                min: 0,
                max: 100,
                activeColor: const Color(0xFF00E5FF),
                inactiveColor: const Color.fromARGB(255, 92, 213, 11),
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SegmentedGauge — public reusable widget
// ─────────────────────────────────────────────
/// Speedometer-style gauge with discrete colored segments,
/// concentric background rings, and a slim glowing needle.
///
/// [value]    – 0..100
/// [size]     – width of the bounding box (height = size * 0.60)
class SegmentedGauge extends StatelessWidget {
  const SegmentedGauge({
    super.key,
    required this.value,
    this.size = 320,
    this.minValue = 0,
    this.maxValue = 100,
  });

  final double value;
  final double size;
  final double minValue;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final fraction = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );

    return SizedBox(
      width: size,
      height: size * 0.60,
      child: CustomPaint(painter: _SegmentedGaugePainter(fraction: fraction)),
    );
  }
}

// ─────────────────────────────────────────────
//  Painter
// ─────────────────────────────────────────────
class _SegmentedGaugePainter extends CustomPainter {
  const _SegmentedGaugePainter({required this.fraction});

  final double fraction;

  // Arc spans 210° — starts bottom-left, ends bottom-right
  static const double _startDeg = 165.0;
  static const double _sweepDeg = 210.0;

  static double _rad(double deg) => deg * math.pi / 180.0;

  // Segment definitions: [startFraction, endFraction, dimColor, brightColor]
  // Matching image: brown → tan/olive → dark olive → gray → green
  static const List<_Segment> _segments = [
    _Segment(
      0.00,
      0.40,
      Color.fromARGB(255, 238, 9, 9),
      Color.fromARGB(255, 186, 58, 58),
    ), // brown
    _Segment(
      0.40,
      0.70,
      Color.fromARGB(255, 8, 14, 207),
      Color.fromARGB(255, 11, 17, 169),
    ), // tan/khaki
    _Segment(
      0.70,
      0.100,
      Color.fromARGB(255, 5, 218, 34),
      Color.fromARGB(255, 34, 255, 0),
    ), // olive
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Center at horizontal middle, ~75% down the canvas
    final center = Offset(size.width / 2, size.height * 0.80);
    final outerRadius = size.width * 0.44;

    _drawConcentricRings(canvas, center, outerRadius);
    _drawSegments(canvas, center, outerRadius);
    _drawNeedle(canvas, center, outerRadius);
  }

  // ── 1. Layered dark concentric rings (depth / 3-D illusion) ───────────────
  void _drawConcentricRings(Canvas canvas, Offset center, double outerR) {
    // Draw 3 rings from outermost inward, each slightly darker
    final ringData = [
      (outerR * 1.05, const Color.fromARGB(255, 235, 237, 243), 28.0),
      (outerR * 0.90, const Color.fromARGB(242, 5, 248, 70), 22.0),
      (outerR * 0.74, const Color.fromARGB(255, 230, 230, 230), 18.0),
    ];

    for (final (r, color, strokeW) in ringData) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        _rad(_startDeg),
        _rad(_sweepDeg),
        false,
        paint,
      );
    }
  }

  // ── 2. Discrete colored segments with gaps between them ───────────────────
  void _drawSegments(Canvas canvas, Offset center, double outerR) {
    const double segRadius = 0.0; // we draw on a single arc radius
    final arcR = outerR * 0.90;
    const double strokeW = 22.0;
    const double gapDeg = 2.8; // gap between segments in degrees

    for (final seg in _segments) {
      // Determine if this segment is "active" (needle has passed it)
      final segMidFraction = (seg.start + seg.end) / 2;
      final isActive = fraction >= segMidFraction;
      // Partially active: the segment the needle is currently crossing
      final isCurrentSeg = fraction >= seg.start && fraction < seg.end;

      final color = isActive ? seg.brightColor : seg.dimColor;

      final startDeg = _startDeg + _sweepDeg * seg.start + gapDeg / 2;
      final sweepDeg = _sweepDeg * (seg.end - seg.start) - gapDeg;

      // Slight glow on active segments
      if (isActive || isCurrentSeg) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW + 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: arcR),
          _rad(startDeg),
          _rad(sweepDeg),
          false,
          glowPaint,
        );
      }

      // Segment body
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: arcR),
        _rad(startDeg),
        _rad(sweepDeg),
        false,
        paint,
      );
    }
  }

  // ── 3. Slim glowing needle with cyan tip ──────────────────────────────────
  void _drawNeedle(Canvas canvas, Offset center, double outerR) {
    final angleDeg = _startDeg + _sweepDeg * fraction;
    final angleRad = _rad(angleDeg);

    final dir = Offset(math.cos(angleRad), math.sin(angleRad));

    final tipDist = outerR * 0.86; // tip reaches near the segments
    final tailDist = outerR * 0.22; // short tail behind pivot

    final tip = center + dir * tipDist;
    final tail = center - dir * tailDist;

    // ── Soft outer glow along full needle ──
    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..color = Colors.white.withOpacity(0.12)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // ── Needle body (white/light gray, thin) ──
    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..color = const Color(0xFFD0D8E8)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // ── Cyan glowing tip (last 18% of needle) ──
    final tipStart = center + dir * (tipDist * 0.82);

    // Glow
    canvas.drawLine(
      tipStart,
      tip,
      Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.6)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Core
    canvas.drawLine(
      tipStart,
      tip,
      Paint()
        ..color = const Color(0xFF00E5FF)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // ── Pivot ring (outer dark) ──
    canvas.drawCircle(
      center,
      outerR * 0.072,
      Paint()
        ..color = const Color(0xFF2A3040)
        ..style = PaintingStyle.fill,
    );

    // ── Pivot ring (inner light) ──
    canvas.drawCircle(
      center,
      outerR * 0.045,
      Paint()
        ..color = const Color(0xFF8A9BB0)
        ..style = PaintingStyle.fill,
    );

    // ── Pivot center dot ──
    canvas.drawCircle(
      center,
      outerR * 0.020,
      Paint()
        ..color = const Color(0xFF1A1E2E)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_SegmentedGaugePainter old) => old.fraction != fraction;
}

// ─────────────────────────────────────────────
//  Data class for a segment
// ─────────────────────────────────────────────
class _Segment {
  const _Segment(this.start, this.end, this.dimColor, this.brightColor);

  /// Fraction positions along the arc (0.0 – 1.0)
  final double start;
  final double end;

  /// Color when segment is inactive (before needle)
  final Color dimColor;

  /// Color when segment is active (needle has passed)
  final Color brightColor;
}
