import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/entities/pet_entity.dart';
import 'package:velp_lite/core/entities/rdv_entity.dart';
import 'package:velp_lite/core/providers/rdv_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';

class Vet {
  final String name;
  final String specialty;
  final String clinic;
  final String rating;
  final String distance;
  final String emoji;
  final List<String> availableTimes;

  Vet({
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    required this.distance,
    required this.emoji,
    required this.availableTimes,
  });
}

class ScheduleVetScreen extends ConsumerStatefulWidget {
  final PetEntity pet;
  const ScheduleVetScreen({super.key, required this.pet});

  @override
  ConsumerState<ScheduleVetScreen> createState() => _ScheduleVetScreenState();
}

class _ScheduleVetScreenState extends ConsumerState<ScheduleVetScreen> {
  DateTime? _selectedDate;
  Vet? _selectedVet;
  String? _selectedTime;

  final List<Vet> _vets = [
    Vet(
      name: 'Dr. Sarah Wilson',
      specialty: 'General Veterinarian',
      clinic: 'Happy Paws Clinic',
      rating: '4.9',
      distance: '2.3 km',
      emoji: '👩‍⚕️',
      availableTimes: ['09:00 AM', '10:30 AM', '02:00 PM', '04:30 PM'],
    ),
    Vet(
      name: 'Dr. Michael Chen',
      specialty: 'Surgery Specialist',
      clinic: 'Pet Care Center',
      rating: '4.8',
      distance: '3.1 km',
      emoji: '👨‍⚕️',
      availableTimes: ['09:30 AM', '11:00 AM', '03:00 PM', '05:00 PM'],
    ),
    Vet(
      name: 'Dr. Emily Rodriguez',
      specialty: 'Dental Specialist',
      clinic: 'Veterinary Hospital',
      rating: '4.9',
      distance: '1.8 km',
      emoji: '👩‍⚕️',
      availableTimes: ['10:00 AM', '01:00 PM', '03:30 PM', '05:30 PM'],
    ),
    Vet(
      name: 'Dr. James Anderson',
      specialty: 'Emergency Care',
      clinic: 'Animal Emergency',
      rating: '5.0',
      distance: '4.2 km',
      emoji: '👨‍⚕️',
      availableTimes: ['08:00 AM', '12:00 PM', '04:00 PM', '06:00 PM'],
    ),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createRdv() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a date'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (_selectedVet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a veterinarian'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a time slot'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    final timeStr = _selectedTime!;
    final parts = timeStr.split(':');
    int hour = int.parse(parts[0]);
    final minutePart = parts[1].trim();
    final minute = int.parse(minutePart.split(' ')[0]);

    // Convert to 24-hour format
    final isPM = timeStr.contains('PM');
    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0; // 12:00 AM
    }

    final rdv = RdvEntity(
      animalID: widget.pet.id!,
      vet: _selectedVet!.name,
      date: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        hour,
        minute,
      ),
      isConfirmed: 1,
    );

    try{
      final createdRdv = await ref
        .read(rdvViewModelProvider.notifier)
        .addRdv(rdv);
         Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Appointment scheduled with ${createdRdv.vet} on ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at $_selectedTime',
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  
    } catch (e) {
      debugPrint('Error adding rdv: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding rdv: $e')),
      );
   }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: .9),
                ],
              ),
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                Row(
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
                            'Schedule Vet Visit',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Choose date, vet, and time',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Picker
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'Select appointment date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                color: _selectedDate == null
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
                  const SizedBox(height: 20),

                  // Veterinarian Dropdown
                  const Text(
                    'Choose Veterinarian',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.background, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<Vet>(
                      value: _selectedVet,
                      itemHeight: 64,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.medical_services_outlined,
                          color: AppColors.accent,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      hint: Text(
                        'Select a veterinarian',
                        style: TextStyle(
                          color: AppColors.lightText,
                          fontSize: 16,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.lightText,
                      ),
                      isExpanded: true,
                      dropdownColor: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      items: _vets.map((Vet vet) {
                        return DropdownMenuItem<Vet>(
                          value: vet,
                          child: Row(
                            children: [
                              Text(
                                vet.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      vet.name,
                                      style: const TextStyle(
                                        color: AppColors.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Text(
                                    //   '${vet.specialty} • ⭐${vet.rating}',
                                    //   style: TextStyle(
                                    //     color: AppColors.lightText,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (Vet? newValue) {
                        setState(() {
                          _selectedVet = newValue;
                          _selectedTime = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Slots
                  if (_selectedVet != null) ...[
                    const Text(
                      'Available Time Slots',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedVet!.availableTimes.map((time) {
                        final isSelected = _selectedTime == time;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.background,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.accent.withValues(alpha: .3)
                                      : Colors.black.withValues(alpha: .04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _createRdv,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: .4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Confirm Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
