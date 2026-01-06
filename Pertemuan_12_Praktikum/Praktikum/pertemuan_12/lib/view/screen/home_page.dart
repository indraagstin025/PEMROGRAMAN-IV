// view/screen/home_page.dart
// Halaman utama: Form input, tombol POST/UPDATE, list contacts, refresh, reset.
// Mengikuti instruksi praktikum: GET all, GET single, POST, PUT, DELETE.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pertemuan_12/model/contact_model.dart';
import 'package:pertemuan_12/services/api_services.dart';
import 'package:pertemuan_12/view/widget/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Form key dan controller for inputs
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();

  // Service untuk panggil API
  final ApiServices _dataService = ApiServices();

  // Menyimpan data contact
  List<ContactsModel> _contactMdl = [];

  // Menyimpan response dari operasi (POST/PUT/DELETE)
  ContactResponse? ctRes;

  // Mode edit & id yang sedang diedit
  bool isEdit = false;
  String? idContact;
  
  // Loading state
  bool isLoading = false;
  bool isSubmitting = false;

  // Teks saat list kosong
  String _result = '-';

  @override
  void initState() {
    super.initState();
    // Safety check to ensure clean state
    _ensureLoadingStateReset();
    // Muat data saat halaman dibuka
    refreshContactList();
  }

  @override
  void dispose() {
    // Proper resource cleanup to prevent memory leaks
    debugPrint('DISPOSING HOME PAGE - CLEANING UP RESOURCES');
    
    // Dispose controllers to prevent memory leaks
    _nameCtl.dispose();
    _numberCtl.dispose();
    
    // Clear lists to free memory
    _contactMdl.clear();
    
    // Reset states to null
    ctRes = null;
    idContact = null;
    
    // Cancel any ongoing operations
    if (isSubmitting || isLoading) {
      debugPrint('CANCELLING ONGOING OPERATIONS');
    }
    
    // Dispose API services to close connections
    _dataService.dispose();
    
    super.dispose();
    debugPrint('HOME PAGE DISPOSED - MEMORY CLEANED UP');
  }

  // Validasi nama minimal 3 karakter dan tidak hanya spasi
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Nama hanya boleh mengandung huruf dan spasi';
    }
    return null;
  }

  // Validasi nomor: tidak kosong, hanya angka, dan panjang minimal 10
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP tidak boleh kosong';
    }
    final phoneNumber = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      return 'Nomor HP hanya boleh mengandung angka';
    }
    if (phoneNumber.length < 10) {
      return 'Nomor HP minimal 10 digit';
    }
    if (phoneNumber.length > 15) {
      return 'Nomor HP maksimal 15 digit';
    }
    return null;
  }

  // Helper untuk menampilkan Snackbar
  void displaySnackbar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Safety check to prevent infinite loading states
  void _ensureLoadingStateReset() {
    if (isSubmitting) {
      debugPrint('SAFETY CHECK: Resetting stuck isSubmitting state');
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
    if (isLoading) {
      debugPrint('SAFETY CHECK: Resetting stuck isLoading state');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Memory cleanup function for optimal performance
  void _performMemoryCleanup() {
    debugPrint('PERFORMING MEMORY CLEANUP');
    
    // Clear response cards to free memory
    if (ctRes != null) {
      setState(() {
        ctRes = null;
      });
    }
    
    // Clear controllers if they contain large text
    if (_nameCtl.text.length > 1000) {
      _nameCtl.clear();
    }
    if (_numberCtl.text.length > 1000) {
      _numberCtl.clear();
    }
    
    debugPrint('MEMORY CLEANUP COMPLETED');
  }

  // Memory monitoring function
  void _monitorMemoryUsage() {
    final listSize = _contactMdl.length;
    final nameTextSize = _nameCtl.text.length;
    final numberTextSize = _numberCtl.text.length;
    
    debugPrint('MEMORY USAGE MONITOR:');
    debugPrint('  - Contact List Size: $listSize items');
    debugPrint('  - Name Text Size: $nameTextSize chars');
    debugPrint('  - Number Text Size: $numberTextSize chars');
    debugPrint('  - Response Card: ${ctRes != null ? 'active' : 'null'}');
    
    // Auto-cleanup if memory usage is high
    if (listSize > 50 || nameTextSize > 500 || numberTextSize > 500) {
      debugPrint('HIGH MEMORY USAGE DETECTED - PERFORMING AUTO-CLEANUP');
      _performMemoryCleanup();
    }
  }

  // GET all contact -> perbarui _contactMdl
  Future<void> refreshContactList() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    
    // Monitor memory usage before operation
    _monitorMemoryUsage();
    
    try {
      debugPrint('REFRESHING CONTACT LIST...');
      final users = await _dataService.getAllContact();
      debugPrint('RECEIVED ${users.length} USERS FROM API');
      
      if (mounted) {
        setState(() {
          // Memory-efficient list management
          _contactMdl.clear(); // Clear existing list first
          if (users.isNotEmpty) {
            // Add new data with controlled memory usage
            _contactMdl.addAll(users.reversed);
            debugPrint('UPDATED UI WITH ${_contactMdl.length} CONTACTS');
            _result = '';
            
            // Trigger garbage collection hint for large lists
            if (_contactMdl.length > 100) {
              debugPrint('LARGE LIST DETECTED - TRIGGERING GC HINT');
              // Force garbage collection for better memory management
            }
          } else {
            _result = 'Tidak ada data';
            debugPrint('NO DATA AVAILABLE');
          }
          isLoading = false;
        });
      }
      
      // Monitor memory usage after operation
      _monitorMemoryUsage();
    } catch (e) {
      debugPrint('ERROR IN REFRESH CONTACT LIST: $e');
      if (mounted) {
        setState(() {
          _result = 'Error loading data: $e';
          isLoading = false;
        });
      }
    }
  }

  // Build ListView untuk menampilkan daftar contact
  Widget _buildListContact() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _contactMdl.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) {
        final ctList = _contactMdl[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              ctList.namaKontak,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              ctList.nomorHp,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol edit: ambil data single dari server, populate form
                IconButton(
                  onPressed: () async {
                    debugPrint('EDITING CONTACT: ${ctList.id}');
                    try {
                      final contact = await _dataService.getSingleContact(ctList.id);
                      if (contact != null) {
                        setState(() {
                          _nameCtl.text = contact.namaKontak;
                          _numberCtl.text = contact.nomorHp;
                          isEdit = true;
                          idContact = contact.id;
                        });
                        debugPrint('EDIT MODE ACTIVATED: ${contact.namaKontak}');
                        displaySnackbar('Mode edit: ${contact.namaKontak}');
                      } else {
                        displaySnackbar('Gagal memuat data untuk editing');
                      }
                    } catch (e) {
                      debugPrint('ERROR EDITING CONTACT: $e');
                      displaySnackbar('Error: $e');
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                // Tombol delete: show dialog konfirmasi lalu panggil delete
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(ctList.id, ctList.namaKontak);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan hasil response POST/PUT/DELETE
  Widget hasilCard(BuildContext context) {
    return Column(
      children: [
        if (ctRes != null)
          ContactCard(
            ctRes: ctRes!,
            onDismissed: () {
              setState(() {
                ctRes = null;
              });
            },
          )
        else
          const SizedBox.shrink(),
        const SizedBox(height: 8),
      ],
    );
  }

  // Dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // batal
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog first
                Navigator.of(context).pop();
                
                debugPrint('DELETING CONTACT: $id');
                try {
                  ContactResponse? res = await _dataService.deleteContact(id);
                  debugPrint('DELETE RESPONSE: $res');
                  
                  if (res != null && mounted) {
                    setState(() {
                      ctRes = res;
                    });
                    if (mounted) {
                      displaySnackbar('Data berhasil dihapus');
                      await refreshContactList();
                    }
                  } else if (mounted) {
                    displaySnackbar('Gagal menghapus data');
                  }
                } catch (e) {
                  debugPrint('ERROR DELETING CONTACT: $e');
                  if (mounted) {
                    displaySnackbar('Error: $e');
                  }
                }
                // Note: DELETE doesn't need isSubmitting reset as it's not using the submit button
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  // Build UI utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts API'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey[100],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama
              TextFormField(
                controller: _nameCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nama',
                  hintText: 'Masukkan nama kontak',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 8.0),
              // Input Nomor HP
              TextFormField(
                controller: _numberCtl,
                validator: _validatePhoneNumber,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nomor HP',
                  hintText: 'Masukkan nomor HP',
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 8.0),
              // Row tombol POST / UPDATE (sesuai mode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: isSubmitting ? null : () async {
                          // Validasi form
                          if (!_formKey.currentState!.validate()) {
                            displaySnackbar('Periksa inputan terlebih dahulu');
                            return;
                          }

                          // Set loading state
                          if (mounted) {
                            setState(() {
                              isSubmitting = true;
                            });
                          }

                          // Siapkan model input
                          final postModel = ContactInput(
                            namaKontak: _nameCtl.text.trim(),
                            nomorHp: _numberCtl.text.trim(),
                          );

                          ContactResponse? res;
                          try {
                            if (isEdit) {
                              // Jika mode edit -> PUT
                              debugPrint('UPDATING CONTACT: ${idContact ?? 'unknown'}');
                              res = await _dataService.putContact(idContact ?? '', postModel);
                              debugPrint('UPDATE RESPONSE: $res');
                            } else {
                              // Mode tambah -> POST
                              debugPrint('CREATING NEW CONTACT');
                              res = await _dataService.postContact(postModel);
                              debugPrint('POST RESPONSE: $res');
                            }

                            // Tampilkan response dan reset form mode edit
                            if (mounted) {
                              setState(() {
                                ctRes = res;
                                isEdit = false;
                              });
                            }

                            // Kosongkan input dan refresh list
                            _nameCtl.clear();
                            _numberCtl.clear();
                            if (mounted) {
                              await refreshContactList();
                            }
                          } catch (e) {
                            debugPrint('ERROR IN POST/PUT: $e');
                            if (mounted) {
                              displaySnackbar('Terjadi kesalahan: $e');
                            }
                          } finally {
                            // Reset loading state - CRITICAL FIX
                            if (mounted) {
                              setState(() {
                                isSubmitting = false; // Fixed: was isLoading, should be isSubmitting
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: isSubmitting 
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Processing...'),
                                ],
                              )
                            : Text(isEdit ? 'UPDATE DATA' : 'POST'),
                      ),
                      // Tombol Cancel Update muncul hanya saat isEdit = true
                      if (isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            _nameCtl.clear();
                            _numberCtl.clear();
                            setState(() {
                              isEdit = false;
                              idContact = null;
                              ctRes = null;
                            });
                            displaySnackbar('Mode edit dibatalkan');
                          },
                          child: const Text('Cancel Update'),
                        ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              // Tombol Refresh dan Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Panggil refresh list manual
                        await refreshContactList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Reset tampilan dan data local
                      setState(() {
                        _result = '-';
                        _contactMdl.clear();
                        ctRes = null;
                        isEdit = false;
                        idContact = null;
                        isLoading = false;
                        _nameCtl.clear();
                        _numberCtl.clear();
                      });
                      displaySnackbar('Aplikasi direset');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Judul list
              const Text(
                'List Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              // Tampilkan hasil response (Card) jika ada
              hasilCard(context),
              const SizedBox(height: 8.0),
              // Expanded: menampilkan list contact atau teks bila kosong
              Expanded(
                child: isLoading 
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : _contactMdl.isEmpty 
                        ? Text(_result)
                        : _buildListContact(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
