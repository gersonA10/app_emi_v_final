// ignore_for_file: use_build_context_synchronously

import 'package:pagos_en_linea_emi/config/theme/extension_theme.dart';
import 'package:pagos_en_linea_emi/presentation/providers/auth_provider.dart';
import 'package:pagos_en_linea_emi/presentation/providers/fetch_data_pagos.dart';
import 'package:pagos_en_linea_emi/presentation/providers/theme_provider.dart';
import 'package:pagos_en_linea_emi/presentation/screens/login/login_screen.dart';
import 'package:pagos_en_linea_emi/presentation/screens/select_detail_screen/widgets/customa_app_bar.dart';
import 'package:pagos_en_linea_emi/presentation/screens/select_detail_screen/widgets/otros_pagos.dart';
import 'package:pagos_en_linea_emi/presentation/screens/select_detail_screen/widgets/pago_mensualidades.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pagos_en_linea_emi/presentation/screens/select_detail_screen/widgets/pagos_ingles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeleccionarDetalleScreen extends StatefulWidget {
  static const name = 'seleccionar-detalle';
  static const path = '/seleccionar-detalle';
  const SeleccionarDetalleScreen({super.key});

  @override
  State<SeleccionarDetalleScreen> createState() =>
      _SeleccionarDetalleScreenState();
}

class _SeleccionarDetalleScreenState extends State<SeleccionarDetalleScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final obtenerDataPagos = Provider.of<FetchDataPagosProvider>(context, listen: false);

      obtenerDataPagos.obtenerPagosPendientes(context);
      Future.delayed(const Duration(minutes: 10), () {
        context.go(LoginScreen.paht);
        prefs.clear();
      });
    });
    super.initState();
  }
@override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final obtenerDataPagos = Provider.of<FetchDataPagosProvider>(context);
  final authProvider = Provider.of<AuthProvider>(context);
  final screenSize = MediaQuery.of(context).size;
  final double topPadding = screenSize.height * 0.2;
  final double smallSpacing = screenSize.height * 0.02;
  final double broadSpacing = screenSize.width * 0.02;
  final double letterSize = screenSize.height;
  final double imgSize = screenSize.width * 0.4;

  // Determinar qué pestañas mostrar
  List<Widget> tabs = [];
  List<Widget> tabViews = [];

  if (obtenerDataPagos.itemsPagoInicial.isNotEmpty) {
    tabs.add(const Tab(text: "Pago Inicial"));
    tabViews.add(
      PagoInicial(
        obtenerDataPagos: obtenerDataPagos,
        screenSize: screenSize,
        letterSize: letterSize,
      ),
    );
  }

  if (obtenerDataPagos.itemsPagoMensualidades.isNotEmpty) {
    tabs.add(const Tab(text: "Mensualidades"));
    tabViews.add(
      PagoMensualidades(
        obtenerDataPagos: obtenerDataPagos,
        screenSize: screenSize,
        letterSize: letterSize,
      ),
    );
  }

  if (obtenerDataPagos.itemsPagoIngles.isNotEmpty) {
    tabs.add(const Tab(text: "Curso Ingles"));
    tabViews.add(
      PagosIngles(
        obtenerDataPagos: obtenerDataPagos,
        screenSize: screenSize,
        letterSize: letterSize,
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.darkBlue,
      leading: IconButton(
        onPressed: () {
          obtenerDataPagos.resetData();
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(topPadding * 0.08),
      child: Column(
        children: [
          CustomAppBar(
            broadSpacing: broadSpacing,
            letterSize: letterSize,
            imgSize: imgSize,
            smallSpacing: smallSpacing,
            obtenerDataPagos: obtenerDataPagos,
            themeProvider: themeProvider,
            authProvider: authProvider,
          ),
          DefaultTabController(
            length: tabs.length,
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: topPadding * 0.04),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 12, 68, 114),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TabBar(
                      labelStyle: TextStyle(
                        fontSize: letterSize * 0.015,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: Theme.of(context).colorScheme.yellow,
                      unselectedLabelStyle: TextStyle(
                        fontSize: letterSize * 0.015,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      labelColor: Theme.of(context).colorScheme.yellow,
                      tabs: tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: tabViews),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}

  

