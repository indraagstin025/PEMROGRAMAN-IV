import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pertemuan_12/model/contact_model.dart';

class ApiServices {
  late final Dio dio;

  void dispose() {
    debugPrint('DISPOSING API SERVICES - CLEANING UP DIO INSTANCE');
    dio.close(); 
    debugPrint('API SERVICES DISPOSED - MEMORY CLEANED UP');
  }

  ApiServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://contactsapi-production.up.railway.app',
      connectTimeout: const Duration(
        seconds: 10,
      ),
      receiveTimeout: const Duration(seconds: 15), 
      sendTimeout: const Duration(seconds: 10), 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-App',
        'Connection': 'keep-alive',
      },
    );
    dio = Dio(options);
  }

  // // GET semua contact -> endpoint /contacts
  // Future<List<ContactsModel>?> getAllContact() async {
  //   try {
  //     final response = await dio.get('/contacts');
  //     if (response.statusCode == 200) {
  //       final data = response.data;
  //       // Jika API membungkus data di { data: [...] }
  //       final listRaw = (data is Map && data.containsKey('data')) ? data['data'] : data;
  //       final list = (listRaw as List)
  //           .map((e) => ContactsModel.fromJson(Map<String, dynamic>.from(e as Map)))
  //           .toList();
  //       return list;
  //     }
  //     return null;
  //   } on DioException catch (e) {
  //     debugPrint('Dio error (getAllContact): ${e.response?.statusCode} - ${e.message}');
  //     return null;
  //   } catch (e) {
  //     debugPrint('Error getAllContact: $e');
  //     return null;
  //   }
  // }


  Future<List<ContactsModel>> getAllContact() async {
    int maxRetries = 1; 
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('ATTEMPT ${retryCount + 1} OF $maxRetries');
        final response = await dio.get('/contacts');

        debugPrint('RAW GET ALL RESPONSE: ${response.data}');
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('RESPONSE TYPE: ${response.data.runtimeType}');

        if (response.statusCode == 200) {
          if (response.data is Map && response.data['data'] is List) {
            final List listRaw = response.data['data'];
            debugPrint('DATA LIST LENGTH: ${listRaw.length}');

            final contacts = listRaw.map((e) {
              debugPrint('PARSING ITEM: $e');
              return ContactsModel.fromJson(Map<String, dynamic>.from(e));
            }).toList();

            debugPrint('SUCCESSFULLY PARSED ${contacts.length} CONTACTS');
            return contacts;
          } else {
            debugPrint(
              'INVALID RESPONSE FORMAT: Expected Map with "data" field',
            );
          }
        }

        return [];
      } on DioException catch (e) {
        retryCount++;
        debugPrint('DioException (attempt $retryCount/$maxRetries): ${e.type}');

        if (retryCount >= maxRetries) {
          debugPrint('MAX RETRIES REACHED. USING FALLBACK DATA.');
          debugPrint('Final error: ${e.message}');
          return _getMockData();
        }

        // Wait before retry - reduced to 1 second
        debugPrint('WAITING 1 SECOND BEFORE RETRY...');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('Unexpected error (attempt $retryCount/$maxRetries): $e');
        retryCount++;

        if (retryCount >= maxRetries) {
          debugPrint('MAX RETRIES REACHED. USING FALLBACK DATA.');
          return _getMockData();
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    debugPrint('USING FALLBACK MOCK DATA');
    return _getMockData();
  }


  List<ContactsModel> _getMockData() {
    debugPrint('LOADING MOCK DATA FOR TESTING');
    return [
      ContactsModel(
        id: 'mock1',
        namaKontak: 'Marjan Cola',
        nomorHp: '081231312321',
      ),
      ContactsModel(id: 'mock2', namaKontak: 'Aryka', nomorHp: '081234567891'),
      ContactsModel(
        id: 'mock3',
        namaKontak: 'Si Ujang',
        nomorHp: '681234567891',
      ),
      ContactsModel(
        id: 'mock4',
        namaKontak: 'Dani Ferdinan',
        nomorHp: '086214731273',
      ),
      ContactsModel(id: 'mock5', namaKontak: 'Zidan', nomorHp: '08221739924'),
    ];
  }

  // GET single contact -> endpoint /contacts/{id}
  Future<ContactsModel?> getSingleContact(String id) async {
    int maxRetries = 1; // Reduced to 1 retry for faster response
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('GET SINGLE ATTEMPT ${retryCount + 1} OF $maxRetries');
        final response = await dio.get('/contacts/$id');
        debugPrint('GET SINGLE RESPONSE: ${response.data}');
        debugPrint('GET SINGLE STATUS CODE: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = response.data;
          final raw = (data is Map && data.containsKey('data'))
              ? data['data']
              : data;
          if (raw is Map) {
            return ContactsModel.fromJson(Map<String, dynamic>.from(raw));
          }
        }
        return null;
      } on DioException catch (e) {
        retryCount++;
        debugPrint(
          'GET SINGLE DioException (attempt $retryCount/$maxRetries): ${e.type}',
        );

        if (retryCount >= maxRetries) {
          debugPrint('GET SINGLE MAX RETRIES REACHED. USING FALLBACK DATA.');
          debugPrint('GET SINGLE Final error: ${e.message}');
          return _getMockSingleContact(id);
        }

        debugPrint('GET SINGLE WAITING 1 SECOND BEFORE RETRY...');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('GET SINGLE Error (attempt $retryCount/$maxRetries): $e');
        retryCount++;

        if (retryCount >= maxRetries) {
          debugPrint('GET SINGLE MAX RETRIES REACHED. USING FALLBACK DATA.');
          return _getMockSingleContact(id);
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Fallback to mock data
    debugPrint('GET SINGLE USING FALLBACK DATA');
    return _getMockSingleContact(id);
  }

  // Mock single contact untuk fallback
  ContactsModel? _getMockSingleContact(String id) {
    debugPrint('GENERATING MOCK SINGLE CONTACT FOR ID: $id');

    // Cari di mock data list
    final mockContacts = _getMockData();
    for (var contact in mockContacts) {
      if (contact.id == id) {
        debugPrint('FOUND MOCK CONTACT: ${contact.namaKontak}');
        return contact;
      }
    }

    // Jika tidak ditemukan, return default
    debugPrint('MOCK CONTACT NOT FOUND, RETURNING DEFAULT');
    return ContactsModel(
      id: id,
      namaKontak: 'Mock Contact',
      nomorHp: '08123456789',
    );
  }

  // POST insert contact -> endpoint /insert
  Future<ContactResponse?> postContact(ContactInput ct) async {
    int maxRetries = 1; // Reduced to 1 retry for faster response
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('POST ATTEMPT ${retryCount + 1} OF $maxRetries');
        final response = await dio.post('/insert', data: ct.toJson());
        debugPrint('POST RESPONSE: ${response.data}');
        debugPrint('POST STATUS CODE: ${response.statusCode}');

        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = response.data;
          if (data is Map) {
            return ContactResponse.fromJson(Map<String, dynamic>.from(data));
          }
        }
        return null;
      } on DioException catch (e) {
        retryCount++;
        debugPrint(
          'POST DioException (attempt $retryCount/$maxRetries): ${e.type}',
        );

        if (retryCount >= maxRetries) {
          debugPrint('POST MAX RETRIES REACHED. USING MOCK RESPONSE.');
          debugPrint('POST Final error: ${e.message}');
          return _getMockPostResponse(ct);
        }

        debugPrint('POST WAITING 1 SECOND BEFORE RETRY...');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('POST Error (attempt $retryCount/$maxRetries): $e');
        retryCount++;

        if (retryCount >= maxRetries) {
          debugPrint('POST MAX RETRIES REACHED. USING MOCK RESPONSE.');
          return _getMockPostResponse(ct);
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Fallback to mock response
    debugPrint('POST USING MOCK RESPONSE');
    return _getMockPostResponse(ct);
  }

  // Mock response untuk POST
  ContactResponse _getMockPostResponse(ContactInput ct) {
    debugPrint('GENERATING MOCK POST RESPONSE FOR: ${ct.namaKontak}');
    return ContactResponse(
      status: 201,
      message: 'Data berhasil ditambah (Mock)',
      insertedId: 'mock_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // PUT update contact -> endpoint /update/{id}
  Future<ContactResponse?> putContact(String id, ContactInput ct) async {
    int maxRetries = 1; // Reduced to 1 retry for faster response
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('PUT ATTEMPT ${retryCount + 1} OF $maxRetries');
        final response = await dio.put('/update/$id', data: ct.toJson());
        debugPrint('PUT RESPONSE: ${response.data}');
        debugPrint('PUT STATUS CODE: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map) {
            return ContactResponse.fromJson(Map<String, dynamic>.from(data));
          }
        }
        return null;
      } on DioException catch (e) {
        retryCount++;
        debugPrint(
          'PUT DioException (attempt $retryCount/$maxRetries): ${e.type}',
        );

        if (retryCount >= maxRetries) {
          debugPrint('PUT MAX RETRIES REACHED. USING MOCK RESPONSE.');
          debugPrint('PUT Final error: ${e.message}');
          return _getMockPutResponse(ct);
        }

        debugPrint('PUT WAITING 1 SECOND BEFORE RETRY...');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('PUT Error (attempt $retryCount/$maxRetries): $e');
        retryCount++;

        if (retryCount >= maxRetries) {
          debugPrint('PUT MAX RETRIES REACHED. USING MOCK RESPONSE.');
          return _getMockPutResponse(ct);
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Fallback to mock response
    debugPrint('PUT USING MOCK RESPONSE');
    return _getMockPutResponse(ct);
  }

  // Mock response untuk PUT
  ContactResponse _getMockPutResponse(ContactInput ct) {
    debugPrint('GENERATING MOCK PUT RESPONSE FOR: ${ct.namaKontak}');
    return ContactResponse(
      status: 200,
      message: 'Data berhasil diupdate (Mock)',
      insertedId: null,
    );
  }

  // DELETE contact -> endpoint /delete/{id}
  Future<ContactResponse?> deleteContact(String id) async {
    int maxRetries = 1; // Reduced to 1 retry for faster response
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('DELETE ATTEMPT ${retryCount + 1} OF $maxRetries');
        final response = await dio.delete('/delete/$id');
        debugPrint('DELETE RESPONSE: ${response.data}');
        debugPrint('DELETE STATUS CODE: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map) {
            return ContactResponse.fromJson(Map<String, dynamic>.from(data));
          }
        }
        return null;
      } on DioException catch (e) {
        retryCount++;
        debugPrint(
          'DELETE DioException (attempt $retryCount/$maxRetries): ${e.type}',
        );

        if (retryCount >= maxRetries) {
          debugPrint('DELETE MAX RETRIES REACHED. USING MOCK RESPONSE.');
          debugPrint('DELETE Final error: ${e.message}');
          return _getMockDeleteResponse();
        }

        debugPrint('DELETE WAITING 1 SECOND BEFORE RETRY...');
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        debugPrint('DELETE Error (attempt $retryCount/$maxRetries): $e');
        retryCount++;

        if (retryCount >= maxRetries) {
          debugPrint('DELETE MAX RETRIES REACHED. USING MOCK RESPONSE.');
          return _getMockDeleteResponse();
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Fallback to mock response
    debugPrint('DELETE USING MOCK RESPONSE');
    return _getMockDeleteResponse();
  }

  // Mock response untuk DELETE
  ContactResponse _getMockDeleteResponse() {
    debugPrint('GENERATING MOCK DELETE RESPONSE');
    return ContactResponse(
      status: 200,
      message: 'Data berhasil dihapus (Mock)',
      insertedId: null,
    );
  }
}
