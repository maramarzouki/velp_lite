import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velp_lite/core/providers/pet_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/features/home/presentation/screens/add_pet_screen.dart';
import 'package:velp_lite/features/pet_details/presentation/screens/pet_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pets = ref.watch(petViewModelProvider);
    debugPrint('pets: $pets');
    // final notifier = ref.watch(petViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // top Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    // header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Pets',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pets.value?.length} pets in your care',
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: .9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // search bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your pets...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // pets list
            Expanded(
              child: pets.when(
                data: (pets) {
                  if (pets.isEmpty) {
                    return const Center(child: Text('No pets found!'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .08),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PetDetailsScreen(pet: pet,),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // pet avatar
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.accent.withValues(alpha: .3),
                                          AppColors.accent.withValues(alpha: .1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        pet.emoji,
                                        style: const TextStyle(fontSize: 56),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // pet info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet.name,
                                          style: const TextStyle(
                                            color: AppColors.text,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${pet.breed} • ${pet.ageLabel}',
                                          style: TextStyle(
                                            color: AppColors.lightText,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${pet.gender} • ${pet.weight}',
                                          style: TextStyle(
                                            color: AppColors.lightText,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: .6),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddPetScreen()));
            },
            borderRadius: BorderRadius.circular(32),
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          ),
        ),
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: AppColors.white,
      //     border: Border(
      //       top: BorderSide(
      //         color: backgroundColor,
      //         width: 1,
      //       ),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withValues(alpha: .08),
      //         blurRadius: 10,
      //         offset: const Offset(0, -2),
      //       ),
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 12),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           // Home Tab (Active)
      //           Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Container(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 20,
      //                   vertical: 8,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color: AppColors.primar.withValues(alpha: .2),
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: const Icon(
      //                   Icons.home,
      //                   color: AppColors.primar,
      //                   size: 24,
      //                 ),
      //               ),
      //               const SizedBox(height: 4),
      //               const Text(
      //                 'Home',
      //                 style: TextStyle(
      //                   color: AppColors.primar,
      //                   fontSize: 11,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //               ),
      //             ],
      //           ),

      //           // Profile Tab
      //           Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(
      //                 Icons.person_outline,
      //                 color: lightAppColors.text,
      //                 size: 24,
      //               ),
      //               const SizedBox(height: 4),
      //               Text(
      //                 'Profile',
      //                 style: TextStyle(
      //                   color: lightAppColors.text,
      //                   fontSize: 11,
      //                 ),
      //               ),
      //             ],
      //           ),

      //           // Settings Tab
      //           Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(
      //                 Icons.settings_outlined,
      //                 color: lightAppColors.text,
      //                 size: 24,
      //               ),
      //               const SizedBox(height: 4),
      //               Text(
      //                 'Settings',
      //                 style: TextStyle(
      //                   color: lightAppColors.text,
      //                   fontSize: 11,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}