import 'package:bloc/bloc.dart';
import 'package:employee_management_app/data/employee.dart';
import 'package:employee_management_app/utils/database_helper.dart';
import 'package:flutter/material.dart';

part 'employee_form_state.dart';

class EmployeeFormCubit extends Cubit<EmployeeFormState> {
  final TextEditingController nameController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Employee? employee;

  String? selectedRole;
  DateTime? fromDate;
  DateTime? toDate;
  List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  EmployeeFormCubit() : super(EmployeeFormInitial());

  void refreshScreen() async {
    emit(EmployeeFormRefreshState());
  }

  void showDatePicker({required bool isFromDate}) {
    emit(ShowDatePickerState(isFromDate));
  }

  void showRolesBottomSheet() {
    emit(ShowRolesBottomSheetState());
  }

  bool isValid() {
    return nameController.text.isNotEmpty &&
        selectedRole != null &&
        fromDate != null &&
        toDate != null;
  }

  clearAllValues() {
    selectedRole = null;
    fromDate = null;
    toDate = null;
    nameController.clear();
    employee = null;
  }

  initialise() {
    if (employee != null) {
      selectedRole = employee?.role;
      fromDate = employee?.startDate;
      toDate = employee?.endDate;
      nameController.text = employee?.name ?? '';
    } else {
      clearAllValues();
    }
    refreshScreen();
  }

  Future<void> saveEmployee() async {
    Employee newEmployee = Employee(
      id: employee?.id,
      name: nameController.text,
      role: selectedRole ?? '',
      startDate: fromDate!,
      endDate: toDate!,
    );
    employee == null
        ? await dbHelper.addEmployee(newEmployee)
        : await dbHelper.updateEmployee(newEmployee);
  }
}
