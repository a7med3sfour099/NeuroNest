import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuronest/features/assessmentResult/views/video_result_view.dart';
import 'package:neuronest/features/uploadVideo/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:neuronest/core/constants/app_colors.dart';

class PreviewAndAnalyzeView extends StatefulWidget {
  final String videoPath;
  final int childId;

  const PreviewAndAnalyzeView({
    super.key,
    required this.videoPath,
    required this.childId,
  });

  @override
  State<PreviewAndAnalyzeView> createState() => _PreviewAndAnalyzeViewState();
}

class _PreviewAndAnalyzeViewState extends State<PreviewAndAnalyzeView> {
  VideoPlayerController? _controller;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));
    try {
      await _controller!.initialize().timeout(const Duration(seconds: 5));
      await _controller!.play();
      await _controller!.setLooping(true);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Video initialization error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Emulator issue: Cannot play video. Please use a real device.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  // Future<void> _startVideoAnalysis() async {
  //   // 1️⃣ إيقاف الفيديو فوراً لتفريغ ذاكرة كارت الشاشة (Graphic Buffers) ومنع التهنيج
  //   _controller?.pause();

  //   setState(() {
  //     _isAnalyzing = true;
  //   });

  //   try {
  //     // 💡 هنا هتحط نداء الـ API بتاعك لرفع الفيديو للـ Backend مستقبلاً

  //     // محاكاة وقت الرفع والتحليل (3 ثواني للتجربة)
  //     await Future.delayed(const Duration(seconds: 3));

  //     if (!mounted) return;

  //     // 2️⃣ الانتقال المباشر وتمرير مسار الفيديو لصفحة النتيجة
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => VideoResultView(
  //           videoPath:
  //               widget.videoPath, // بنبعت مسار الفيديو علشان يعرض مدته هناك
  //           // analysisResult: null, // مستقبلاً هتباصي الـ Map اللي راجعة من السيرفر هنا
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Analysis failed: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isAnalyzing = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _startVideoAnalysis() async {
    _controller?.pause();

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final provider = context.read<VideoProvider>();
      print("1- Before Upload");

      final success = await provider.uploadVideo(
        widget.childId,
        File(widget.videoPath),
      );

      print("2- Upload Finished");
      print("Success => $success");
      print("Result => ${provider.result}");

      if (!mounted) return;

      if (success) {
        print(provider.result);
        print(provider.result?.riskLevel);
        print(provider.result?.totalScore);
        print("3- Going To Result Screen");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VideoResultView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Review Your Video',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Gap(10),
            const Text(
              'Please review your video before submitting for AI analysis.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Gap(30),

            Expanded(
              child: _controller != null && _controller!.value.isInitialized
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xffDBEFF8),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  ),

                                  if (!_controller!.value.isPlaying)
                                    Container(
                                      color: Colors.black.withOpacity(0.2),
                                    ),

                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller!.value.isPlaying
                                            ? _controller!.pause()
                                            : _controller!.play();
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _controller!.value.isPlaying
                                            ? Colors.black26
                                            : const Color(
                                                0xFF4A7DCD,
                                              ).withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _controller!.value.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const Gap(5),
                              Text(
                                "Video Duration: ${_controller!.value.duration.inSeconds} seconds",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4A7DCD),
                      ),
                    ),
            ),
            const Gap(40),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _isAnalyzing ? Colors.grey : const Color(0xFF4A7DCD),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _isAnalyzing ? null : _startVideoAnalysis,
                  child: Center(
                    child: _isAnalyzing
                        ? Consumer<VideoProvider>(
                            // Listen to the provider to get the dynamic message
                            builder: (context, provider, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    provider.loadingMessage.isNotEmpty
                                        ? provider.loadingMessage
                                        : 'Processing...',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(15),
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : const Text(
                            'Analyze Video',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
