// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qalb/shimmer/all_shimmer_loder.dart';
import 'package:qalb/util/dimensions.dart';
import 'package:qalb/util/images.dart';
import 'package:qalb/util/styles.dart';
import 'package:qalb/view/base/location_error_widget.dart';

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({super.key});

  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const QuiblaeShimmerScreen();
          }
          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return const QiblahCompassWidget();

              case LocationPermission.denied:
                return LocationErrorWidget(
                  error:
                      "location_service_permission_denied_for_getting_this_service_please_enable_location"
                          .tr,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error:
                      "location_service_denied_forever_for_getting_this_service_please_enable_location"
                          .tr,
                );

              default:
                return const SizedBox();
            }
          } else {
            return LocationErrorWidget(
              error: "please_enable_location_service".tr,
            );
          }
        },
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }
}

class QiblahCompassWidget extends StatefulWidget {
  const QiblahCompassWidget({super.key});

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  double? _lastCompassAngle;
  double? _lastNeedleAngle;
  bool _isAligned = false;

  double _getShortestAngle(double oldAngle, double newAngle) {
    double diff = newAngle - oldAngle;
    while (diff > pi) { diff -= 2 * pi; }
    while (diff < -pi) { diff += 2 * pi; }
    return oldAngle + diff;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const QuiblaeShimmerScreen();
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return const SizedBox();
        }

        double targetCompassAngle = (qiblahDirection.direction * (pi / 180) * -1);
        double targetNeedleAngle = (qiblahDirection.qiblah * (pi / 180) * -1);

        _lastCompassAngle = _lastCompassAngle == null
            ? targetCompassAngle
            : _getShortestAngle(_lastCompassAngle!, targetCompassAngle);

        _lastNeedleAngle = _lastNeedleAngle == null
            ? targetNeedleAngle
            : _getShortestAngle(_lastNeedleAngle!, targetNeedleAngle);

        double qiblaDiff = qiblahDirection.qiblah;
        while (qiblaDiff > 180) { qiblaDiff -= 360; }
        while (qiblaDiff < -180) { qiblaDiff += 360; }
        
        double absDiff = qiblaDiff.abs();
        bool isNowAligned = absDiff <= 5.0;

        if (isNowAligned && !_isAligned) {
          _isAligned = true;
          HapticFeedback.mediumImpact();
        } else if (!isNowAligned && _isAligned) {
          _isAligned = false;
        }

        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: _lastCompassAngle!, end: _lastCompassAngle!),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      builder: (context, angle, child) {
                        return Transform.rotate(
                          angle: angle,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        Images.Compass,
                        height: 330,
                        fit: BoxFit.fill,
                        color: _isAligned ? Colors.green.withOpacity(0.5) : Theme.of(context).primaryColor,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: _lastNeedleAngle!, end: _lastNeedleAngle!),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      builder: (context, angle, child) {
                        return Transform.rotate(
                          angle: angle,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        Images.Compass_Needle,
                        height: 400,
                        fit: BoxFit.fill,
                        color: _isAligned ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _isAligned ? Colors.green.withOpacity(0.15) : Theme.of(context).hintColor.withOpacity(0.05),
                      _isAligned ? Colors.green.withOpacity(0.25) : Theme.of(context).hintColor.withOpacity(0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      _isAligned ? "Aligned" : "${absDiff.toStringAsFixed(0)}°",
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        color: _isAligned ? Colors.green : Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      _isAligned ? 'You are facing Qibla' : 'Angle to Qibla',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        color: _isAligned ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Move device in a figure-8 motion to calibrate the compass if it behaves erratically.",
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).hintColor.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        );
      },
    );
  }
}
