// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pagos_en_linea_emi/models/buscador_api.dart';
import 'package:pagos_en_linea_emi/presentation/providers/auth_provider.dart';
import 'package:pagos_en_linea_emi/presentation/screens/payment_method_screen/pago_de_cuentas_screen.dart';
import 'package:pagos_en_linea_emi/presentation/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchDataPagosProvider extends ChangeNotifier {
  final dio = Dio();
  String baseURL = 'https://test1.emi.edu.bo';

  // Listas de los pagos que puede tener el usuario
  List<Item> itemsPagoInicial = [];
  List<Item> itemsPagoMensualidades = [];
  List<Item> itemsPagoIngles = [];

  //Campos del usuario
  String ci = '';
  String nombres = '';
  String unidadAcademica = '';
  double totalMonto = 0.0;
  String ciNit = '';
  double totalDescuento = 0.0;
  String correo = '';
  double monto = 0.0;
  String? valueCarnet;
  String? valueRSocial;
  String? valueCant;
  String codUni = '';
  String nit = '';
  
  //Todos los items que el usuario selecciona PAGO INICIAL, MENSUALIDADES, CURSOS INGLES
  List<Item> selectedItems = [];
  

  // void toggleSelectionPagoInicial() {
  //   bool allSelected = itemsPagoInicial.every((item) => item.isSelected);
  //   for (var item in itemsPagoInicial) {
  //     item.isSelected = !allSelected;
  //     notifyListeners();
  //     if (item.isSelected == true) {
  //       selectedItems.add(item);
  //     } else {
  //       selectedItems.remove(item);
  //     }
  //   }
  //   notifyListeners();
  // }

  void toggleSelectionPagoInicial() {
  bool allSelected = itemsPagoInicial.every((item) => item.isSelected);
  for (var item in itemsPagoInicial) {
    item.isSelected = !allSelected;
    if (item.isSelected) {
      if (!selectedItems.contains(item)) selectedItems.add(item);
    } else {
      selectedItems.remove(item);
    }
  }
  notifyListeners();
}

void toggleSelectionPagoMensualidades(Item selectedItem) {
  // Encuentra el índice del ítem seleccionado en la lista
  int index = itemsPagoMensualidades.indexOf(selectedItem);
  
  if (index == -1) return; // El ítem no está en la lista

  // Si el ítem no está seleccionado, selecciona todos los ítems anteriores
  bool newSelectionStatus = !selectedItem.isSelected;

  if (newSelectionStatus) {
    for (int i = 0; i <= index; i++) {
      if (!itemsPagoMensualidades[i].isSelected) {
        itemsPagoMensualidades[i].isSelected = true;
        if (!selectedItems.contains(itemsPagoMensualidades[i])) selectedItems.add(itemsPagoMensualidades[i]);
      }
    }
  } else {
    // Si el ítem está desmarcado, desmarca todos los ítems posteriores
    for (int i = index; i < itemsPagoMensualidades.length; i++) {
      if (itemsPagoMensualidades[i].isSelected) {
        itemsPagoMensualidades[i].isSelected = false;
        selectedItems.remove(itemsPagoMensualidades[i]);
      }
    }
  }

  notifyListeners();
}

void toggleSelectionPagoIngles(Item selectedItem) {
  // Encuentra el índice del ítem seleccionado en la lista
  int index = itemsPagoIngles.indexOf(selectedItem);
  
  if (index == -1) return; // El ítem no está en la lista

  // Si el ítem no está seleccionado, selecciona todos los ítems anteriores
  bool newSelectionStatus = !selectedItem.isSelected;

  if (newSelectionStatus) {
    for (int i = 0; i <= index; i++) {
      if (!itemsPagoIngles[i].isSelected) {
        itemsPagoIngles[i].isSelected = true;
        if (!selectedItems.contains(itemsPagoIngles[i])) selectedItems.add(itemsPagoIngles[i]);
      }
    }
  } else {
    // Si el ítem está desmarcado, desmarca todos los ítems posteriores
    for (int i = index; i < itemsPagoIngles.length; i++) {
      if (itemsPagoIngles[i].isSelected) {
        itemsPagoIngles[i].isSelected = false;
        selectedItems.remove(itemsPagoIngles[i]);
      }
    }
  }

  notifyListeners();
}


// void toggleSelectionPagoIngles() {
//   bool allSelected = itemsPagoIngles.every((item) => item.isSelected);
//   for (var item in itemsPagoIngles) {
//     item.isSelected = !allSelected;
//     if (item.isSelected) {
//       if (!selectedItems.contains(item)) selectedItems.add(item);
//     } else {
//       selectedItems.remove(item);
//     }
//   }
//   notifyListeners();
// }


  double calcularTotal(){
    double total = 0.0;

    for (var item in itemsPagoInicial) {
      if (item.isSelected) {
        total += double.parse(item.monto);
      }
    }

    for (var item in itemsPagoMensualidades) {
      if (item.isSelected) {
        total += double.parse(item.monto);
      }
    }

    for (var item in itemsPagoIngles) {
      if (item.isSelected) {
        total += double.parse(item.monto);
      }
    }

    return total;

  }


  void pagar(BuildContext context){
    // calcularTotal();

    Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => PagoCuentasScreen(
         totalMonto: calcularTotal(),
         selectedItems: selectedItems,
         totalDescuento: 0,
         monto: 0,
       ),
     ),
   );
  }

  Future<void> obtenerPagosPendientes(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString('idUser') ?? '';
    String token = prefs.getString('token') ?? '';
    // final buscarEstudianteProvider = Provider.of<BuscarEstudianteProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);


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
      final res = BuscadorPagosPendientes.fromJson(response.data);

      for (var element in res.items) {
        //Verificar si el usuario tiene pagos iniciales
        if (element.codigopago.contains('1260') ||
            element.codpag.contains('7212') ||
            element.codpag.contains('7602') ||
            element.codpag.contains('7604')) {
          //si tiene pagos iniciales lo agregamos a su lista correspondiente
          itemsPagoInicial.add(element);
        } else if (
            //verifica si tiene pagos de mensualidades
            element.codpag.contains('1261') ||
            element.codpag.contains('1262') ||
            element.codpag.contains('1263') ||
            element.codpag.contains('1264') ||
            element.codpag.contains('1265')
          ) {
          //si tiene pago de mensualidades se agrega a su lista correspondiente
          itemsPagoMensualidades.add(element);
        }
        //verifica si tiene algun pago de INGLES
        if (element.item.contains('INGLES')) {
          //si tiene lo agregamos a su lista correspondiente
          itemsPagoIngles.add(element);
        }
      }

      notifyListeners();
      ci = res.cliente.ci;
      nombres = res.cliente.nombres;
      unidadAcademica = res.cliente.unidadAcademica;
      ciNit = res.cliente.paterno;
      correo = res.cliente.eMail;

    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        showErrorDialog(
          context,
          "Error",
          "Inicio de sesión caducado",
          true,
          () {
            //si su sesion caduca cerramos sesion y limpiamos todas las listas de items
            itemsPagoIngles.clear();
            itemsPagoInicial.clear();
            itemsPagoMensualidades.clear();
            authProvider.logOut(context);
          },
        );
      } else {
        showErrorDialog(
          context,
          "Error",
          "Error al realizar la solicitud: Error de conexion",
          true,
          () {
            //si nos da error cerramos sesion y limpiamos todas las listas de items
            itemsPagoIngles.clear();
            itemsPagoInicial.clear();
            itemsPagoMensualidades.clear();
            authProvider.logOut(context);
            context.pop();
          },
        );
      }
    } catch (e) {
      showErrorDialog(
        context,
        "Error inesperado",
        "Ocurrió un error: volver a intentar",
        true,
        () {
          //si nos da error cerramos sesion y limpiamos todas las listas de items
            itemsPagoIngles.clear();
            itemsPagoInicial.clear();
            itemsPagoMensualidades.clear();
            authProvider.logOut(context);
        },
      );
    }
  }

  void resetData2() {    
  // Deseleccionar todos los elementos en las listas de pagos
  for (var item in itemsPagoInicial) {
    item.isSelected = false;
  }

  for (var item in itemsPagoMensualidades) {
    item.isSelected = false;
  }

  for (var item in itemsPagoIngles) {
    item.isSelected = false;
  }
  
  // Limpiar los elementos seleccionados
  selectedItems.clear();

  // Resetear los totales pero no las listas
  totalMonto = 0.0;
  totalDescuento = 0.0;
  monto = 0.0;
  
  notifyListeners();
}

  void resetData() {    
    //limpiar datos de pagos pendientes
    itemsPagoMensualidades.clear();
    itemsPagoIngles.clear();
    itemsPagoInicial.clear();
    
    //limpiar datos seleccionados por el usuario
    selectedItems.clear();
    // codigoSelect.clear();
    totalMonto = 0.0;
    totalDescuento = 0.0;
    monto = 0.0;
    notifyListeners();
  }

  set razonsocialValue(String value) {
    valueRSocial = value;
    notifyListeners();
  }

  set ciValue(String value) {
    valueCarnet = value;
    notifyListeners();
  }


}
