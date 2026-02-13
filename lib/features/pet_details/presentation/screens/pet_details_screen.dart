import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velp_lite/core/entities/pet_entity.dart';
import 'package:velp_lite/core/entities/rdv_entity.dart';
import 'package:velp_lite/core/providers/rdv_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/features/rdv/presentation/screens/schedule_vet_screen.dart';

class PetDetailsScreen extends ConsumerStatefulWidget {
  final PetEntity pet;
  const PetDetailsScreen({super.key, required this.pet});

  @override
  ConsumerState<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends ConsumerState<PetDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, you'd get this from arguments
    // final pet = {
    //   'name': 'Luna',
    //   'breed': 'Golden Retriever',
    //   'age': '3 years',
    //   'weight': '28 kg',
    //   'gender': 'Female',
    //   'emoji': '🐕',
    // };

    final rdvVMProvider = ref.watch(rdvViewModelProvider);

    final List<RdvEntity> appointments = rdvVMProvider.when(
      data: (data) => data.where((r) => r.animalID == widget.pet.id).toList(),
      error: (error, stackTrace) => [],
      loading: () => [],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         AppColors,
            //         AppColors.withValues(alpha: 0.9),
            //       ],
            //     ),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //             color: AppColors.white.withValues(alpha: .2),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: IconButton(
            //             onPressed: () => Navigator.pop(context),
            //             icon: const Icon(
            //               Icons.arrow_back,
            //               color: AppColors.white,
            //             ),
            //           ),
            //         ),
            //         Container(
            //           decoration: BoxDecoration(
            //             color: AppColors.white.withValues(alpha: .2),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: IconButton(
            //             onPressed: () {},
            //             icon: const Icon(
            //               Icons.edit_outlined,
            //               color: AppColors.white,
            //               size: 22,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Pet Photo Card
                    SizedBox(height: 100),
                    Transform.translate(
                      offset: const Offset(0, -80),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.accent.withValues(alpha: .3),
                                        AppColors.accent.withValues(alpha: .1),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.accent,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(
                                          alpha: .4,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.pet.emoji,
                                      style: const TextStyle(fontSize: 100),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  widget.pet.name,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.pet.breed,
                                  style: TextStyle(
                                    color: AppColors.lightText,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Quick Stats
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                emoji: '⏱️',
                                value: widget.pet.ageLabel.toString(),
                                label: 'Years',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                emoji: '⚖️',
                                value: widget.pet.weight.toString(),
                                label: 'Kg',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                emoji: widget.pet.gender == 'Female'
                                    ? '♀️'
                                    : '♂️',
                                value: widget.pet.gender,
                                label: 'Gender',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tab Navigation
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            _buildTabButton('Info', 0),
                            const SizedBox(width: 8),
                            _buildTabButton('Medical', 1),
                            const SizedBox(width: 8),
                            _buildTabButton('Photos', 2),
                          ],
                        ),
                      ),
                    ),

                    // Tab Content
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: _buildTabContent(
                          _currentTabIndex,
                          widget.pet,
                          appointments,
                        ),
                      ),
                    ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: 'Schedule Vet',
                              icon: Icons.calendar_today_outlined,
                              color: AppColors.accent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ScheduleVetScreen(pet: widget.pet),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              label: 'Edit Profile',
                              icon: Icons.edit_outlined,
                              color: AppColors.secondary,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: AppColors.lightText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isActive = _currentTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? AppColors.primary.withValues(alpha: .4)
                    : Colors.black.withValues(alpha: .06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    int index,
    PetEntity pet,
    List<RdvEntity> appointments,
  ) {
    switch (index) {
      case 0:
        return _buildInfoTab(pet);
      case 1:
        return _buildMedicalTab(pet, appointments);
      case 2:
        return _buildPhotosTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildInfoTab(PetEntity pet) {
    return Column(
      children: [
        // Basic Info Card
        _buildInfoCard(
          title: 'Basic Information',
          accentColor: AppColors.accent,
          children: [
            _buildInfoRow(
              emoji: '🐕',
              label: 'Breed',
              value: pet.breed,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Age',
              value: pet.ageLabel.toString(),
              color: AppColors.accent,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // About Card
        _buildInfoCard(
          title: 'About',
          accentColor: AppColors.secondary,
          children: [
            Text(
              '${pet.name} is a friendly and energetic ${pet.breed} who loves playing fetch and going on long walks.',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalTab(PetEntity pet, List<RdvEntity> appointments) {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Appointments',
          accentColor: AppColors.secondary,
          children: [
            if (appointments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No appointments yet',
                    style: TextStyle(color: AppColors.lightText, fontSize: 16),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return _buildAppointmentCard(appointment);
                },
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Optional: Quick action inside the tab
        // _buildActionButton(
        //   label: 'Schedule New Appointment',
        //   icon: Icons.add,
        //   color: AppColors.accent,
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => ScheduleVetScreen(pet: pet)),
        //     );
        //   },
        // ),
      
      ],
    );
    // return _buildInfoCard(
    //   title: 'Medical Records',
    //   accentColor: AppColors.secondary,
    //   children: [
    //     _buildInfoRow(
    //       icon: Icons.description_outlined,
    //       label: 'Last Checkup',
    //       value: 'January 15, 2026',
    //       color: AppColors.secondary,
    //     ),
    //     const SizedBox(height: 16),
    //     _buildInfoRow(
    //       emoji: '💉',
    //       label: 'Vaccinations',
    //       value: 'Up to date ✓',
    //       color: AppColors.secondary,
    //     ),
    //     const SizedBox(height: 16),
    //     _buildInfoRow(
    //       emoji: '🏥',
    //       label: 'Veterinarian',
    //       value: 'Dr. Sarah Wilson',
    //       color: AppColors.secondary,
    //     ),
    //   ],
    // );
  }

  Widget _buildPhotosTab() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: List.generate(
        4,
        (index) => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text('📸', style: TextStyle(fontSize: 60)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Color accentColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    String? emoji,
    IconData? icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: .2),
                color.withValues(alpha: .1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: emoji != null
                ? Text(emoji, style: const TextStyle(fontSize: 24))
                : Icon(icon, color: color, size: 22),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.lightText, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: color.withValues(alpha: .4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAppointmentCard(RdvEntity appt) {
  // final isUpcoming = appt.status == 'upcoming';
  // final isCompleted = appt.status == 'completed';

  final isUpcoming = appt.date.isAfter(DateTime.now());
  // final isCompleted = appt.date.isBefore(DateTime.now());

  return Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Date Box
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isUpcoming
                  ? AppColors.accent.withValues(alpha: 0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appt.date.day.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isUpcoming ? AppColors.accent : Colors.grey[700],
                  ),
                ),
                Text(
                  _getMonthShort(appt.date.month),
                  style: TextStyle(
                    fontSize: 12,
                    color: isUpcoming ? AppColors.accent : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat.Hm().format(appt.date),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const Spacer(),
                    // _buildStatusChip(appt.status),
                  ],
                ),
                const SizedBox(height: 6),
                // Text(
                //   appt.reason,
                //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                // ),
                const SizedBox(height: 4),
                Text(
                  "Dr. ${appt.vet}",
                  style: TextStyle(color: AppColors.lightText, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget _buildStatusChip(String status) {
//   Color color;
//   String text;

//   switch (status) {
//     case 'upcoming':
//       color = Colors.orange;
//       text = 'Upcoming';
//       break;
//     case 'completed':
//       color = Colors.green;
//       text = 'Completed';
//       break;
//     case 'cancelled':
//       color = Colors.red;
//       text = 'Cancelled';
//       break;
//     default:
//       color = Colors.grey;
//       text = status;
//   }

//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(
//       color: color.withValues(alpha: 0.1),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
//     ),
//   );
// }

String _getMonthShort(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
