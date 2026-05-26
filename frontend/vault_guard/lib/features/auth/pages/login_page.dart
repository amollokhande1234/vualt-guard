import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vault_guard/core/constants/app_colors.dart';
import 'package:vault_guard/core/widgets/app_snakbar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_feild.dart';
import '../../../main_exports.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xff111827),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Vault Guard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff111827),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Sign in to access the security dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff6B7280), fontSize: 14),
                    ),

                    const SizedBox(height: 40),

                    AppTextField(
                      controller: emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xff111827)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.showSnackbar(
                            message: state.message,
                            backgroundColor: AppColors.success,
                          );

                          context.go('/home');
                        }

                        if (state is AuthFailure) {
                          context.showSnackbar(
                            message: state.error,
                            backgroundColor: AppColors.danger,
                          );
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          title: 'Login',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            context.read<AuthCubit>().login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Color(0xff6B7280)),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/register');
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
