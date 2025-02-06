import 'package:bloc/bloc.dart';
import 'package:employee_management_app/data/cubit/employee_form/employee_form_cubit.dart';
import 'package:employee_management_app/data/employee.dart';
import 'package:employee_management_app/utils/database_helper.dart';

part 'employee_management_state.dart';

class EmployeeManagementCubit extends Cubit<EmployeeManagementState> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Employee> employees = [];

  EmployeeManagementCubit() : super(EmployeeManagementInitial());

  Future<void> fetchEmployees() async {
    final allEmployees = await dbHelper.getAllEmployees();
    employees = allEmployees;
    emit(EmployeeManagementRefreshState());
  }

  Future<void> deleteEmployee(Employee employee) async {
    await dbHelper.deleteEmployee(employee.id!);
    await fetchEmployees();
  }
}
