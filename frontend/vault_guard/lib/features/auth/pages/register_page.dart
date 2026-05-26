import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_snakbar.dart';
import '../../../main_exports.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final employeeIdController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xff111827),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff111827),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Register a security officer account',
                      style: TextStyle(color: Color(0xff6B7280)),
                    ),

                    const SizedBox(height: 32),

                    AppTextField(
                      controller: fullNameController,
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),

                    // const SizedBox(height: 16),

                    // AppTextField(
                    //   controller: phoneController,
                    //   hintText: 'Mobile Number',
                    //   keyboardType: TextInputType.phone,
                    //   prefixIcon: const Icon(Icons.phone_outlined),
                    // ),
                    const SizedBox(height: 16),

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

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: obscureConfirmPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.showSnackbar(
                            message: state.message,
                            backgroundColor: AppColors.success,
                          );

                          context.go('/login');
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
                          title: 'Create Account',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (passwordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              context.showSnackbar(
                                message: 'Password Does not match',
                                backgroundColor: AppColors.danger,
                              );
                            }

                            context.read<AuthCubit>().register(
                              name: fullNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Color(0xff6B7280)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xff111827),
                              fontWeight: FontWeight.w600,
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
