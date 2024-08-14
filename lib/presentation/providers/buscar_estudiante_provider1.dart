// ignore_for_file: use_build_context_synchronously

import 'package:pagos_en_linea_emi/models/buscador_api.dart';
import 'package:pagos_en_linea_emi/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pagos_en_linea_emi/presentation/screens/options_screen/options_screen.dart';
import 'package:pagos_en_linea_emi/presentation/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuscarEstudianteProvider extends ChangeNotifier {
  final dio = Dio();
  String baseURL = 'https://test1.emi.edu.bo';

  // List<Item> listaPagosPendientes = [];
  // List<String> selectedItems = [];
  // List<String> selectedItemsOtros = [];
  // List<String> selectedItemsPagosIngles = [];
  // List<String> codigoSelect = [];
  // String ci = '';
  // String nombres = '';
  // String unidadAcademica = '';
  // double totalMonto = 0.0;
  // String ciNit = '';
  // double totalDescuento = 0.0;
  // String correo = '';
  // double monto = 0.0;
  // String? valueCarnet;
  // String? valueRSocial;
  // String? valueCant;
  // String codUni = '';
  // String nit = '';

  // List<Item> payMonthly = [];
  // List<Item> payEnglishCourse = [];
  // List<Item> payOther = [];


  //Busca al usuario
  Future<void> searchIDUser(String idUser, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idUser', idUser);

    String token = prefs.getString('token') ?? '';

    final data = {"cliente": idUser, "searchCode": 1};
    final headers = {
      'token': token,
      'content-Type': 'application/json',
    };

    try {
      final response = await dio.post(
        '$baseURL/buscador',
        data: data,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        context.go(OptionsScreen.paht);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        showErrorDialog(
          context, 
          "Usuario no encontrado",
          "Volver a ingresar el CI o Codigo correcto", 
          true, 
          () {
          context.pop();
           });
      } else {
        showErrorDialog(
          context,
          "Error",
          "Error al realizar la solicitud: Error de conexion",
          true,
          () {
            context.pop();
          },
        );
      }
    } catch (e) {
      showErrorDialog(
        context,
        "Error inesperado",
        "Ocurrió un error: Volver a intentar",
        true,
        () {
          context.pop();
        },
      );
    }
  }

//   set ciValue(String value) {
//     valueCarnet = value;
//     notifyListeners();
//   }

//   get valueCi => valueCarnet;

//   set razonsocialValue(String value) {
//     valueRSocial = value;
//     notifyListeners();
//   }

//   get valueRs => valueRSocial;

//   void onCheckboxChanged(bool? value, String codigoPago, BuildContext context) {
//     final item = getItemPorCodigoPAgo(codigoPago);
//     final buscarEstudianteProvider = Provider.of<BuscarEstudianteProvider>(context, listen: false);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     if (item != null) {
//       double itemMonto = double.tryParse(item.monto) ?? 0.0;

//       if (value == true) {
//         selectedItems.add(codigoPago);
//         totalMonto += item.montototal;
//         totalDescuento += item.descuento;
//         codUni = item.coduni;
//         nit = item.nitCi;
//         monto += itemMonto;
//       } else {
//         selectedItems.remove(codigoPago);
//         totalMonto -= item.montototal;
//         totalDescuento -= item.descuento;
//         monto -= itemMonto;
//       }
//       totalMonto = double.parse(totalMonto.toStringAsFixed(2));
//       totalDescuento = double.parse(totalDescuento.toStringAsFixed(2));
//       monto = double.parse(monto.toStringAsFixed(2));

//       notifyListeners();
//     } else {
//       _showErrorDialog(context, "Error", "El item seleccionado no se encontró.",true,(){buscarEstudianteProvider.listaPagosPendientes.clear(); authProvider.logOut(context);});
//     }
//   }

//   void selectedItemsIngles(bool? value, String codigoPago, BuildContext context){
//     final item = getItemPorcodigoPagoIngles(codigoPago);
//     final buscarEstudianteProvider = Provider.of<BuscarEstudianteProvider>(context, listen: false);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     if (item != null) {
//       double itemMonto = double.tryParse(item.monto) ?? 0.0;

//       if (value == true) {
//         selectedItemsPagosIngles.add(codigoPago);
//         totalMonto += item.montototal;
//         totalDescuento += item.descuento;
//         codUni = item.coduni;
//         nit = item.nitCi;
//         monto += itemMonto;
//       } else {
//         selectedItemsPagosIngles.remove(codigoPago);
//         totalMonto -= item.montototal;
//         totalDescuento -= item.descuento;
//         monto -= itemMonto;
//       }
//       totalMonto = double.parse(totalMonto.toStringAsFixed(2));
//       totalDescuento = double.parse(totalDescuento.toStringAsFixed(2));
//       monto = double.parse(monto.toStringAsFixed(2));

//       notifyListeners();
//     } else {
//       _showErrorDialog(context, "Error", "El item seleccionado no se encontró.",true,(){buscarEstudianteProvider.payEnglishCourse.clear(); authProvider.logOut(context);});
//     }
//   }

//   Item? getItemPorCodigoPAgo(String codigoPago) {
//     try {
//       return listaPagosPendientes.firstWhere((item) => item.codigopago == codigoPago);
//     } catch (e) {
//       return null;
//     }
//   }

//   Item? getItemPorcodigoPagoIngles(String codigoPago){
//     try {
//       return payEnglishCourse.firstWhere((item) => item.codigopago == codigoPago);
//     } catch (e) {
//       return null;
//     }
//   }

//   final List<Item> itemsSelectedByUser = [];

//   // void itemSelected(Item item, BuildContext context) {
//   //   if (itemsSelectedByUser.contains(item)) {
//   //     itemsSelectedByUser.remove(item);
//   //     codigoSelect.remove(item.codigopago);
//   //   } else {
//   //     itemsSelectedByUser.add(item);
//   //     codigoSelect.add(item.codigopago);
//   //   }

//   //   notifyListeners();
//   // }

//   bool get hasSelectedItems {
//     return selectedItems.isNotEmpty ||selectedItemsOtros.isNotEmpty || selectedItemsPagosIngles.isNotEmpty;
//   }

//   void resetData() {
//     selectedItems.clear();
//     selectedItemsOtros.clear();
//     selectedItemsPagosIngles.clear();
//     itemsSelectedByUser.clear();
//     codigoSelect.clear();
//     totalMonto = 0.0;
//     totalDescuento = 0.0;
//     monto = 0.0;
//     notifyListeners();
//   }


}
