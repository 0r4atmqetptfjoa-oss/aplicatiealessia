import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final Map<String, int> data; // label -> value
  const SimpleBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = (data.values.isEmpty ? 1 : data.values.reduce((a,b)=>a>b?a:b)).toDouble();
    return LayoutBuilder(
      builder: (context, size) {
        final barWidth = (size.maxWidth - 16) / (data.length == 0 ? 1 : data.length);
        return SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.entries.map((e) {
              final h = maxVal == 0 ? 0 : (e.value / maxVal) * 140;
              return SizedBox(
                width: barWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(height: h, width: barWidth * 0.6, decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 6),
                    Text(e.key, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                    Text('${e.value}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
