import 'package:banboostore/services/element_api_service.dart';
import 'package:flutter/material.dart';
import '../../model/banboo.dart';
import '../../services/banboo_api_service.dart';
import '../../utils/constants.dart';
import '../../widgets/background.dart';

class EditBanbooPage extends StatefulWidget {
  const EditBanbooPage({
    Key? key,
    this.banboo,
    required this.onBanbooUpdated
  }) : super(key: key);

  final Banboo? banboo;
  final VoidCallback onBanbooUpdated;

  @override
  State<EditBanbooPage> createState() => _EditBanbooPageState();
}

class _EditBanbooPageState extends State<EditBanbooPage> {
  final ElementApiService _elementApiService = ElementApiService();
  final _formKey = GlobalKey<FormState>();
  final _banbooApiService = BanbooApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _elements = [];
  int? _selectedElementId;

  late TextEditingController _nameController;
  // late TextEditingController _elementController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _levelController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _fetchElements();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.banboo?.name ?? '');
    // _elementController = TextEditingController(text: widget.banboo?.elementId.toString() ?? '');
    _descController = TextEditingController(text: widget.banboo?.description ?? '');
    _priceController = TextEditingController(text: widget.banboo?.price.toString() ?? '0');
    _levelController = TextEditingController(text: widget.banboo?.level.toString() ?? '');
    _imageController = TextEditingController(text: widget.banboo?.imageUrl ?? '');

    _selectedElementId = widget.banboo?.elementId;
  }

  Future<void> _fetchElements() async {
    try {
      final elements = await _elementApiService.getElements();
      setState(() {
        _elements = elements;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch elements: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildElementDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(

        decoration: InputDecoration(
          labelText: 'Element',

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: _selectedElementId,
        hint: const Text('Select Element'),
        items: _elements.map((element) {
          return DropdownMenuItem<int>(
            value: element['elementId'],
            child: Row(
              children: [
                Image.network(
                  element['elementIcon'],
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Text(" ~ ${element['name']}"),
              ],
            )

          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedElementId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select an element';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final element = _selectedElementId;
      // final element = int.parse(_elementController.text.trim());
      final description = _descController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final level = int.parse(_levelController.text.trim());
      final imageUrl = _imageController.text.trim();

      final Map<String, dynamic> response;
      final isEditing = widget.banboo != null;

      if (isEditing) {
        response = await _banbooApiService.updateBanboo(
          context: context,
          id: widget.banboo!.banbooId,
          name: name,
          price: price,
          description: description,
          elementId: element!,
          level: level,
          imageUrl: imageUrl,
        );
      } else {
        response = await _banbooApiService.createBanboo(
          context: context,
          name: name,
          price: price,
          description: description,
          elementId: element!,
          level: level,
          imageUrl: imageUrl,
        );
      }

      if (response['status'] == "success") {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
        widget.onBanbooUpdated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation failed: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Operation failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.banboo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Bamboo' : 'Add New Bamboo'),
        backgroundColor: AppColors.backgroundCardColor,
      ),
      body: Stack(
        children: [
          const Background(
            imageUrl:
            "https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white.withOpacity(0.8),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    height: 300,
                    child: Image.network(
                      _imageController.text,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),

                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                  ),
                  _buildElementDropdown(),
                  _buildTextField(
                    controller: _descController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Price';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _levelController,
                    label: 'Level',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Level';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _imageController,
                    label: 'Image URL',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(isEditing ? 'Update' : 'Add', style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    //_elementController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _levelController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}