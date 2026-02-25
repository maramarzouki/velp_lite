import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/features/home/data/entity/pet_entity.dart';
import 'package:velp_lite/core/providers/pet_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/core/validators/validators.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _addPetFormKey = GlobalKey<FormState>();

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _chipNumberController = TextEditingController();

  String? _selectedSpecies;
  String? _selectedGender;
  DateTime? _birthDate;
  String birthDateError = '';
  
  late FocusNode _birthDateFocusNode;

  final List<String> _species = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];
  final List<String> _genders = ['Male', 'Female'];

  
  @override
  void initState() {
    super.initState();
    _birthDateFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _chipNumberController.dispose();
    _birthDateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        birthDateError = '';
      });
    }
  }

  Future<void> _savePet() async {
    final userID = ref.read(userViewModelProvider).value!.id;
    debugPrint('userID from add pet screen: $userID');
    // if (_birthDate == null) {
    //   setState(() {
    //     birthDateError = 'Birth date is required!';
    //   });
    // }
    if (_addPetFormKey.currentState!.validate()) {
      PetEntity petEntity = PetEntity(
        name: _nameController.text,
        species: _selectedSpecies!,
        breed: _breedController.text,
        birthDate: _birthDate!,
        gender: _selectedGender!,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        color: _colorController.text,
        chipNumber: _chipNumberController.text,
        userID: userID!,
      );

      ref.read(petViewModelProvider(userID).notifier).addPet(petEntity);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pet added successfully')));

      _addPetFormKey.currentState!.reset();
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: .9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Pet',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Fill in your pet\'s information',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              // Form
              Expanded(
                child: Form(
                  key: _addPetFormKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet Avatar Selection
                        // Center(
                        //   child: Container(
                        //     width: 120,
                        //     height: 120,
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topLeft,
                        //         end: Alignment.bottomRight,
                        //         colors: [
                        //           AppColors.accent.withValues(alpha: .3),
                        //           AppColors.accent.withValues(alpha: .1),
                        //         ],
                        //       ),
                        //       shape: BoxShape.circle,
                        //       border: Border.all(
                        //         color: AppColors.accent,
                        //         width: 3,
                        //       ),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: AppColors.accent.withValues(alpha: .3),
                        //           blurRadius: 16,
                        //           offset: const Offset(0, 4),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         _selectedEmoji,
                        //         style: const TextStyle(fontSize: 70),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 24),
      
                        // Name Field
                        _buildSectionLabel('Pet Name *'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'e.g., Luna, Max, Bella',
                          icon: Icons.pets,
                        ),
                        const SizedBox(height: 20),
      
                        // Species Dropdown
                        _buildSectionLabel('Species *'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _selectedSpecies,
                          hint: 'Select species',
                          icon: Icons.category_outlined,
                          items: _species,
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecies = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
      
                        // Breed Field
                        _buildSectionLabel('Breed *'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _breedController,
                          hintText: 'e.g., Golden Retriever',
                          icon: Icons.palette_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter breed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
      
                        // Birth Date
                        _buildSectionLabel('Birth Date *'),
                        const SizedBox(height: 8),
      
                        // InkWell(
                        //   onTap: () => _selectBirthDate(context),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(16),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.white,
                        //       borderRadius: BorderRadius.circular(16),
                        //       border: Border.all(
                        //         color: AppColors.background,
                        //         width: 2,
                        //       ),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.calendar_today_outlined,
                        //           color: AppColors.accent,
                        //           size: 20,
                        //         ),
                        //         const SizedBox(width: 12),
                        //         Expanded(
                        //           child: Text(
                        //             _birthDate == null
                        //                 ? 'Select birth date'
                        //                 : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                        //             style: TextStyle(
                        //               color: _birthDate == null
                        //                   ? AppColors.lightText
                        //                   : AppColors.text,
                        //               fontSize: 16,
                        //             ),
                        //           ),
                        //         ),
                        //         Icon(
                        //           Icons.arrow_forward_ios,
                        //           color: AppColors.lightText,
                        //           size: 16,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // if (birthDateError.isNotEmpty)
                        //   Text(
                        //     birthDateError,
                        //     style: TextStyle(
                        //       color: Theme.of(context).colorScheme.error,
                        //       fontSize: 12,
                        //     ),
                        //   ),
                        // const SizedBox(height: 20),
                        const SizedBox(height: 8),
                        FormField<DateTime>(
                          validator: (_) => _birthDate == null
                              ? 'Birth date is required!'
                              : null,
                          builder: (field) {
                            final isFocused = _birthDateFocusNode.hasFocus;
                            return InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.background,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.accent,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.secondary,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.secondary,
                                    width: 2,
                                  ),
                                ),
                                errorText: field.errorText,
                              ),
                              isEmpty: _birthDate == null,
                              isFocused: isFocused,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  // give visual focus
                                  _birthDateFocusNode.requestFocus();
      
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _birthDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColors.primary,
                                            onPrimary: AppColors.white,
                                            onSurface: AppColors.text,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
      
                                  // remove focus visual
                                  _birthDateFocusNode.unfocus();
      
                                  if (picked != null) {
                                    setState(() {
                                      _birthDate = picked;
                                    });
                                    field.didChange(
                                      picked,
                                    ); // notify FormField so validation clears
                                  } else {
                                    // if you want to revalidate when user cancels:
                                    field.validate();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _birthDate == null
                                              ? 'Select birth date'
                                              : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                                          style: TextStyle(
                                            color: _birthDate == null
                                                ? AppColors.lightText
                                                : AppColors.text,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.lightText,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // Gender Dropdown
                        _buildSectionLabel('Gender *'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _selectedGender,
                          hint: 'Select gender',
                          icon: Icons.male,
                          items: _genders,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
      
                        // Weight Field
                        _buildSectionLabel('Weight (kg) *'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _weightController,
                          hintText: 'e.g., 28.5',
                          icon: Icons.monitor_weight_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
      
                        // Color Field
                        _buildSectionLabel('Color *'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _colorController,
                          hintText: 'e.g., Golden, Black & White',
                          icon: Icons.color_lens_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter color';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
      
                        // Chip Number Field
                        _buildSectionLabel('Microchip Number'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _chipNumberController,
                          hintText: 'e.g., 123456789012345',
                          icon: Icons.qr_code_2_outlined,
                          keyboardType: TextInputType.number,
                          validator: null,
                        ),
                        const SizedBox(height: 32),
      
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _savePet(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(
                                alpha: .4,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Add Pet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: Validators().defaultValidation,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.background, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.background, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.background, width: 2),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.background, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.background, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
        ),
        hint: Text(
          hint,
          style: TextStyle(color: AppColors.lightText, fontSize: 16),
        ),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.lightText),
        isExpanded: true,
        dropdownColor: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: AppColors.text, fontSize: 16),
            ),
          );
        }).toList(),
        validator: Validators().dropdownValidation,
        onChanged: onChanged,
      ),
    );
  }
}
