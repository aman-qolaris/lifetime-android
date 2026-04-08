import 'package:go_router/go_router.dart';

// --- Screen Imports ---
import '../../features/application/presentation/screens/application_form_screen.dart';
import '../../features/application/presentation/screens/success_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/approval/presentation/screens/approval_screen.dart';
import '../../features/admin_auth/presentation/screens/admin_login_screen.dart';
import '../../features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin_dashboard/presentation/screens/edit_application_screen.dart';

// Global router instance
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Application Form
    GoRoute(
      path: '/',
      builder: (context, state) => const ApplicationFormScreen(),
    ),
    GoRoute(
      path: '/apply',
      builder: (context, state) => const ApplicationFormScreen(),
    ),

    // 2. Success Screen
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessScreen(),
    ),

    // 3. Payment Flow
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/recheck-application/:id',
      builder: (context, state) {
        final applicantId = state.pathParameters['id'] ?? '';
        return PaymentScreen(applicantId: applicantId);
      },
    ),

    // 4. Approval Flow
    GoRoute(
      path: '/approve/member',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ApprovalScreen(role: 'member', token: token);
      },
    ),
    GoRoute(
      path: '/approve/president',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ApprovalScreen(role: 'president', token: token);
      },
    ),

    // 5. Admin Authentication
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),

    // 6. Admin Dashboard
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    // 7. Edit Application
    GoRoute(
      path: '/edit-application/:id',
      builder: (context, state) {
        final applicantId = state.pathParameters['id']!;
        return EditApplicationScreen(applicantId: applicantId);
      },
    ),
  ],
);