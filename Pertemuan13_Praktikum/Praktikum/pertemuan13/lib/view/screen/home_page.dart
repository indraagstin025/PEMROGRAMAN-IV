import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pertemuan13/model/contact_model.dart';
import 'package:pertemuan13/services/api_services.dart';
import 'package:pertemuan13/services/auth_manager.dart';
import 'package:pertemuan13/view/screen/login_page.dart';
import 'package:pertemuan13/view/widget/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  final ApiServices _dataService = ApiServices();

  List<ContactsModel> _contactMdl = [];
  ContactResponse? ctRes;
  bool isEdit = false;
  String? idContact;
  bool isLoading = false;
  bool isSubmitting = false;
  String _result = '-';

  late SharedPreferences logindata;
  String username = '';
  String token = ''; // Variabel untuk menampung token challenge 

  @override
  void initState() {
    super.initState();
    _ensureLoadingStateReset();
    refreshContactList();
    initial(); // Memanggil inisialisasi SharedPreferences [cite: 337]
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance(); // [cite: 340]
    setState(() {
      username = logindata.getString('username').toString(); // [cite: 342]
      token = logindata.getString('token').toString(); // Mengambil token challenge 
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'), // [cite: 403]
          content: const Text('Anda yakin ingin logout?'), // [cite: 404]
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'), // [cite: 414]
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout(); // [cite: 417]
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()), // [cite: 426]
                    (route) => false,
                  );
                }
              },
              child: const Text('Ya'), // [cite: 428]
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    _dataService.dispose();
    super.dispose();
  }

  Future<void> refreshContactList() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final users = await _dataService.getAllContact();
      if (mounted) {
        setState(() {
          _contactMdl = users.reversed.toList();
          _result = users.isEmpty ? 'Tidak ada data' : '';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = 'Error loading data';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts API'), // [cite: 382]
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context); // [cite: 432]
            },
            icon: const Icon(Icons.logout), // [cite: 387]
          ),
        ],
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
              // Bagian Profil (Username & Token) [cite: 347, 471]
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                color: Colors.tealAccent, // [cite: 350]
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle_rounded), // [cite: 354]
                          const SizedBox(width: 8.0),
                          Text(
                            'Login sebagai: $username', // [cite: 357]
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.teal), // Pemisah visual
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.vpn_key_rounded, size: 20),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Token : $token', // Menampilkan token challenge 
                              style: const TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0), // [cite: 363]

              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama', // [cite: 368]
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 8.0),

              TextFormField(
                controller: _numberCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nomor HP', // [cite: 369]
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 8.0),

              // Tombol POST / UPDATE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => isSubmitting = true);

                            final postModel = ContactInput(
                              namaKontak: _nameCtl.text,
                              nomorHp: _numberCtl.text,
                            );

                            try {
                              if (isEdit) {
                                await _dataService.putContact(
                                  idContact!,
                                  postModel,
                                );
                              } else {
                                await _dataService.postContact(postModel);
                              }
                              _nameCtl.clear();
                              _numberCtl.clear();
                              setState(() => isEdit = false);
                              await refreshContactList();
                            } finally {
                              setState(() => isSubmitting = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isEdit ? 'UPDATE DATA' : 'POST'), // [cite: 370]
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Tombol Refresh Data dan Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshContactList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Refresh Data'), // [cite: 374]
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _nameCtl.clear();
                        _numberCtl.clear();
                        _contactMdl.clear();
                        _result = '-';
                        isEdit = false;
                        ctRes = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reset'), // [cite: 375]
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              const Text(
                'List Contact', // [cite: 376]
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildListContact(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListContact() {
    if (_contactMdl.isEmpty) return Center(child: Text(_result));
    return ListView.builder(
      itemCount: _contactMdl.length,
      itemBuilder: (context, index) {
        final contact = _contactMdl[index];
        return Card(
          child: ListTile(
            title: Text(contact.namaKontak),
            subtitle: Text(contact.nomorHp),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      _nameCtl.text = contact.namaKontak;
                      _numberCtl.text = contact.nomorHp;
                      isEdit = true;
                      idContact = contact.id;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _showDeleteConfirmationDialogContact(contact.id, contact.namaKontak),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialogContact(String id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kontak'),
        content: Text('Yakin ingin menghapus $nama?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await _dataService.deleteContact(id);
              Navigator.pop(context);
              refreshContactList();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _ensureLoadingStateReset() {
    setState(() {
      isLoading = false;
      isSubmitting = false;
    });
  }
}