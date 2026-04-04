import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverTrayReturnTracking extends StatefulWidget {
  const DriverTrayReturnTracking({super.key, required this.trayReturn});

  final DriverTrayReturnModel trayReturn;

  @override
  State<DriverTrayReturnTracking> createState() =>
      _DriverTrayReturnTrackingState();
}

class _DriverTrayReturnTrackingState extends State<DriverTrayReturnTracking> {
  static const double _defaultZoom = 16;
  static const Duration _locationRefreshInterval = Duration(seconds: 1);
  final MapController _mapController = MapController();
  final DriverService _driverService = Get.find<DriverService>();
  Timer? _locationUpdateTimer;
  LatLng? _driverLocation;
  List<LatLng> _routePoints = const [];
  String? _errorMessage;
  bool _isLoading = true;
  bool _isFetchingRoute = false;
  Timer? _routeUpdateTimer;
  double? _currentBearing;
  bool _isUpdatingLocation = false;
  bool _isSyncingLocation = false;
  bool _lastSyncSuccessful = true;
  bool _isFollowMode = true;

  late final LatLng? _destinationLocation = _resolveDestinationLocation();

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _routeUpdateTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  LatLng? _resolveDestinationLocation() {
    // If returning (SEDANG_RETURN), destination is Dapur
    if (widget.trayReturn.normalizedStatus ==
        DriverTrayReturnStatus.sedangReturn) {
      final dapur = widget.trayReturn.driver?.driverOf;
      if (dapur != null && dapur.latitude != null && dapur.longitude != null) {
        return LatLng(dapur.latitude!, dapur.longitude!);
      }
    }

    // Default to Sekolah logic (MENUNGGU_PICKUP or fallback)
    final latitude = widget.trayReturn.sekolah.latitude;
    final longitude = widget.trayReturn.sekolah.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    return LatLng(latitude, longitude);
  }

  Future<void> _initLocationTracking() async {
    final hasDestination = _destinationLocation != null;
    if (!hasDestination) {
      setState(() {
        _errorMessage = 'Lokasi tujuan tidak tersedia.';
        _isLoading = false;
      });
      return;
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Aktifkan layanan lokasi pada perangkat.';
          _isLoading = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _errorMessage =
              'Izin lokasi ditolak. Buka pengaturan untuk mengaktifkan.';
          _isLoading = false;
        });
        return;
      }

      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      if (!mounted) return;

      final initialLatLng = LatLng(
        initialPosition.latitude,
        initialPosition.longitude,
      );
      final initialBearing = _deriveBearing(
        previous: null,
        current: initialLatLng,
      );

      setState(() {
        _driverLocation = initialLatLng;
        _currentBearing = initialBearing;
        _isLoading = false;
      });

      _moveCamera(
        _driverLocation!,
        rotation: _currentBearing,
        zoom: _defaultZoom,
      );
      unawaited(_sendLocationToServer(_driverLocation!));
      unawaited(_updateRoute());

      // Start periodic route updates (every 10 seconds)
      _routeUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        unawaited(_updateRoute());
      });
      _startLocationPolling();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat lokasi: $error';
        _isLoading = false;
      });
    }
  }

  void _startLocationPolling() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(
      _locationRefreshInterval,
      (_) => _refreshDriverLocation(),
    );
  }

  Future<void> _refreshDriverLocation() async {
    if (!mounted || _isUpdatingLocation) {
      return;
    }

    _isUpdatingLocation = true;
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      if (!mounted) return;

      final current = LatLng(position.latitude, position.longitude);
      final previous = _driverLocation;
      final derivedBearing = _deriveBearing(
        previous: previous,
        current: current,
      );

      setState(() {
        _driverLocation = current;
        if (derivedBearing != null) {
          _currentBearing = derivedBearing;
        }
      });

      if (_isFollowMode) {
        _moveCamera(current, rotation: _currentBearing);
      }
      unawaited(_sendLocationToServer(current));
    } catch (_) {
      // Ignore transient location errors during polling cycle.
    } finally {
      _isUpdatingLocation = false;
    }
  }

  Future<void> _sendLocationToServer(LatLng location) async {
    if (_isSyncingLocation) {
      return;
    }

    _isSyncingLocation = true;
    try {
      await _driverService.updateDriverLocation(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      if (!mounted) return;
      setState(() => _lastSyncSuccessful = true);
    } catch (error) {
      debugPrint('Failed to sync driver location: $error');
      if (!mounted) return;
      setState(() => _lastSyncSuccessful = false);
    } finally {
      _isSyncingLocation = false;
    }
  }

  void _toggleFollowMode() {
    final shouldEnable = !_isFollowMode;
    setState(() {
      _isFollowMode = shouldEnable;
    });

    if (shouldEnable && _driverLocation != null) {
      _moveCamera(
        _driverLocation!,
        rotation: _currentBearing,
        zoom: _defaultZoom,
      );
    }
  }

  Future<void> _updateRoute() async {
    final start = _driverLocation;
    final destination = _destinationLocation;
    if (start == null || destination == null || _isFetchingRoute) {
      return;
    }

    _isFetchingRoute = true;
    try {
      final points = await _fetchRoute(start, destination);
      if (!mounted) return;
      final currentLocation = _driverLocation;
      final updatedBearing = currentLocation == null
          ? null
          : _bearingFromRoute(currentLocation, route: points);

      setState(() {
        _routePoints = points;
        if (updatedBearing != null) {
          _currentBearing = updatedBearing;
        }
      });

      if (_isFollowMode && updatedBearing != null && currentLocation != null) {
        _moveCamera(currentLocation, rotation: updatedBearing);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _routePoints = const [];
        _errorMessage ??= 'Tidak dapat memuat rute: $error';
      });
    } finally {
      _isFetchingRoute = false;
    }
  }

  Future<List<LatLng>> _fetchRoute(LatLng start, LatLng destination) async {
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Kode status ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final routes = payload['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      throw Exception('Rute tidak ditemukan');
    }

    final geometry = routes.first['geometry'] as Map<String, dynamic>?;
    final coordinates = geometry?['coordinates'] as List<dynamic>?;
    if (coordinates == null || coordinates.isEmpty) {
      throw Exception('Rute tidak memiliki koordinat');
    }

    return coordinates
        .map(
          (coord) => LatLng(
            (coord[1] as num).toDouble(),
            (coord[0] as num).toDouble(),
          ),
        )
        .toList(growable: false);
  }

  void _moveCamera(LatLng target, {double? rotation, double? zoom}) {
    try {
      final camera = _mapController.camera;
      final targetZoom = zoom ?? camera.zoom;
      _mapController.move(target, targetZoom);
      final desiredRotation = rotation ?? _currentBearing;
      if (desiredRotation != null) {
        _applyMapRotation(desiredRotation);
      }
    } catch (_) {
      // Map controller may not be ready yet; ignore in that case.
    }
  }

  void _applyMapRotation(double bearing) {
    final adjusted = _normalizeBearing(bearing + 180);
    _mapController.rotate(adjusted);
  }

  double? _deriveBearing({LatLng? previous, required LatLng current}) {
    final routeBearing = _bearingFromRoute(current);
    if (routeBearing != null) {
      return routeBearing;
    }

    if (previous != null && !_pointsEqual(previous, current)) {
      return _normalizeBearing(_calculateBearing(previous, current));
    }

    final dest = _destinationLocation;
    if (dest != null && !_pointsEqual(current, dest)) {
      return _normalizeBearing(_calculateBearing(current, dest));
    }

    return _currentBearing;
  }

  double? _bearingFromRoute(LatLng current, {List<LatLng>? route}) {
    final points = route ?? _routePoints;
    if (points.length < 2) {
      return null;
    }

    double? shortestDistance;
    LatLng? nextPoint;

    for (var i = 0; i < points.length - 1; i++) {
      final candidate = points[i];
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        candidate.latitude,
        candidate.longitude,
      );

      if (shortestDistance == null || distance < shortestDistance) {
        shortestDistance = distance;
        nextPoint = points[i + 1];
      }
    }

    final destination = nextPoint ?? points.last;
    if (_pointsEqual(destination, current)) {
      return null;
    }

    return _normalizeBearing(_calculateBearing(current, destination));
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = _degToRad(from.latitude);
    final lat2 = _degToRad(to.latitude);
    final deltaLon = _degToRad(to.longitude - from.longitude);

    final y = math.sin(deltaLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    final bearing = math.atan2(y, x);
    return (_radToDeg(bearing) + 360) % 360;
  }

  double _normalizeBearing(double bearing) => (bearing + 360) % 360;

  double _degToRad(double degrees) => degrees * math.pi / 180;

  double _radToDeg(double radians) => radians * 180 / math.pi;

  bool _pointsEqual(LatLng a, LatLng b) {
    const epsilon = 1e-6;
    return (a.latitude - b.latitude).abs() < epsilon &&
        (a.longitude - b.longitude).abs() < epsilon;
  }

  double? _calculateDistanceKm() {
    if (_driverLocation == null || _destinationLocation == null) {
      return null;
    }
    final LatLng? driver = _driverLocation;
    final LatLng dest = _destinationLocation;
    if (driver == null) {
      return null;
    }
    final meters = Geolocator.distanceBetween(
      driver.latitude,
      driver.longitude,
      dest.latitude,
      dest.longitude,
    );
    return meters / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final isReturn =
        widget.trayReturn.normalizedStatus ==
        DriverTrayReturnStatus.sedangReturn;
    final destinationName = isReturn
        ? (widget.trayReturn.driver?.driverOf?.nama ?? 'Dapur')
        : widget.trayReturn.sekolah.nama;
    final destinationAddress = isReturn
        ? widget.trayReturn.driver?.driverOf?.alamat
        : widget.trayReturn.sekolah.alamat;

    final distanceKm = _calculateDistanceKm();
    final driverLocation = _driverLocation;
    final destinationLocation = _destinationLocation;
    final isDestinationDapur = isReturn;

    // Build widget tree without waiting for async operations
    return Scaffold(
      appBar: MBGAppBar(
        showBackArrow: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _driverLocation == null
                ? const Text('Memuat lokasi...')
                : Text(
                    '${_driverLocation!.latitude.toStringAsFixed(6)}, ${_driverLocation!.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 14),
                  ),
            const SizedBox(height: 2),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _isSyncingLocation
                  ? Row(
                      key: const ValueKey('syncing'),
                      children: const [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Mengirim lokasi...',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  : Row(
                      key: ValueKey(_lastSyncSuccessful),
                      children: [
                        Icon(
                          _lastSyncSuccessful
                              ? Icons.check_circle
                              : Icons.error_rounded,
                          size: 14,
                          color: _lastSyncSuccessful
                              ? Colors.green
                              : MBGColors.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _lastSyncSuccessful
                              ? 'Terkirim ke server'
                              : 'Gagal kirim lokasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: _lastSyncSuccessful
                                ? Colors.green
                                : MBGColors.error,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      body: RepaintBoundary(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(MBGSizes.lg),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: MBGColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              RepaintBoundary(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _driverLocation ?? _destinationLocation!,
                    initialZoom: _defaultZoom,
                    interactionOptions: const InteractionOptions(
                      flags:
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.drag |
                          InteractiveFlag.doubleTapZoom |
                          InteractiveFlag.pinchMove |
                          InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                      userAgentPackageName: 'com.mbg.mobile.app',
                      tileProvider: NetworkTileProvider(),
                      keepBuffer: 4,
                    ),
                    if (_routePoints.length >= 2)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 8,
                            color: const Color(
                              0xFF1A73E8,
                            ).withValues(alpha: 0.4),
                          ),
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5,
                            color: const Color(0xFF4285F4),
                          ),
                        ],
                      )
                    else if (driverLocation != null &&
                        destinationLocation != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [driverLocation, destinationLocation],
                            strokeWidth: 7,
                            color: const Color(
                              0xFF1A73E8,
                            ).withValues(alpha: 0.4),
                          ),
                          Polyline(
                            points: [driverLocation, destinationLocation],
                            strokeWidth: 4,
                            color: const Color(0xFF4285F4),
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        if (destinationLocation != null)
                          Marker(
                            point: destinationLocation,
                            rotate: true,
                            width: 48,
                            height: 48,
                            child: RepaintBoundary(
                              child: _GoogleMapMarker(
                                icon: isDestinationDapur
                                    ? Icons.restaurant
                                    : Icons.location_on,
                                color: const Color(0xFFEA4335),
                                isDestination: true,
                              ),
                            ),
                          ),
                        if (driverLocation != null)
                          Marker(
                            point: driverLocation,
                            rotate: true,
                            width: 48,
                            height: 48,
                            child: RepaintBoundary(
                              child: _GoogleMapMarker(
                                icon: Icons.navigation,
                                color: const Color(0xFF4285F4),
                                isDestination: false,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            Positioned(
              left: MBGSizes.sm,
              bottom: MBGSizes.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  '© Google',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (!_isLoading && _errorMessage == null)
              Positioned(
                left: MBGSizes.md,
                right: MBGSizes.md,
                bottom: MBGSizes.lg,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildFollowFab(),
                    ),
                    const SizedBox(height: MBGSizes.md),
                    Card(
                      elevation: 8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(MBGSizes.md),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        (isDestinationDapur
                                                ? MBGColors.primary
                                                : const Color(0xFFEA4335))
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color:
                                          (isDestinationDapur
                                                  ? MBGColors.primary
                                                  : const Color(0xFFEA4335))
                                              .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    isDestinationDapur
                                        ? 'Ke Dapur'
                                        : 'Ke Sekolah',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDestinationDapur
                                          ? MBGColors.primary
                                          : const Color(0xFFEA4335),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              destinationName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF202124),
                                  ),
                            ),
                            if (destinationAddress != null &&
                                destinationAddress.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  destinationAddress,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: const Color(0xFF5F6368),
                                      ),
                                ),
                              ),
                            if (distanceKm != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F0FE),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${distanceKm.toStringAsFixed(distanceKm >= 1 ? 1 : 2)} km',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF1A73E8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: MBGSizes.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: driverLocation == null
                                        ? null
                                        : () => _moveCamera(
                                            driverLocation,
                                            rotation: _currentBearing,
                                            zoom: _defaultZoom,
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4285F4),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.my_location,
                                      size: 18,
                                    ),
                                    label: const Text('Posisiku'),
                                  ),
                                ),
                                const SizedBox(width: MBGSizes.sm),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: destinationLocation == null
                                        ? null
                                        : () => _moveCamera(
                                            destinationLocation,
                                            rotation: _currentBearing,
                                            zoom: _defaultZoom,
                                          ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF4285F4),
                                      side: const BorderSide(
                                        color: Color(0xFFDADCE0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: Icon(
                                      isDestinationDapur
                                          ? Icons.restaurant
                                          : Icons.school,
                                      size: 18,
                                    ),
                                    label: Text(
                                      isDestinationDapur ? 'Dapur' : 'Sekolah',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowFab() {
    final bool followEnabled = _isFollowMode;
    final Color backgroundColor = followEnabled
        ? MBGColors.primary
        : Colors.white;
    final Color foregroundColor = followEnabled
        ? Colors.white
        : MBGColors.primary;
    final BorderSide borderSide = followEnabled
        ? BorderSide.none
        : BorderSide(color: MBGColors.primary.withValues(alpha: 0.4));

    return FloatingActionButton.extended(
      onPressed: _toggleFollowMode,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: Icon(followEnabled ? Icons.gps_off : Icons.navigation),
      label: Text(followEnabled ? 'Bebaskan Peta' : 'Ikuti Lokasi'),
      tooltip: followEnabled
          ? 'Nonaktifkan mode mengikuti'
          : 'Ikuti posisi saya',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: borderSide,
      ),
    );
  }
}

class _GoogleMapMarker extends StatelessWidget {
  const _GoogleMapMarker({
    required this.icon,
    required this.color,
    required this.isDestination,
  });

  final IconData icon;
  final Color color;
  final bool isDestination;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
