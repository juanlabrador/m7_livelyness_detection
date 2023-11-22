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
      height: double.infinity,
      width: double.infinity,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 5,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: _currentIndex + 1,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(0xFF822ad2),
                  ),
                ),
              ),
              Expanded(
                flex: widget.steps.length - (_currentIndex + 1),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 2,
          child: AbsorbPointer(
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
                    child: AutoSizeText(
                      widget.steps[index].title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      maxFontSize: 24,
                      minFontSize: 18,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  isExiting: index != _currentIndex,
                );
              },
            ),
          ),
        ),
        const Spacer(
          flex: 14,
        ),
      ],
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