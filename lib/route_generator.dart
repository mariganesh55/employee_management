import 'package:employee_management_app/presentation/screens/employee_form_screen.dart';
import 'package:employee_management_app/presentation/screens/employee_management_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const employeeFormScreen = "/employee_form";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const EmployeeManagementScreen(),
        );
      case employeeFormScreen:
        return MaterialPageRoute(
          builder: (_) => EmployeeFormScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const EmployeeManagementScreen(),
        );
    }
  }
}
