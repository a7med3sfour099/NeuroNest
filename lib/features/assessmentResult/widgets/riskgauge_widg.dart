import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskGauge extends StatelessWidget {
  final double value;

  const RiskGauge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332,
      height: 189,
      decoration: const BoxDecoration(color: Color(0xFFDBEFF8)),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 180,
            endAngle: 0,
            showLabels: false,
            showTicks: false,
            showAxisLine: true,
            radiusFactor: 1.2,

            axisLineStyle: AxisLineStyle(
              thickness: 0.07,
              cornerStyle: CornerStyle.bothCurve,
              color: const Color(0xFF333333).withOpacity(0.4),
              thicknessUnit: GaugeSizeUnit.factor,
            ),

            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 40,
                color: const Color(0xFF4CAF50).withOpacity(0.7),
                startWidth: 0.25,
                endWidth: 0.25,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              GaugeRange(
                startValue: 40,
                endValue: 60,
                color: const Color(0xFFFF9800).withOpacity(0.7),
                startWidth: 0.25,
                endWidth: 0.25,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              GaugeRange(
                startValue: 60,
                endValue: 100,
                color: const Color(0xFFF44336).withOpacity(0.7),
                startWidth: 0.25,
                endWidth: 0.25,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ],

            pointers: <GaugePointer>[
              NeedlePointer(
                value: value.clamp(0, 100),
                needleColor: const Color(0xFFFF9800),
                needleStartWidth: 1,
                needleEndWidth: 8,
                needleLength: 0.75,
                lengthUnit: GaugeSizeUnit.factor,
                knobStyle: KnobStyle(
                  knobRadius: 0.08,
                  color: Color(0xFF4798a9),
                  borderColor: const Color(0xFF4798a9),
                  borderWidth: 0.08,
                ),
                enableAnimation: true,
                animationDuration: 1500,
                animationType: AnimationType.easeOutBack,
              ),
            ],

            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.35,
                widget: Text(
                  _getRiskLevel(value),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.70,
                widget: Text(
                  'Risk Level',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRiskLevel(double val) {
    if (val <= 40) return 'Low';
    if (val <= 60) return 'Moderate';
    return 'High';
  }
}
