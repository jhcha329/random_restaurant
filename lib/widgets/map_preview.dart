import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPreview extends StatelessWidget {
  final NLatLng position;
  final String label;

  const MapPreview({
    super.key,
    required this.position,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 160,
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: position,
              zoom: 14,
            ),
          ),
          onMapReady: (controller) {
            final marker = NMarker(
              id: label,
              position: position,
              caption: NOverlayCaption(text: label),
            );
            controller.addOverlay(marker);
          },
        ),
      ),
    );
  }
}