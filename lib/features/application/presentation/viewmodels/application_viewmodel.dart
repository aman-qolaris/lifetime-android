import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/application_repository.dart';

final regionsProvider =
FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(applicationRepositoryProvider).getActiveRegions();
});

final applicationSubmitProvider = StateNotifierProvider.autoDispose<
    ApplicationSubmitViewModel, AsyncValue<void>>((ref) {
  return ApplicationSubmitViewModel(
      ref.read(applicationRepositoryProvider));
});

class ApplicationSubmitViewModel extends StateNotifier<AsyncValue<void>> {
  final ApplicationRepository _repository;

  ApplicationSubmitViewModel(this._repository)
      : super(const AsyncData(null));

  Future<bool> submitForm({
    required Map<String, dynamic> textData,
    required File applicantPhoto,
    required File applicantSignature,
    required File aadharFront,
    required File aadharBack,
  }) async {
    state = const AsyncLoading();

    try {
      await _repository.submitApplication(
        textData: textData,
        applicantPhoto: applicantPhoto,
        applicantSignature: applicantSignature,
        aadharFront: aadharFront,
        aadharBack: aadharBack,
      );

      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}