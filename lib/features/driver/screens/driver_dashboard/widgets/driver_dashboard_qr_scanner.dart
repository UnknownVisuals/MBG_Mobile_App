import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DriverDashboardQrScanner extends StatefulWidget {
  const DriverDashboardQrScanner({super.key, this.onScanned, this.onClose});

  final Future<void> Function(String code)? onScanned;
  final VoidCallback? onClose;

  @override
  State<DriverDashboardQrScanner> createState() =>
      _DriverDashboardQrScannerState();
}

class _DriverDashboardQrScannerState extends State<DriverDashboardQrScanner> {
  late final MobileScannerController _controller;
  String? _latestCode;
  bool _torchEnabled = false;
  bool _isBackCamera = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) async {
                if (_isProcessing) return;

                final code = capture.barcodes.isNotEmpty
                    ? capture.barcodes.first.rawValue
                    : null;

                if (code == null || code.isEmpty) return;

                if (!mounted) return;
                setState(() {
                  _latestCode = code;
                  _isProcessing = true;
                });

                await _controller.stop();

                try {
                  if (widget.onScanned != null) {
                    await widget.onScanned!(code);
                  }
                } catch (_) {
                  if (mounted) {
                    setState(() => _latestCode = null);
                  }
                } finally {
                  if (mounted) {
                    await _controller.start();
                    if (mounted) {
                      setState(() => _isProcessing = false);
                    }
                  }
                }
              },
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _ScannerOverlayPainter(frameSize: 240),
              ),
            ),
            // Top gradient fade
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom gradient fade
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Top app bar style controls
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.md,
                  vertical: MBGSizes.sm,
                ),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Iconsax.arrow_left,
                      onTap:
                          widget.onClose ??
                          () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    _CircleButton(
                      icon: _torchEnabled ? Iconsax.flash_slash : Iconsax.flash,
                      onTap: () async {
                        await _controller.toggleTorch();
                        setState(() => _torchEnabled = !_torchEnabled);
                      },
                    ),
                    const SizedBox(width: MBGSizes.sm),
                    _CircleButton(
                      icon: _isBackCamera
                          ? Iconsax.camera
                          : Iconsax.camera_slash,
                      onTap: () async {
                        await _controller.switchCamera();
                        setState(() => _isBackCamera = !_isBackCamera);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Animated scanning frame
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 240,
                height: 240,
                child: CustomPaint(
                  painter: _ScannerFramePainter(color: MBGColors.white),
                ),
              ),
            ),
            if (_latestCode != null)
              Align(
                alignment: const Alignment(0, 0.55),
                child: Padding(
                  padding: const EdgeInsets.only(top: MBGSizes.lg),
                  child: _ScanStatusBadge(latestCode: _latestCode!),
                ),
              ),
            if (_isProcessing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: MBGColors.white),
                  ),
                ),
              ),
            // Bottom instructions
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Iconsax.scan_barcode,
                    color: MBGColors.white,
                    size: MBGSizes.iconLg,
                  ),
                  const SizedBox(height: MBGSizes.sm),
                  const Text(
                    'Scan delivery QR code',
                    style: TextStyle(
                      color: MBGColors.white,
                      fontSize: MBGSizes.fontSizeMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: MBGSizes.sm),
                  Container(
                    width: 140,
                    height: 6,
                    decoration: BoxDecoration(
                      color: MBGColors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
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
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(MBGSizes.sm),
          decoration: BoxDecoration(
            color: MBGColors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(icon, color: MBGColors.white, size: MBGSizes.iconMd),
        ),
      ),
    );
  }
}

class _ScannerFramePainter extends CustomPainter {
  _ScannerFramePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 32.0;

    // Top left
    canvas.drawLine(Offset(0, cornerLength), Offset.zero, paint);
    canvas.drawLine(Offset.zero, Offset(cornerLength, 0), paint);

    // Top right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Bottom right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter({required this.frameSize});

  final double frameSize;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final fullPath = Path()..addRect(Offset.zero & size);
    final frameRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameSize,
      height: frameSize,
    );
    final cutoutPath = Path()..addRect(frameRect);

    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      cutoutPath,
    );
    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanStatusBadge extends StatelessWidget {
  const _ScanStatusBadge({required this.latestCode});

  final String latestCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.md,
        vertical: MBGSizes.sm,
      ),
      decoration: BoxDecoration(
        color: MBGColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
        border: Border.all(color: MBGColors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        latestCode,
        style: TextStyle(
          color: MBGColors.textWhite,
          fontSize: MBGSizes.fontSizeSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
