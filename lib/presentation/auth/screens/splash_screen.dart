import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/storage/local_storage.dart';

/// Splash Screen
/// 
/// Displayed while checking authentication status on app launch

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _videoPlayedOrFailed = false;
  bool _videoError = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/images/loading.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: true,
            looping: false,
            showControls: false,
            allowMuting: false,
            allowPlaybackSpeedChanging: false,
            allowFullScreen: false,
            aspectRatio: _videoController.value.aspectRatio > 0 ? _videoController.value.aspectRatio : 1.0,
          );
        });
        _videoController.addListener(_onVideoEnd);
      }).catchError((e) {
        setState(() {
          _videoError = true;
        });
        _proceedAfterVideo();
      });
    _videoController.setVolume(0.0);
  }

  void _onVideoEnd() {
    if (_videoController.value.hasError && !_videoPlayedOrFailed) {
      setState(() {
        _videoError = true;
      });
      _proceedAfterVideo();
      return;
    }
    if (_videoController.value.position >= _videoController.value.duration && !_videoPlayedOrFailed) {
      _proceedAfterVideo();
    }
  }

  void _proceedAfterVideo() {
    if (_videoPlayedOrFailed) return;
    _videoPlayedOrFailed = true;
    LocalStorage.save('settings', 'splashShown', true);
    _goToLogin();
  }

  void _goToLogin() {
    if (mounted) {
      // Use GoRouter to navigate to login page
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoEnd);
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _videoError
            ? Image.asset('assets/images/icon.png', width: 120, height: 120)
            : (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : Image.asset('assets/images/icon.png', width: 120, height: 120)),
      ),
    );
  }
}
