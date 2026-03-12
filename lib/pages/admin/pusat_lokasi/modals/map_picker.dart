import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  GoogleMapController? _mapController;

  LatLng? _selectedLocation;
  bool _isLoadingLocation = false;

  // Default center: Indonesia
  static const LatLng _defaultCenter = LatLng(-2.5489, 118.0149);

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'GPS Mati',
          'Aktifkan layanan lokasi terlebih dahulu',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Izin Ditolak',
            'Izin lokasi diperlukan untuk fitur ini',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Izin Ditolak Permanen',
          'Buka pengaturan untuk mengaktifkan izin lokasi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final LatLng currentPos = LatLng(position.latitude, position.longitude);

      setState(() => _selectedLocation = currentPos);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPos, zoom: 16.0),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  String _formatCoordinate(LatLng loc) {
    return '${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}';
  }

  void _confirmLocation() {
    if (_selectedLocation == null) {
      Get.snackbar(
        'Belum Ada Titik',
        'Tap pada peta untuk memilih lokasi',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    Get.back(result: _formatCoordinate(_selectedLocation!));
  }

  @override
  Widget build(BuildContext context) {
    final LatLng center = widget.initialLocation ?? _defaultCenter;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _selectedLocation != null ? _confirmLocation : null,
            child: Text(
              'Pilih',
              style: TextStyle(
                color: _selectedLocation != null
                    ? Colors.white
                    : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(target: center, zoom: 13.0),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (LatLng point) {
              setState(() => _selectedLocation = point);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                      draggable: true,
                      onDragEnd: (LatLng newPos) {
                        setState(() => _selectedLocation = newPos);
                      },
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // kita buat tombol sendiri
            zoomControlsEnabled: false,
          ),

          // Info bar atas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedLocation != null
                        ? Icons.check_circle
                        : Icons.touch_app,
                    color: _selectedLocation != null
                        ? Colors.green
                        : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedLocation != null
                          ? _formatCoordinate(_selectedLocation!)
                          : 'Tap pada peta untuk memilih lokasi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _selectedLocation != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_selectedLocation != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedLocation = null),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tombol GPS (kanan bawah)
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'gps',
              onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              elevation: 4,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          // Tombol Gunakan Lokasi Ini (bawah)
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: _selectedLocation != null ? _confirmLocation : null,
              icon: const Icon(Icons.location_on),
              label: const Text(
                'Gunakan Lokasi Ini',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
