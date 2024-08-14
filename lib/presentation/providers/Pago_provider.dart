import 'package:pagos_en_linea_emi/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pagos_en_linea_emi/presentation/providers/fetch_data_pagos.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:pagos_en_linea_emi/presentation/providers/counters.dart';

class PagoService {
  final Dio _dio = Dio();
  
  Future<void> enviarDatos(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final countServi = CountersServices();
    String token = prefs.getString('token') ?? '';
    String cuf = _generarCUF();
    String fechaPago = _obtenerFechaActual();
    String? valCi;
    String? valRS;
    String? valNit;
    String? valCodUni;
    
    
    
    final obtenerDatosPago = Provider.of<FetchDataPagosProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    valNit = obtenerDatosPago.nit;
    valCodUni = obtenerDatosPago.codUni;
    if (obtenerDatosPago.valueCarnet == null) {
      valCi = obtenerDatosPago.ci;
    } else {
      valCi = obtenerDatosPago.valueCarnet;
    }

    if (obtenerDatosPago.valueRSocial == null) {
      valRS = obtenerDatosPago.ciNit;
    } else {
      valRS = obtenerDatosPago.valueRSocial;
    }

    // List<Map<String, dynamic>> mapCog = obtenerDatosPago.codigoSelect.map((codigo) {
    //   return {"codigopago": codigo};
    // }).toList();

    
    String obtenerCity;
    int? numF;
    Future? incrementNumF;
    int numLp = await countServi.obtenerGetLp();
    int numTro = await countServi.obtenerGetTro();
    int numCocha = await countServi.obtenerGetCocha();
    int numRi = await countServi.obtenerGetRi();
    int numScruz = await countServi.obtenerGetScruz();

    obtenerCity = obtenerDatosPago.unidadAcademica;

    if(obtenerCity == "La Paz"){
      numF = numLp;
    }else if(obtenerCity == "Tropico"){
      numF = numTro;
    }else if(obtenerCity == "Cochabamba"){
      numF = numCocha;
    }else if(obtenerCity == "Riberalta"){
      numF = numRi;
    }else if(obtenerCity == "Santa Cruz"){
      numF = numScruz;
    }

    if (obtenerCity == "La Paz") {
      incrementNumF = countServi.increNumLp();
    }else if(obtenerCity == "Tropico"){
      incrementNumF = countServi.increNumTro();
    }else if(obtenerCity == "Cochabamba"){
      incrementNumF = countServi.increNumCocha();
    }else if(obtenerCity == "Riberalta"){
      incrementNumF = countServi.increNumRi();
    }else if(obtenerCity == "Santa Cruz"){
      incrementNumF = countServi.increNumScruz();
    }

    Map<String, dynamic> data = {
      "cuf": cuf,
      "numero": numF,
      "fechapago": fechaPago,
      "ci": valCi,
      "nit": valNit,
      "razonsocial": valRS,
      "coduni": valCodUni,
      // "cantpagos": obtenerDatosPago.selectedItems.length,
      // "codigopago": mapCog
    };
    print(data);

    final headers = {
      'token': token,
      'Content-Type': 'application/json',
    };

    try {
      final response = await _dio.post(
        'http://test1.emi.edu.bo/pago',
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        incrementNumF;
        // _mostrarDialogo(context, 'Pago exitoso', 'Aceptar', true, (){obtenerDatosPago.listaPagosPendientes.clear();authProvider.logOut(context);obtenerDatosPago.resetData();});
      } else {
        _mostrarDialogo(context, 'Error ${response.statusCode}: ${response.statusMessage}', 'Intentar de nuevo', false,(){context.pop();});
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          if (e.response!.statusCode == 400) {
            _mostrarDialogo(context, 'Solicitud incorrecta', 'Intentar de nuevo', false,(){context.pop();});
          } else if (e.response!.statusCode == 500) {
            _mostrarDialogo(context, 'Error interno del servidor', 'Intentar de nuevo', false,(){context.pop();});
          } else {
            _mostrarDialogo(context, 'Error ${e.response!.statusCode}: ${e.response!.statusMessage}', 'Intentar de nuevo', false,(){context.pop();});
          }
        } else {
          _mostrarDialogo(context, 'Error al enviar los datos: ', 'Intentar de nuevo', false,(){context.pop();});
        }
      } else {
        _mostrarDialogo( context, 'Error al enviar los datos: $e', 'Intentar de nuevo', false,(){context.pop();});
      }
    }
  }

  String _generarCUF() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789*-+-./,?¡¿';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(64, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String _obtenerFechaActual() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  void _mostrarDialogo(BuildContext context, String mensaje, String textoBoton, bool exito, Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(             
              onPressed: onPressed,
              child: Text(textoBoton)              
            ),
          ],
        );
      },
    );
  }
}

