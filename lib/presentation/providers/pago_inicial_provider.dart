import 'package:flutter/material.dart';
import 'package:pagos_en_linea_emi/models/buscador_api.dart';

class PagoInicialProvider extends ChangeNotifier {


  List<Item> itemsSelectedPagoInicial = [];

  void selectedItemsPagoInicial(
      bool? value, String codigoPago, BuildContext context) {
    final item = getItemSelectedPagoInicial(codigoPago);
    // final buscarEstudianteProvider = Provider.of<BuscarEstudianteProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (item != null) {
      double itemMonto = double.tryParse(item.monto) ?? 0.0;

      if (value == true) {
        // selectedItemsOtros.add(codigoPago);
        // totalMonto += item.montototal;
        // totalDescuento += item.descuento;
        // codUni = item.coduni;
        // nit = item.nitCi;
        // monto += itemMonto;
      } else {
        // selectedItemsOtros.remove(codigoPago);
        // totalMonto -= item.montototal;
        // totalDescuento -= item.descuento;
        // monto -= itemMonto;
      }
      // totalMonto = double.parse(totalMonto.toStringAsFixed(2));
      // totalDescuento = double.parse(totalDescuento.toStringAsFixed(2));
      // monto = double.parse(monto.toStringAsFixed(2));

      notifyListeners();
    } else {
      // _showErrorDialog(
      //   context,
      //   "Error",
      //   "El item seleccionado no se encontró.",
      //   true,
      //   () {
      //     buscarEstudianteProvider.payOther.clear();
      //     authProvider.logOut(context);
      //   },
      // );
    }
  }

  Item? getItemSelectedPagoInicial(String codigoPago) {
    try {
      // return payOther.firstWhere((item) => item.carrera == codigoPago);
    } catch (e) {
      return null;
    }
  }
}
