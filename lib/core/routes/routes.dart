import 'package:flutter_ecommerce_supabase_supabase/screens/aboutus.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/bindings/auth_binding.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/forgot_password.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/login.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/otp_verification.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/register.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/reset_password.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/cart_page.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/checkout_page.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/home.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/order_tracking_page.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/products/products.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/products_page.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/widgets/layout/onboarding_intro.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/bindings/HomeBindings.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/middleware/check_login_guard.dart';
import 'package:get/get.dart';

final List<GetPage> appRoutes = [
  GetPage(
    name: '/',
    page: () => const Home(),
    binding: HomeBindings(),
  ),
  GetPage(name: '/onboarding', page: () => const OnboardingIntro()),
  GetPage(
    name: '/auth/login',
    page: () => const Login(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/auth/register',
    page: () => const Register(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/auth/forgot-password',
    page: () => const ForgotPassword(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/auth/otp',
    page: () => const OtpVerification(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/auth/reset-password',
    page: () => const ResetPassword(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/aboutus',
    page: () => Aboutus(),
    transition: Transition.leftToRight,
    middlewares: [CheckLoginGuard()],
  ),
  GetPage(
    name: '/products',
    page: () => ProductsPage(),
    transition: Transition.fade,
    middlewares: [CheckLoginGuard()],
  ),
  GetPage(
    name: '/cart',
    page: () => CartPage(),
    transition: Transition.fade,
    middlewares: [CheckLoginGuard()],
  ),
  GetPage(
    name: '/checkout',
    page: () => CheckoutPage(),
    transition: Transition.fade,
    middlewares: [CheckLoginGuard()],
  ),
  GetPage(
    name: '/orders',
    page: () => OrderTrackingPage(),
    transition: Transition.fade,
    middlewares: [CheckLoginGuard()],
  ),
];
