import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/cubits/board_cubit.dart';
import 'package:todo/src/repository/board_repository.dart';
import 'package:todo/src/repository/isar/isar_board_repository.dart';
import 'package:todo/src/repository/isar/isar_datasource.dart';

import 'src/pages/board_page.dart';

void main() {
  runApp(const AppWiget());
}

class AppWiget extends StatelessWidget {
  const AppWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => IsarDatasource()),
        RepositoryProvider<BoardRepository>(
            create: (context) => IsarBoardRepository(context.read())),
        BlocProvider(create: (context) => BoardCubit(context.read())),
      ],
      child: MaterialApp(
        theme: ThemeData.from(
          colorScheme: const ColorScheme.dark(),
        ),
        home: const Center(
          child: BoardPage(),
        ),
      ),
    );
  }
}
