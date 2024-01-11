import 'package:auto_size_text/auto_size_text.dart';
import 'package:m7_livelyness_detection/index.dart';

class M7LivelynessDetectionStepOverlay extends StatefulWidget {
  final List<M7LivelynessStepItem> steps;
  final VoidCallback onCompleted;

  const M7LivelynessDetectionStepOverlay({
    super.key,
    required this.steps,
    required this.onCompleted,
  });

  @override
  State<M7LivelynessDetectionStepOverlay> createState() =>
      M7LivelynessDetectionStepOverlayState();
}

class M7LivelynessDetectionStepOverlayState
    extends State<M7LivelynessDetectionStepOverlay> {
  //* MARK: - Public Variables
  //? =========================================================
  int get currentIndex {
    return _currentIndex;
  }

  bool _isLoading = false;

  //* MARK: - Private Variables
  //? =========================================================
  int _currentIndex = 0;

  late final PageController _pageController;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(),
          Visibility(
            visible: _isLoading,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      ),
    );
  }

  //* MARK: - Public Methods for Business Logic
  //? =========================================================
  Future<void> nextPage() async {
    if (_isLoading) {
      return;
    }
    if ((_currentIndex + 1) < widget.steps.length) {
      //Move to next step
      _showLoader();
      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      await Future.delayed(
        const Duration(seconds: 2),
      );
      _hideLoader();
      setState(() => _currentIndex++);
    } else {
      widget.onCompleted();
    }
  }

  void reset() {
    _pageController.jumpToPage(0);
    setState(() => _currentIndex = 0);
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _showLoader() => setState(
        () => _isLoading = true,
      );

  void _hideLoader() => setState(
        () => _isLoading = false,
      );

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  Widget _buildBody() {
    return AbsorbPointer(
      absorbing: true,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.steps.length,
        itemBuilder: (context, index) {
          return _buildAnimatedWidget(
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (widget.steps[index].step ==
                      M7LivelynessStep.blink) ...[
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                        M7AssetConstants.lottie.blink,
                        package: M7AssetConstants.packageName,
                        animate: true,
                        repeat: true,
                      ),
                    )
                  ],
                  if (widget.steps[index].step ==
                      M7LivelynessStep.smile) ...[
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                        M7AssetConstants.lottie.smile,
                        package: M7AssetConstants.packageName,
                        animate: true,
                        repeat: true,
                      ),
                    )
                  ],
                  if (widget.steps[index].step ==
                      M7LivelynessStep.turnRight) ...[
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                        M7AssetConstants.lottie.turnRight,
                        package: M7AssetConstants.packageName,
                        animate: true,
                        repeat: true,
                      ),
                    )
                  ],
                  if (widget.steps[index].step ==
                      M7LivelynessStep.turnLeft) ...[
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Lottie.asset(
                        M7AssetConstants.lottie.turnLeft,
                        package: M7AssetConstants.packageName,
                        animate: true,
                        repeat: true,
                      ),
                    )
                  ],
                  AutoSizeText(
                    widget.steps[index].step == M7LivelynessStep.smile
                        ? langLivelyness.smile
                        : widget.steps[index].step ==
                        M7LivelynessStep.blink
                        ? langLivelyness.blink
                        : widget.steps[index].step ==
                        M7LivelynessStep.turnLeft
                        ? langLivelyness.turnYourHeadLeft
                        : widget.steps[index].step ==
                        M7LivelynessStep.turnRight
                        ? langLivelyness.turnYourHeadRight
                        : '',
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    maxFontSize: 22,
                    minFontSize: 20,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            isExiting: index != _currentIndex,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedWidget(
    Widget child, {
    required bool isExiting,
  }) {
    return isExiting
        ? ZoomOut(
            animate: true,
            child: FadeOutLeft(
              animate: true,
              delay: const Duration(milliseconds: 200),
              child: child,
            ),
          )
        : ZoomIn(
            animate: true,
            delay: const Duration(milliseconds: 500),
            child: FadeInRight(
              animate: true,
              delay: const Duration(milliseconds: 700),
              child: child,
            ),
          );
  }
}
