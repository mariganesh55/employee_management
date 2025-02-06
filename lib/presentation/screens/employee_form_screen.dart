import 'package:employee_management_app/data/cubit/employee_form/employee_form_cubit.dart';
import 'package:employee_management_app/data/employee.dart';
import 'package:employee_management_app/utils/color_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  EmployeeFormScreen({
    Key? key,
    this.employee,
  }) : super(key: key);

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  late EmployeeFormCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<EmployeeFormCubit>(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _bloc.employee = widget.employee;
        _bloc.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeFormCubit, EmployeeFormState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is ShowRolesBottomSheetState) {
          showRolesModalSheet();
        } else if (state is ShowDatePickerState) {
          _selectDate(context, isFromDate: state.isFromDate);
        }
      },
      child: BlocBuilder<EmployeeFormCubit, EmployeeFormState>(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16.0, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _bloc.refreshScreen();
                          },
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xffEDF8FF),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_bloc.isValid()) {
                              await _bloc.saveEmployee();
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text(
                "Add Employee Details",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xff1DA1F2),
              leading: const SizedBox(),
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _bloc.nameController,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.person_2_outlined, color: Colors.blue),
                      hintText: "Employee Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorResource.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorResource.grey)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorResource.grey)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () => showRolesModalSheet(),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.work_outline, color: Colors.blue),
                          suffixIcon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.blue,
                          ),
                          hintText: "Select Role",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorResource.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorResource.grey)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorResource.grey)),
                        ),
                        child: Text(
                          _bloc.selectedRole ?? 'Select role',
                          style: TextStyle(
                              fontSize: 16,
                              color: _bloc.selectedRole == null
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _bloc.showDatePicker(isFromDate: true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined,
                                  color: Colors.blue),
                              hintText: "From date",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                            ),
                            child: Text(
                              _bloc.fromDate != null
                                  ? DateFormat.yMMMd().format(_bloc.fromDate!)
                                  : 'Today',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.arrow_right_alt, color: Colors.blue),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _bloc.showDatePicker(isFromDate: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined,
                                  color: Colors.blue),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorResource.grey)),
                            ),
                            child: Text(
                              _bloc.toDate != null
                                  ? DateFormat.yMMMd().format(_bloc.toDate!)
                                  : 'No date',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showRolesModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(8),
            height: 200,
            alignment: Alignment.center,
            child: ListView.separated(
                itemCount: _bloc.roles.length,
                separatorBuilder: (context, int) {
                  return Divider(
                    color: Colors.grey.withOpacity(0.3),
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                      child: Center(
                          child: Text(
                        _bloc.roles[index],
                        style: const TextStyle(fontSize: 16),
                      )),
                      onTap: () {
                        _bloc.selectedRole = _bloc.roles[index];
                        _bloc.refreshScreen();
                        Navigator.of(context).pop();
                      });
                }),
          );
        });
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isFromDate}) async {
    DateTime selectedDate = isFromDate
        ? (_bloc.fromDate ?? DateTime.now())
        : (_bloc.toDate ?? DateTime.now());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// QUICK SELECT BUTTONS
                      ///
                      Row(
                        children: [
                          Expanded(
                            child: _quickDateButton(
                                context, "Today", DateTime.now(), setState),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: _quickDateButton(
                                context, "Next Monday", _nextMonday(), setState,
                                bgColor: Colors.blue, textColor: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _quickDateButton(context, "Next Tuesday",
                                _nextTuesday(), setState),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: _quickDateButton(
                                  context,
                                  "After 1 week",
                                  DateTime.now().add(const Duration(days: 7)),
                                  setState))
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// CALENDAR PICKER
                      SizedBox(
                        height: 300,
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                            _bloc.refreshScreen();
                          },
                        ),
                      ),

                      /// SELECTED DATE DISPLAY
                      ListTile(
                        leading: const Icon(Icons.calendar_today,
                            color: Colors.blue),
                        title: Text(
                          DateFormat('d MMM yyyy').format(selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      /// CANCEL & SAVE BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _bloc.refreshScreen();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEDF8FF),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isFromDate) {
                                  _bloc.fromDate = selectedDate;
                                  if (_bloc.toDate != null &&
                                      _bloc.fromDate!.isAfter(_bloc.toDate!)) {
                                    _bloc.toDate = _bloc
                                        .fromDate; // Ensure To Date is not before From Date
                                  }
                                } else {
                                  if (_bloc.fromDate == null ||
                                      selectedDate.isAfter(_bloc.fromDate!)) {
                                    _bloc.toDate = selectedDate;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "To Date must be after From Date")),
                                    );
                                    return;
                                  }
                                }
                              });
                              Navigator.pop(context);
                              _bloc.refreshScreen();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _quickDateButton(
      BuildContext context, String label, DateTime date, StateSetter setState,
      {Color bgColor = const Color(
        0xffEDF8FF,
      ),
      Color textColor = Colors.blue}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          setState(() {
            _bloc.fromDate = date;
            if (_bloc.toDate != null &&
                _bloc.fromDate!.isAfter(_bloc.toDate!)) {
              _bloc.toDate = _bloc.fromDate; // Adjust to prevent invalid range
            }
          });
        });
        _bloc.refreshScreen();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }

  DateTime _nextMonday() {
    DateTime now = DateTime.now();
    int daysToMonday = (DateTime.monday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysToMonday));
  }

  DateTime _nextTuesday() {
    DateTime now = DateTime.now();
    int daysToTuesday = (DateTime.tuesday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysToTuesday));
  }

  @override
  void dispose() {
    _bloc.clearAllValues();
    super.dispose();
  }
}
