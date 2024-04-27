import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/landing/presentation/cubit/logic_cubit/logical_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Future<void> getPosition() async {
    await BlocProvider.of<LogicalCubit>(context).getLatLng();
  }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: weatherWidget());
  }

  Widget weatherWidget() {
    return BlocBuilder<LogicalCubit, LogicalState>(
      builder: (context, state) {
        return Center(
          child: Text('${state.latitude}, ${state.longitude}'),
        );
      },
    );
  }
}
