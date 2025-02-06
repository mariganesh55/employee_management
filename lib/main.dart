// main.dart
import 'package:employee_management_app/data/cubit/employee_form/employee_form_cubit.dart';
import 'package:employee_management_app/data/cubit/employee_management/employee_management_cubit.dart';
import 'package:employee_management_app/presentation/screens/employee_management_screen.dart';
import 'package:employee_management_app/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeManagementCubit>(
          create: (context) => EmployeeManagementCubit(),
        ),
        BlocProvider<EmployeeFormCubit>(
          create: (context) => EmployeeFormCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Management',
        theme: _buildTheme(),
        home: EmployeeManagementScreen(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF4CAF50), surface: const Color(0xFFFAFAFA)),
      // primaryColor: const Color(0xFF2196F3),
      textTheme: _buildTextTheme(base.textTheme),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(
        color: const Color(0xFF333333),
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: const Color(0xFF333333),
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: const Color(0xFF333333),
      ),
    );
  }
}
