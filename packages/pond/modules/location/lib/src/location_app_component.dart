import 'dart:async';

import 'package:drop/drop.dart';
import 'package:environment/environment.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_core/location_core.dart';
import 'package:pond/pond.dart';
import 'package:runtime_type/type.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class LocationAppComponent with IsAppPondComponent {
  final bool shouldTrackImmediately;
  final Function(Position position, bool isNewPosition)? onPositionUpdated;

  final LocationAccuracy locationAccuracy;
  final int locationUpdateDistance;

  late final BehaviorSubject<FutureValue<Position?>> _positionX = BehaviorSubject.seeded(FutureValue.empty());

  ValueStream<FutureValue<Position?>> get positionX => _positionX;

  bool _isLoadingLocation;
  bool _shouldTrack;
  StreamSubscription? _locationSubscription;

  LocationAppComponent({
    required this.shouldTrackImmediately,
    this.onPositionUpdated,
    this.locationAccuracy = LocationAccuracy.high,
    this.locationUpdateDistance = 3,
  })  : _shouldTrack = false,
        _isLoadingLocation = false;

  @override
  Future onRegister(AppPondContext context) async {
    context.dropCoreComponent.register<LocationValueObject>(
      LocationValueObject.new,
      name: 'Location',
    );
  }

  @override
  Future onLoad(AppPondContext context) async {
    if (shouldTrackImmediately) {
      await enableTracking(context);
    }

    if (context.environmentCoreComponent.platform != Platform.web) {
      Geolocator.getServiceStatusStream().listen((status) async {
        if (!_shouldTrack) {
          return;
        }

        if (status == ServiceStatus.enabled && _locationSubscription == null) {
          await enableTracking(context);
        } else if (status == ServiceStatus.disabled && _locationSubscription != null) {
          _stopTracking();
        }
      });
    }
  }

  Future<void> enableTracking(AppPondContext context) async {
    final shouldTrackButInvalid = _shouldTrack && _locationSubscription != null;
    if (shouldTrackButInvalid || _isLoadingLocation) {
      return;
    }

    _isLoadingLocation = true;
    _shouldTrack = true;

    _locationSubscription = await _loadPositionX(context);

    _isLoadingLocation = false;
  }

  Future<void> disableTracking() async {
    if (!_shouldTrack && _locationSubscription == null) {
      return;
    }

    _shouldTrack = false;
    _stopTracking();
  }

  Future<void> requestLocationAccess() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
  }

  void _stopTracking() {
    _locationSubscription!.cancel();
    _locationSubscription = null;
  }

  Future<StreamSubscription?> _loadPositionX(AppPondContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _positionX.value = FutureValue.loaded(null);
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _positionX.value = FutureValue.loaded(null);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _positionX.value = FutureValue.loaded(null);
      return null;
    }

    final lastPosition =
        context.environmentCoreComponent.platform == Platform.web ? null : await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      onPositionUpdated?.call(lastPosition, false);
      _positionX.value = FutureValue.loaded(lastPosition);
    }

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: locationAccuracy,
        distanceFilter: locationUpdateDistance,
      ),
    ).listen(
      (position) {
        _positionX.value = FutureValue.loaded(position);
        onPositionUpdated?.call(position, true);
      },
      onError: (error, stackTrace) {
        _locationSubscription!.cancel();
        _locationSubscription = null;
      },
    );
  }
}
