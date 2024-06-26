import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:m7_livelyness_detection/index.dart';
import 'package:m7_livelyness_detection/src/utils/circle_border_painter.dart';
import 'package:m7_livelyness_detection/src/utils/circle_clipper.dart';

class M7LivelynessDetectionPageV2 extends StatelessWidget {
  final M7DetectionConfig config;

  const M7LivelynessDetectionPageV2({
    required this.config,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: M7LivelynessDetectionScreenV2(
          config: config,
        ),
      ),
    );
  }
}

class M7LivelynessDetectionScreenV2 extends StatefulWidget {
  final M7DetectionConfig config;

  const M7LivelynessDetectionScreenV2({
    required this.config,
    super.key,
  });

  @override
  State<M7LivelynessDetectionScreenV2> createState() =>
      _M7LivelynessDetectionScreenAndroidState();
}

class _M7LivelynessDetectionScreenAndroidState
    extends State<M7LivelynessDetectionScreenV2> {
  //* MARK: - Private Variables
  //? =========================================================
  final _faceDetectionController = BehaviorSubject<FaceDetectionModel>();

  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true,
    performanceMode: FaceDetectorMode.accurate,
    minFaceSize: 0.05,
  );
  late final faceDetector = FaceDetector(options: options);
  bool _didCloseEyes = false;
  bool _isProcessingStep = false;

  late final List<M7LivelynessStepItem> _steps;
  final GlobalKey<M7LivelynessDetectionStepOverlayState> _stepsKey =
      GlobalKey<M7LivelynessDetectionStepOverlayState>();

  CameraState? _cameraState;
  bool _isProcessing = false;
  late bool _isInfoStepCompleted;
  Timer? _timerToDetectFace;
  bool _isCaptureButtonVisible = false;
  bool _isCompleted = false;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _preInitCallBack();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _postFrameCallBack(),
    );
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _faceDetectionController.close();
    _timerToDetectFace?.cancel();
    _timerToDetectFace = null;
    super.dispose();
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _preInitCallBack() {
    _steps = widget.config.steps;
    _isInfoStepCompleted = !widget.config.startWithInfoScreen;
    _resetSteps();
  }

  void _postFrameCallBack() {
    if (_isInfoStepCompleted) {
      _startTimer();
    }
  }

  Future<void> _processCameraImage(AnalysisImage img) async {
    if (_isProcessing) {
      return;
    }
    if (mounted) {
      setState(
        () => _isProcessing = true,
      );
    }
    final inputImage = img.toInputImage();

    try {
      final List<Face> detectedFaces =
          await faceDetector.processImage(inputImage);
      _faceDetectionController.add(
        FaceDetectionModel(
            faces: detectedFaces,
            absoluteImageSize: inputImage.metadata!.size,
            rotation: 0,
            imageRotation: img.inputImageRotation,
            croppedSize: img.croppedSize,
            img: img),
      );
      await _processImage(inputImage, detectedFaces);
      if (mounted) {
        setState(
          () => _isProcessing = false,
        );
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _isProcessing = false,
        );
      }
      debugPrint("...sending image resulted error $error");
    }
  }

  Future<void> _processImage(InputImage img, List<Face> faces) async {
    try {
      if (faces.isEmpty) {
        //_resetSteps();
        return;
      }
      final Face firstFace = faces.first;
      final landmarks = firstFace.landmarks;
      // Get landmark positions for relevant facial features
      final Point<int>? leftEye = landmarks[FaceLandmarkType.leftEye]?.position;
      final Point<int>? rightEye =
          landmarks[FaceLandmarkType.rightEye]?.position;
      final Point<int>? leftCheek =
          landmarks[FaceLandmarkType.leftCheek]?.position;
      final Point<int>? rightCheek =
          landmarks[FaceLandmarkType.rightCheek]?.position;
      final Point<int>? leftEar = landmarks[FaceLandmarkType.leftEar]?.position;
      final Point<int>? rightEar =
          landmarks[FaceLandmarkType.rightEar]?.position;
      final Point<int>? leftMouth =
          landmarks[FaceLandmarkType.leftMouth]?.position;
      final Point<int>? rightMouth =
          landmarks[FaceLandmarkType.rightMouth]?.position;

      // Calculate symmetry values based on corresponding landmark positions
      final Map<String, double> symmetry = {};
      final eyeSymmetry = calculateSymmetry(
        leftEye,
        rightEye,
      );
      symmetry['eyeSymmetry'] = eyeSymmetry;

      final cheekSymmetry = calculateSymmetry(
        leftCheek,
        rightCheek,
      );
      symmetry['cheekSymmetry'] = cheekSymmetry;

      final earSymmetry = calculateSymmetry(
        leftEar,
        rightEar,
      );
      symmetry['earSymmetry'] = earSymmetry;

      final mouthSymmetry = calculateSymmetry(
        leftMouth,
        rightMouth,
      );
      symmetry['mouthSymmetry'] = mouthSymmetry;
      double total = 0.0;
      symmetry.forEach((key, value) {
        total += value;
      });
      final double average = total / symmetry.length;
      //print("Face Symmetry: $average");
      /*if (_isProcessingStep &&
          _steps[_stepsKey.currentState?.currentIndex ?? 0].step ==
              M7LivelynessStep.blink) {
        if (_didCloseEyes) {
          if ((faces.first.leftEyeOpenProbability ?? 1.0) < 0.75 &&
              (faces.first.rightEyeOpenProbability ?? 1.0) < 0.75) {
            await _completeStep(
              step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
            );
          }
        }
      }*/
      _detect(
        face: firstFace,
        step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
      );
    } catch (e) {
      _startProcessing();
    }
  }

  Future<void> _completeStep({
    required M7LivelynessStep step,
  }) async {
    final int indexToUpdate = _steps.indexWhere(
      (p0) => p0.step == step,
    );

    _steps[indexToUpdate] = _steps[indexToUpdate].copyWith(
      isCompleted: true,
    );
    if (mounted) {
      setState(() {});
    }
    //_steps.forEach((element) {
    //print("PASO -> ${element.title}: ${element.isCompleted}");
    //});
    //print('PASO --------');
    await _stepsKey.currentState?.nextPage();
    _stopProcessing();
  }

  void _detect({
    required Face face,
    required M7LivelynessStep step,
  }) async {
    switch (step) {
      case M7LivelynessStep.blink:
        const double blinkThreshold = 0.25;
        if ((face.leftEyeOpenProbability ?? 1.0) < (blinkThreshold) &&
            (face.rightEyeOpenProbability ?? 1.0) < (blinkThreshold)) {
          if (!_isProcessingStep) {
            _startProcessing();
            //print('ENTRE EN PASO BLINK --------');
            await _completeStep(step: step);
          }
          /*if (mounted) {
            setState(
              () => _didCloseEyes = true,
            );
          }*/
        }
        break;
      case M7LivelynessStep.turnLeft:
        if (Platform.isIOS) {
          if ((face.headEulerAngleY ?? 0) < -45) {
            if (!_isProcessingStep) {
              _startProcessing();
              await _completeStep(step: step);
            }
          }
        } else {
          const double headTurnThreshold = 45.0;
          if ((face.headEulerAngleY ?? 0) > (headTurnThreshold)) {
            if (!_isProcessingStep) {
              _startProcessing();
              //print('ENTRE EN PASO GIRO IzQUIERDa --------');
              await _completeStep(step: step);
            }
          }
        }
        break;
      case M7LivelynessStep.turnRight:
        if (Platform.isIOS) {
          if ((face.headEulerAngleY ?? 0) > 45) {
            if (!_isProcessingStep) {
              _startProcessing();
              await _completeStep(step: step);
            }
          }
        } else {
          const double headTurnThreshold = -45.0;
          if ((face.headEulerAngleY ?? 0) < (headTurnThreshold)) {
            if (!_isProcessingStep) {
              _startProcessing();
              //print('ENTRE EN PASO GIRO DERECHA --------');
              await _completeStep(step: step);
            }
          }
        }
        break;
      case M7LivelynessStep.smile:
        const double smileThreshold = 0.75;
        if ((face.smilingProbability ?? 0) > (smileThreshold)) {
          if (!_isProcessingStep) {
            _startProcessing();
            print('ENTRE EN PASO SONRISA --------');
            await _completeStep(step: step);
          }
        }
        break;
    }
  }

  void _startProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = true,
    );
  }

  void _stopProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = false,
    );
  }

  void _startTimer() {
    _timerToDetectFace = Timer(
      Duration(seconds: widget.config.maxSecToDetect),
      () {
        _timerToDetectFace?.cancel();
        _timerToDetectFace = null;
        if (widget.config.allowAfterMaxSec) {
          _isCaptureButtonVisible = true;
          if (mounted) {
            setState(() {});
          }
          return;
        }
        _onDetectionCompleted(
          imgToReturn: null,
        );
      },
    );
  }

  Future<void> _takePicture({
    required bool didCaptureAutomatically,
  }) async {
    if (_cameraState == null) {
      _onDetectionCompleted();
      return;
    }
    _cameraState?.when(
      onPhotoMode: (p0) => Future.delayed(
        const Duration(milliseconds: 500),
        () => p0.takePhoto().then(
          (value) {
            _onDetectionCompleted(
              imgToReturn: value.when(single: (single) => single.file!.path),
              didCaptureAutomatically: didCaptureAutomatically,
            );
          },
        ),
      ),
    );
  }

  void _onDetectionCompleted({
    String? imgToReturn,
    bool? didCaptureAutomatically,
  }) {
    if (_isCompleted) {
      return;
    }
    setState(
      () => _isCompleted = true,
    );
    final String imgPath = imgToReturn ?? "";
    if (imgPath.isEmpty || didCaptureAutomatically == null) {
      Navigator.of(context).pop(null);
      return;
    }
    Navigator.of(context).pop(
      M7CapturedImage(
        imgPath: imgPath,
        didCaptureAutomatically: didCaptureAutomatically,
      ),
    );
  }

  void _resetSteps() async {
    //print ("PASO -> SE RESETEO");
    for (var p0 in _steps) {
      final int index = _steps.indexWhere(
        (p1) => p1.step == p0.step,
      );
      _steps[index] = _steps[index].copyWith(
        isCompleted: false,
      );
    }
    _didCloseEyes = false;
    if (_stepsKey.currentState?.currentIndex != 0) {
      _stepsKey.currentState?.reset();
    }
    if (mounted) {
      setState(() {});
    }
  }

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        _isInfoStepCompleted
            ? IgnorePointer(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 650,
                      child: CameraAwesomeBuilder.custom(
                        previewFit: CameraPreviewFit.contain,
                        sensorConfig: SensorConfig.single(
                          flashMode: FlashMode.auto,
                          aspectRatio: CameraAspectRatios.ratio_4_3,
                          sensor: Sensor.position(SensorPosition.front),
                        ),
                        onImageForAnalysis: (img) => _processCameraImage(img),
                        imageAnalysisConfig: AnalysisConfig(
                          autoStart: true,
                          androidOptions: const AndroidAnalysisOptions.nv21(
                            width: 250,
                          ),
                          maxFramesPerSecond: 30,
                        ),
                        builder: (state, preview) {
                          _cameraState = state;
                          return SizedBox();
                          return M7PreviewDecoratorWidget(
                            cameraState: state,
                            faceDetectionStream: _faceDetectionController,
                            preview: preview,
                          );
                        },
                        saveConfig: SaveConfig.photo(
                          pathBuilder: (sensors) async {
                            final String fileName = "${M7Utils.generate()}.jpg";
                            final String path =
                                await getTemporaryDirectory().then(
                              (value) => value.path,
                            );
                            return SingleCaptureRequest(
                              "$path/$fileName",
                              Sensor.position(SensorPosition.front),
                            );
                          },
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: const CircleClipper(radius: 150),
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        color: Colors.white,
                      ),
                    ),
                    CustomPaint(
                      painter: CircleBorderPainter(),
                      child: const SizedBox(
                        height: 300,
                        width: 300,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget.config.instructions != null) ...[
                                AutoSizeText(
                                  widget.config.instructions?.trim() ?? '',
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  maxFontSize: 18,
                                  minFontSize: 15,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 22),
                              ],
                              if (widget.config.attemps != null) ...[
                                AutoSizeText(
                                  widget.config.attemps?.trim() ?? '',
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  maxFontSize: 18,
                                  minFontSize: 15,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 22),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : M7LivelynessInfoWidget(
                config: widget.config,
                onStartTap: () {
                  if (!mounted) {
                    return;
                  }
                  _startTimer();
                  setState(
                    () => _isInfoStepCompleted = true,
                  );
                },
              ),
        if (_isInfoStepCompleted)
          M7LivelynessDetectionStepOverlay(
            key: _stepsKey,
            steps: _steps,
            onCompleted: () => _takePicture(
              didCaptureAutomatically: true,
            ),
          ),
        Visibility(
          visible: _isCaptureButtonVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(
                flex: 20,
              ),
              MaterialButton(
                onPressed: () => _takePicture(
                  didCaptureAutomatically: false,
                ),
                color: widget.config.captureButtonColor ??
                    Theme.of(context).primaryColor,
                textColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.camera_alt,
                  size: 24,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Material(
            color: const Color(0xff822ad2),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(null),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double calculateSymmetry(
      Point<int>? leftPosition, Point<int>? rightPosition) {
    if (leftPosition != null && rightPosition != null) {
      final double dx = (rightPosition.x - leftPosition.x).abs().toDouble();
      final double dy = (rightPosition.y - leftPosition.y).abs().toDouble();
      final distance = Offset(dx, dy).distance;

      return distance;
    }

    return 0.0;
  }
}
