part of 'employee_form_cubit.dart';

abstract class EmployeeFormState extends BaseEquatable {}

class EmployeeFormInitial extends EmployeeFormState {}

class EmployeeFormRefreshState extends EmployeeFormState {}

class ShowRolesBottomSheetState extends EmployeeFormState {}

class ShowDatePickerState extends EmployeeFormState {
  bool isFromDate;
  ShowDatePickerState(this.isFromDate);
}

class BaseEquatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}
