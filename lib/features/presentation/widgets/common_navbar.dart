
// import 'package:empire_job/shared/providers/theme_providers.dart';
// import 'package:empire_job/shared/styles/appstyles.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CommonNavbar extends ConsumerWidget {
//   const CommonNavbar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isSmallScreen = AppStyles.isSmallScreen(context);
//     final themeMode = ref.watch(themeModeProvider);
//     final isDark = themeMode == ThemeMode.dark;

//     return Container(
//       padding: isSmallScreen
//           ? const EdgeInsets.all(10)
//           : const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _BrandLogo(),
//           const Spacer(),
//           Row(
//             children: [
//               _NavIconButton(
//                 icon: IconConsts.iconChat,
//                 label: 'Chat',
//                 onPressed: () {},
//                 hideLabel: isSmallScreen,
//               ),
//               const SizedBox(width: 20),
//               _NavIconButton(
//                 icon: IconConsts.iconNotification,
//                 label: 'Notifications',
//                 onPressed: () {},
//                 showBadge: true,
//                 hideLabel: isSmallScreen,
//               ),
//               const SizedBox(width: 20),
//               _NavIconButton(
//                 icon: IconConsts.iconSettings,
//                 label: 'Settings',
//                 onPressed: () {
//                   if (kIsWeb) {
//                     final currentLocation = GoRouterState.of(
//                       context,
//                     ).uri.toString();
//                     if (!currentLocation.contains(RouterConsts.settingsPath)) {
//                       context.go(RouterConsts.settingsPath);
//                     }
//                   }
//                 },
//                 hideLabel: isSmallScreen,
//                 isActive: GoRouterState.of(
//                   context,
//                 ).uri.toString().contains(RouterConsts.settingsPath),
//               ),
//               const SizedBox(width: 20),
//               _ProfileSection(hideName: isSmallScreen),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BrandLogo extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return InkWell(
//       onTap: () {
//         final currentLocation = GoRouterState.of(context).uri.toString();
//         if (!currentLocation.contains(RouterConsts.homepagePath)) {
//           context.go(RouterConsts.homepagePath);
//         }
//       },
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.white
//                   : Colors.black,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 'E',
//                 style: GoogleFonts.inter(
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? Colors.black
//                       : Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           CustomText(
//             text: 'Empireo',
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NavIconButton extends StatelessWidget {
//   final String icon;
//   final String? label;
//   final VoidCallback onPressed;
//   final bool showBadge;
//   final bool hideLabel;
//   final bool isActive;

//   const _NavIconButton({
//     required this.icon,
//     this.label,
//     required this.onPressed,
//     this.showBadge = false,
//     this.hideLabel = false,
//     this.isActive = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 SvgPicture.asset(
//                   icon,
//                   width: 20,
//                   height: 20,
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context).iconTheme.color ?? ColorConsts.black,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//                 if (showBadge)
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             if (label != null && !hideLabel) ...[
//               const SizedBox(width: 8),
//               CustomText(
//                 text: label!,
//                 fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
//                 fontSize: 14,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ProfileSection extends ConsumerWidget {
//   final bool hideName;

//   const _ProfileSection({this.hideName = false});

//   String? _getNameFromBasicInfo(Map<String, dynamic>? leadInfo) {
//     if (leadInfo == null) return null;

//     final basicInfo = leadInfo['basic_info'] as Map<String, dynamic>?;
//     if (basicInfo == null) return null;

//     final firstName = basicInfo['first_name'] as String?;
//     final secondName = basicInfo['second_name'] as String?;

//     if (firstName != null && firstName.isNotEmpty) {
//       if (secondName != null && secondName.isNotEmpty) {
//         return '$firstName $secondName';
//       }
//       return firstName;
//     }

//     return null;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentLocation = GoRouterState.of(context).uri.toString();
//     final isProfileRoute = currentLocation.contains(RouterConsts.createProfile);

//     return FutureBuilder<Map<String, dynamic>?>(
//       future: ref.read(leadInfoControllerProvider).getLeadInfo(),
//       builder: (context, snapshot) {
//         final nameFromBasicInfo = _getNameFromBasicInfo(snapshot.data);
//         final displayName = nameFromBasicInfo ?? 'Your Name';

//         return InkWell(
//           onTap: () {
//             if (!currentLocation.contains(RouterConsts.createProfile)) {
//               context.go(RouterConsts.createProfile);
//             }
//           },
//           borderRadius: BorderRadius.circular(8),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const CircleAvatar(radius: 16),
//                 if (!hideName) ...[
//                   const SizedBox(width: 8),
//                   CustomText(
//                     text: displayName,
//                     fontWeight: isProfileRoute
//                         ? FontWeight.w700
//                         : FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }