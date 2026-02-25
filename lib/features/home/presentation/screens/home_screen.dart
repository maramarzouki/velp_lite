import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velp_lite/core/providers/pet_providers.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/features/auth/data/entity/user_entity.dart';
import 'package:velp_lite/features/auth/presentation/screens/login_screen.dart';
import 'package:velp_lite/features/chat/presentation/screens/chat_lists_screen.dart';
import 'package:velp_lite/features/home/data/entity/pet_entity.dart';
import 'package:velp_lite/features/home/presentation/screens/add_pet_screen.dart';
import 'package:velp_lite/features/pet_details/presentation/screens/pet_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showFabMenu = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _toggleFabMenu() {
    if (_showFabMenu) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() => _showFabMenu = false);
        }
      });
    } else {
      setState(() => _showFabMenu = true);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider).value;
    final pets = ref.watch(petViewModelProvider(user!.id!));
    debugPrint('pets: $pets');
    // final notifier = ref.watch(petViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          child: Column(
            children: [
              // top Bar
              _buildTopBar(user, pets, context),

              // pets list
              Expanded(
                flex: 1,
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
                                    builder: (_) => PetDetailsScreen(pet: pet),
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
                                            AppColors.accent.withValues(
                                              alpha: .3,
                                            ),
                                            AppColors.accent.withValues(
                                              alpha: .1,
                                            ),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                if (_showFabMenu)
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _animationController,
                      child: GestureDetector(
                        onTap: _toggleFabMenu,
                        child: Container(
                          color: Colors.black.withValues(alpha: .2),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .6),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleFabMenu,
                        borderRadius: BorderRadius.circular(32),
                        child: Center(
                          child: Transform.rotate(
                            angle: _rotationAnimation.value * 2 * 0,
                            child: Icon(
                              _showFabMenu ? Icons.close : Icons.more_vert,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showFabMenu)
                  Positioned(
                    bottom: 16 + 140 * _animationController.value,
                    right: 16,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: ScaleTransition(
                        scale: _animationController,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: AppColors.primary),
                            onPressed: () {
                              _toggleFabMenu();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddPetScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_showFabMenu)
                  Positioned(
                    bottom: 16 + 80 * _animationController.value,
                    right: 16,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: ScaleTransition(
                        scale: _animationController,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              _toggleFabMenu();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatsListScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),

      // floatingActionButton: Container(
      //   width: 64,
      //   height: 64,
      //   decoration: BoxDecoration(
      //     color: AppColors.accent,
      //     borderRadius: BorderRadius.circular(32),
      //     boxShadow: [
      //       BoxShadow(
      //         color: AppColors.accent.withValues(alpha: .6),
      //         blurRadius: 20,
      //         offset: const Offset(0, 6),
      //       ),
      //     ],
      //   ),
      //   child: Material(
      //     color: Colors.transparent,
      //     child: InkWell(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (_) => AddPetScreen()),
      //         );
      //       },
      //       borderRadius: BorderRadius.circular(32),
      //       child: const Icon(Icons.add, color: AppColors.white, size: 28),
      //     ),
      //   ),
      // ),

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

  Widget _buildTopBar(
    UserEntity user,
    AsyncValue<List<PetEntity>> pets,
    BuildContext context,
  ) {
    return Container(
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
                    Text(
                      'Welcome, ${user.firstName}!',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You have ${pets.value?.length} pets in your care.',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: .9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ChatsListScreen()),
                      ),
                      icon: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear(); // Or just remove 'user_id'
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // search bar
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.white,
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: InputDecoration(
            //       hintText: 'Search your pets...',
            //       prefixIcon: Icon(
            //         Icons.search,
            //         color: AppColors.accent,
            //         size: 20,
            //       ),
            //       border: InputBorder.none,
            //       contentPadding: const EdgeInsets.symmetric(
            //         horizontal: 16,
            //         vertical: 12,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
