import 'package:flutter/material.dart';
import 'package:pagos_en_linea_emi/config/theme/extension_theme.dart';
import 'package:pagos_en_linea_emi/presentation/providers/auth_provider.dart';
import 'package:pagos_en_linea_emi/presentation/providers/buscar_estudiante_provider1.dart';
import 'package:pagos_en_linea_emi/presentation/providers/fetch_data_pagos.dart';
import 'package:pagos_en_linea_emi/presentation/providers/theme_provider.dart';
import 'package:pagos_en_linea_emi/presentation/screens/payment_method_screen/pago_de_cuentas_screen.dart';
import 'package:pagos_en_linea_emi/utils/asset_image_app.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.broadSpacing,
    required this.letterSize,
    required this.imgSize,
    required this.smallSpacing,
    required this.obtenerDataPagos,
    required this.themeProvider,
    required this.authProvider,
  });

  final double broadSpacing;
  final double letterSize;
  final double imgSize;
  final double smallSpacing;
  final FetchDataPagosProvider obtenerDataPagos;
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: broadSpacing * 27,
              child: Text(
                'PAGOS EN LINEA EMI',
                style: TextStyle(
                  fontSize: letterSize * 0.03,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Image.asset(AssetImageApp.getLogo, width: imgSize *0.5),
          ],
        ),   
        SizedBox(
          height: smallSpacing,
        ),
        Text(
          'Paga tus cuentas',
          style: TextStyle(
            letterSpacing: 0.2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: letterSize * 0.02,
          ),
        ),
        SizedBox(
          height: smallSpacing,
        ),
        Row(
          children: [
            Text(
              'Detalles de tu cuenta',
              style: TextStyle(
                letterSpacing: 0.2,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: letterSize * 0.02,
              ),
            ),
            const Spacer(),
            Consumer<FetchDataPagosProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  // onPressed: provider.hasSelectedItems
                  //     ? () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => PagoCuentasScreen(
                  //               totalMonto: provider.totalMonto,
                  //               selectedItems: [],
                  //               totalDescuento: provider.totalDescuento,
                  //               monto: provider.monto,
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     : null,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    obtenerDataPagos.pagar(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PagoCuentasScreen(
                          //       totalMonto: provider.totalMonto,
                          //       selectedItems: [],
                          //       totalDescuento: provider.totalDescuento,
                          //       monto: provider.monto,
                          //     ),
                          //   ),
                          // );
                        },
                  child: Text('Pagar', style: TextStyle(color: Colors.white, fontSize: letterSize * 0.018),),
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: smallSpacing,
        ),
        Row(
          children: [
            Text(
              'Detalle:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: letterSize * 0.016,
              ),
            ),
            SizedBox(
              width: broadSpacing,
            ),
            Text('Ciencias Basicas|', style: TextStyle(fontSize: letterSize * 0.016),),
            Text(
              obtenerDataPagos.unidadAcademica,
              style: TextStyle(fontSize: letterSize * 0.016),
            ),
          ],
        ),
        SizedBox(
          height: smallSpacing,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'CI:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: letterSize * 0.016,
              ),
            ),
            SizedBox(
              width: broadSpacing,
            ),
            Text(
              obtenerDataPagos.ci,
              style: TextStyle(fontSize: letterSize * 0.016),
            ),
            SizedBox(
              width: broadSpacing * 5,
            ),
            Text(
              'Nombre:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: letterSize *0.016,
              ),
            ),
            SizedBox(
              width: broadSpacing,
            ),
            Text(
              obtenerDataPagos.nombres,
              style: TextStyle(fontSize: letterSize * 0.016),
            ),
          ],
        ),
      ],
    );
  }
}
