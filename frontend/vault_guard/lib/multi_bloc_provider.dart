import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_repo.dart';

class AppBlocProvider extends StatelessWidget {
  Widget child;
  AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepository(apiClient: API())),
        ),
      ],
      child: child,
    );
  }
}
