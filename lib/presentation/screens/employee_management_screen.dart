import 'package:employee_management_app/data/cubit/employee_management/employee_management_cubit.dart';
import 'package:employee_management_app/data/employee.dart';
import 'package:employee_management_app/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'employee_form_screen.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  late EmployeeManagementCubit _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of<EmployeeManagementCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _bloc.fetchEmployees();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        final today = DateTime.now();
        List<Employee> currentEmployees = _bloc.employees
            .where((e) => e.endDate == null || e.endDate!.isAfter(today))
            .toList();
        List<Employee> previousEmployees = _bloc.employees
            .where((e) => e.endDate != null && e.endDate!.isBefore(today))
            .toList();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Employee List",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff1DA1F2),
          ),
          body: _bloc.employees.isEmpty
              ? Center(
                  child: Image.asset(
                  "assets/no_employees.png",
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                ))
              : ListView(
                  children: [
                    _buildSection("Current Employees", currentEmployees),
                    _buildSection("Previous Employees", previousEmployees),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteGenerator.employeeFormScreen)
                  .then(
                (value) {
                  _bloc.fetchEmployees();
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Employee> employees) {
    if (employees.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue)),
        ),
        ...employees.map((e) => _buildEmployeeTile(e)).toList(),
      ],
    );
  }

  Widget _buildEmployeeTile(Employee employee) {
    return Slidable(
      key: Key(employee.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _bloc.deleteEmployee(employee),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          employee.name,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                employee.role,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              formatEmployeeDate(employee),
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        onTap: () => _navigateToEditScreen(employee),
      ),
    );
  }

  void _navigateToEditScreen(Employee? employee) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeFormScreen(
            employee: employee,
          ),
        )).then(
      (value) {
        _bloc.fetchEmployees();
      },
    );
  }

  String formatEmployeeDate(Employee employee) {
    final dateFormat = DateFormat("d MMM, yyyy");

    if (employee.endDate == null || employee.endDate!.isAfter(DateTime.now())) {
      return "From ${dateFormat.format(employee.startDate)}";
    } else {
      return "${dateFormat.format(employee.startDate)} - ${dateFormat.format(employee.endDate!)}";
    }
  }
}
