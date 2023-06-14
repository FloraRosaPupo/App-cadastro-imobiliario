//import 'dart:io';

// ignore_for_file: unused_import, unused_field

import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projeto_prefeitura/functions.dart';
import 'package:projeto_prefeitura/main.dart';

import 'package:flutter/material.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/previewpage.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';

import 'package:camera_camera/camera_camera.dart';

class Imovel extends StatefulWidget {
  const Imovel({super.key});

  @override
  State<Imovel> createState() => _ImovelState();
}

class _ImovelState extends State<Imovel> {
  late File arquivo;

  showPreview(file) async {
    file = await Get.to(() => PreviewPage(file: file));

    if (file != null) {
      setState(() => arquivo = file);
      Get.back();
    }
  }

  DateFormat formatter = DateFormat('dd/MM/yyyy');
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();

  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      drawer: menuLateralDinamico(),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 25, right: 25),
        color: Colors.transparent,
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.access_time_filled,
                  color: Colors.black54,
                  size: 20,
                ),
                Text(
                  '08:00',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.date_range_rounded, color: Colors.black54, size: 20),
                Text(
                  '12/12/2022',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromARGB(191, 18, 108, 133),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 270, //colocando espaçamento
                    ),
                    Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Inscrição SIAT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '1234567',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Espacamento10(),
                    ]),
                    SizedBox(
                      width: 200,
                    ),
                    Column(
                      children: [
                        Espacamento10(),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.copy_outlined,
                              color: Colors.white,
                              size: 20,
                            )),
                      ],
                    )
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              'Dados pessoais do Contribuinte',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5, //colocando espaçamento
            ),
            Text(
              'Preencha os dados ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
            SizedBox(
              height: 10, //colocando espaçamento
            ),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Nome:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(190, 7, 62, 77),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.black38,
                    )),
              ),
            ),
            Espacamento10(),
            TextField(
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelText: "CPF/CNPJ:",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  focusedBorder: FocusedBorder(),
                  enabledBorder: EnableBorder(),
                ),
                keyboardType: TextInputType.number),
            Espacamento10(),
            TextField(
                style: TextStyle(
                  fontSize: 20,
                ),
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Data de Nascimento:",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                  ),
                  focusedBorder: FocusedBorder(),
                  enabledBorder: EnableBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    dateController.text = formattedDate.toString();
                  }
                }),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Telefone:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: 20, //colocando espaçamento
            ),
            Text(
              'Endereço do Imóvel Cadastrado',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Logadouro:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Número da Casa:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Quarteirão:",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Número de pavimentos",
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Caracterização',
                labelStyle: TextStyle(color: Colors.black38),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.black12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownPiso(),
                  SizedBox(
                    width: 50,
                  ),
                  DropdownCobertura(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Observação sobre o proprietário/a',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            Espacamento10(),
            TextField(
              style: TextStyle(
                fontSize: 20,
              ),
              maxLines: 10,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                focusedBorder: FocusedBorder(),
                enabledBorder: EnableBorder(),
              ),
            ),
            Espacamento10(),
            Row(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Color.fromARGB(221, 0, 0, 0),
                      primary: Color.fromARGB(255, 255, 255, 255),
                      minimumSize: Size(150, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => Get.to(
                      () => CameraCamera(onFile: (file) => showPreview(file)),
                    ),
                    label: Text('Tire uma foto'),
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Espacamento10(),
            ElevatedButton.icon(
              style: raisedButtonStyle,
              onPressed: () {},
              label: Text('Salvar'),
              icon: Icon(Icons.save),
            ),
            Espacamento10(),
          ],
        ),
      ),
    );
  }
}
