import 'dart:convert';

import 'package:app_loja_virtual/models/cepaberto_address.dart';
import 'package:http/http.dart';
import 'package:app_loja_virtual/helpers/logger.dart';

const token = 'Token token=456eaaac3b9d5f6877328ad68e9743c6';
const urlCEP = 'https://www.cepaberto.com/api/v3/cep?cep=71100029';

class CepAbertoService {

  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    //Pass headers below
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    final Uri _uri = Uri.parse('https://www.cepaberto.com/api/v3/cep?cep=$cleanCep');

    Response response = await get(_uri, headers: {"Authorization": token});

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 400) {
      logger.e('erro ao obter CEP');
    }
    var json = jsonDecode(response.body) as Map<String, dynamic>;

    final CepAbertoAddress address = CepAbertoAddress.fromMap(json);
    return address;
  }

}
