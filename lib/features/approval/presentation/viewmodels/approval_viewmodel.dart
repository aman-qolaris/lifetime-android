import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/approval_repository.dart';

// Provides the token and role dynamically from the screen to the FutureProvider
class ApprovalParams {
  final String token;
  final String role;
  ApprovalParams(this.token, this.role);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ApprovalParams && token == other.token && role == other.role;

  @override
  int get hashCode => token.hashCode ^ role.hashCode;
}

final approvalDetailsProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, ApprovalParams>((ref, params) async {
  if (params.token.isEmpty) throw Exception("Token is missing.");
  return ref.read(approvalRepositoryProvider).fetchApprovalDetails(params.token, params.role);
});

final approvalSubmitProvider = StateNotifierProvider<ApprovalSubmitViewModel, AsyncValue<void>>((ref) {
  return ApprovalSubmitViewModel(ref.read(approvalRepositoryProvider));
});

class ApprovalSubmitViewModel extends StateNotifier<AsyncValue<void>> {
  final ApprovalRepository _repository;

  ApprovalSubmitViewModel(this._repository) : super(const AsyncData(null));

  Future<bool> submitAction(String role, String token, String action) async {
    state = const AsyncLoading();
    try {
      await _repository.submitApproval(role, token, action);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}