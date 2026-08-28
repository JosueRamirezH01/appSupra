import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba/routes/route_paths.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/enums/app_view.dart';
import '../core/utils/navigation_utils.dart';
import '../data/models/auth/user_model.dart';
import '../core/navigation/auth_navigation.dart';
import '../presentation/models/service_area_location_pick.dart';
import '../presentation/providers/app_view_notifier.dart';
import '../presentation/providers/auth/auth_notifier.dart';
import '../presentation/screens/explore/explore_subcategories_screen.dart';
import '../presentation/screens/settings/client_edit_profile_screen.dart';
import '../presentation/screens/settings/client_settings_screen.dart';
import '../presentation/screens/admin/admin_applications_screen.dart';
import '../presentation/screens/admin/categories_screen.dart';
import '../presentation/screens/admin/sub_subcategories_screen.dart';
import '../presentation/screens/admin/subcategories_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/auth/forgot_password_new_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/pre_login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/register_type_screen.dart';
import '../presentation/screens/auth/register_technician_screen.dart';
import '../presentation/screens/auth/register_seller_screen.dart';
import '../presentation/screens/technicians/service_area_screen.dart';
import '../presentation/screens/technicians/service_area_map_picker_screen.dart';
import '../presentation/screens/sellers/become_seller_screen.dart';
import '../presentation/screens/sellers/seller_onboarding_screen.dart';
import '../presentation/screens/sellers/seller_profile_edit_screen.dart';
import '../presentation/screens/sellers/seller_cover_screen.dart';
import '../presentation/screens/sellers/seller_location_screen.dart';
import '../presentation/screens/sellers/seller_verification_screen.dart';
import '../presentation/screens/sellers/product_detail_screen.dart';
import '../presentation/screens/sellers/seller_catalog_screen.dart';
import '../presentation/models/seller_product_preview_model.dart';
import '../presentation/screens/sellers/seller_product_form_screen.dart';
import '../presentation/screens/sellers/seller_product_preview_screen.dart';
import '../presentation/screens/sellers/seller_products_screen.dart';
import '../presentation/screens/technicians/become_technician_screen.dart';
import '../presentation/screens/technicians/technician_activate_location_screen.dart';
import '../presentation/screens/technicians/technician_onboarding_screen.dart';
import '../presentation/screens/technicians/technician_submitted_documents_screen.dart';
import '../presentation/screens/technicians/technician_work_portfolio_screen.dart';
import '../presentation/screens/technicians/technician_featured_projects_manage_screen.dart';
import '../presentation/screens/technicians/technician_featured_project_detail_screen.dart';
import '../presentation/screens/technicians/technician_certification_screen.dart';
import '../presentation/screens/technicians/technician_verification_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/shell/client_home_tab.dart';
import '../presentation/shell/client_shell_destination.dart';
import '../presentation/shell/client_shell_scaffold.dart';
import '../presentation/screens/technicians/my_application_screen.dart';
import '../presentation/screens/technicians/my_profile_screen.dart';
import '../presentation/screens/technicians/technician_performance_screen.dart';
import '../presentation/screens/technicians/technician_contact_leads_screen.dart';
import '../presentation/screens/professionals/professionals_browse_screen.dart';
import '../presentation/screens/products/products_browse_screen.dart';
import '../presentation/screens/products/product_offers_screen.dart';
import '../presentation/screens/technicians/technician_detail_screen.dart';
import '../presentation/screens/technicians/technician_service_detail_screen.dart';
import '../presentation/screens/technicians/technician_service_catalog_screen.dart';
import '../presentation/screens/technicians/related_materials_screen.dart';
import '../presentation/screens/search/global_search_screen.dart';
import '../presentation/screens/search/global_search_results_screen.dart';
part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.preLogin,
    refreshListenable: _GoRouterRefresh(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final location = state.matchedLocation;

      if (isPublicAppRoute(location)) {
        if (isLoggedIn &&
            (isAuthFlowRoute(location) || isAuthWelcomeRoute(location))) {
          final user = authState.valueOrNull;
          if (user != null) {
            ref.read(activeAppViewProvider.notifier).syncWithUser(user, applyDefaultView: true);
            final activeView = ref.read(activeAppViewProvider);
            return rootPathForView(resolveActiveView(user, activeView));
          }
          return RoutePaths.home;
        }
        return null;
      }

      if (!isLoggedIn) {
        // Configuración / perfil requiere sesión: volver al home del shell
        // (el tab Perfil del invitado abre el sheet de cuenta, no esta ruta).
        if (location.startsWith(RoutePaths.clientSettings)) {
          return RoutePaths.home;
        }
        return RoutePaths.preLogin;
      }

      final user = authState.valueOrNull;
      if (user != null && location.startsWith('/admin') && !user.isAdmin) {
        return RoutePaths.home;
      }

      if (user != null) {
        final activeView = ref.read(activeAppViewProvider);
        final resolved = resolveActiveView(user, activeView);

        if (resolved != AppView.client && isClientShellTabLocation(location)) {
          return RoutePaths.panel;
        }
        if (resolved == AppView.client && location == RoutePaths.panel) {
          return RoutePaths.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.preLogin,
        builder: (_, _) => const PreLoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (_, _) => const RegisterTypeScreen(),
      ),
      GoRoute(
        path: RoutePaths.registerClient,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.registerTechnician,
        builder: (_, _) => const RegisterTechnicianScreen(),
      ),
      GoRoute(
        path: RoutePaths.registerSeller,
        builder: (_, _) => const RegisterSellerScreen(),
      ),
      GoRoute(
        path: RoutePaths.registerVerify,
        builder: (_, _) => const OtpVerificationScreen(
          purpose: OtpPurpose.registration,
        ),
      ),
      GoRoute(
        path: RoutePaths.technicianActivateLocation,
        builder: (_, state) => TechnicianActivateLocationScreen(
          source: state.uri.queryParameters['source'] ?? 'register',
        ),
      ),
      GoRoute(
        path: RoutePaths.technicianOnboarding,
        builder: (_, state) => TechnicianOnboardingScreen(
          submitted: state.uri.queryParameters['submitted'] == '1',
          resume: state.uri.queryParameters['resume'] == '1',
        ),
      ),
      GoRoute(
        path: RoutePaths.technicianVerification,
        builder: (_, state) => TechnicianVerificationScreen(
          onboarding: state.uri.queryParameters['onboarding'] == 'true',
        ),
      ),
      GoRoute(
        path: RoutePaths.technicianCertification,
        builder: (_, _) => const TechnicianCertificationScreen(),
      ),
      GoRoute(
        path: RoutePaths.technicianDocuments,
        builder: (_, _) => const TechnicianSubmittedDocumentsScreen(),
      ),
      GoRoute(
        path: RoutePaths.technicianWorkPortfolio,
        builder: (_, _) => const TechnicianWorkPortfolioScreen(),
      ),
      GoRoute(
        path: RoutePaths.technicianFeaturedProjects,
        builder: (_, _) => const TechnicianFeaturedProjectsManageScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeTechnician,
        builder: (_, _) => const BecomeTechnicianScreen(),
      ),
      GoRoute(
        path: RoutePaths.becomeSeller,
        builder: (_, _) => const BecomeSellerScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellerOnboarding,
        builder: (_, state) => SellerOnboardingScreen(
          submitted: state.uri.queryParameters['submitted'] == '1',
          resume: state.uri.queryParameters['resume'] == '1',
        ),
      ),
      GoRoute(
        path: RoutePaths.sellerVerification,
        builder: (_, state) => SellerVerificationScreen(
          onboarding: state.uri.queryParameters['onboarding'] == 'true',
        ),
      ),
      GoRoute(
        path: RoutePaths.sellerProfileEdit,
        builder: (_, _) => const SellerProfileEditScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellerCover,
        builder: (_, _) => const SellerCoverScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellerLocation,
        builder: (_, _) => const SellerLocationScreen(),
      ),
      GoRoute(
        path: RoutePaths.sellerLocationMap,
        builder: (_, state) {
          final args = state.extra;
          if (args is ServiceAreaMapPickerArgs) {
            return ServiceAreaMapPickerScreen(
              initialLat: args.initialLat,
              initialLng: args.initialLng,
              initialQuery: args.initialQuery,
              initialCoverageRadiusKm: args.initialCoverageRadiusKm,
              pinOnly: args.pinOnly,
            );
          }
          return const ServiceAreaMapPickerScreen(pinOnly: true);
        },
      ),
      GoRoute(
        path: RoutePaths.sellerProducts,
        builder: (_, _) => const SellerProductsScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (_, state) {
              final raw = state.uri.queryParameters['subcategoryId'];
              final subcategoryId = raw == null ? null : int.tryParse(raw);
              return SellerProductFormScreen(
                initialSubcategoryId: subcategoryId,
              );
            },
          ),
          GoRoute(
            path: 'preview',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (_, state) {
              final preview = state.extra;
              if (preview is! SellerProductPreviewModel) {
                return const Scaffold(
                  body: Center(child: Text('Vista previa no disponible')),
                );
              }
              return SellerProductPreviewScreen(preview: preview);
            },
          ),
          GoRoute(
            path: ':productId/edit',
            builder: (context, state) {
              final productId = int.parse(state.pathParameters['productId']!);
              return SellerProductFormScreen(productId: productId);
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.technicianServiceArea,
        builder: (_, state) {
          final continueToVerification = state.uri.queryParameters['continue'] != 'false';
          return ServiceAreaScreen(continueToVerification: continueToVerification);
        },
      ),
      GoRoute(
        path: RoutePaths.technicianServiceAreaMap,
        builder: (_, state) {
          final args = state.extra;
          if (args is ServiceAreaMapPickerArgs) {
            return ServiceAreaMapPickerScreen(
              initialLat: args.initialLat,
              initialLng: args.initialLng,
              initialQuery: args.initialQuery,
              initialCoverageRadiusKm: args.initialCoverageRadiusKm,
              pinOnly: args.pinOnly,
            );
          }
          return const ServiceAreaMapPickerScreen();
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPasswordVerify,
        builder: (_, state) {
          final email = state.uri.queryParameters['email']?.trim() ?? '';
          return OtpVerificationScreen(
            purpose: OtpPurpose.passwordReset,
            email: email,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPasswordNew,
        builder: (_, _) => const ForgotPasswordNewScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ClientShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (_, _) => const ClientHomeTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.professionalsBrowse,
                builder: (context, state) {
                  final subcategoryRaw =
                      state.uri.queryParameters['subcategoryId'];
                  final initialSubcategoryId = subcategoryRaw == null
                      ? null
                      : int.tryParse(subcategoryRaw);
                  return ProfessionalsBrowseScreen(
                    initialSubcategoryId: initialSubcategoryId,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.productsBrowse,
                builder: (context, state) {
                  final subcategoryRaw =
                      state.uri.queryParameters['subcategoryId'];
                  final initialSubcategoryId = subcategoryRaw == null
                      ? null
                      : int.tryParse(subcategoryRaw);
                  return ProductsBrowseScreen(
                    initialSubcategoryId: initialSubcategoryId,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.clientSettings,
                builder: (_, _) => const ClientSettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (_, _) => const ClientEditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.panel,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.globalSearch,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, _) => const GlobalSearchScreen(),
        routes: [
          GoRoute(
            path: 'results',
            builder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return GlobalSearchResultsScreen(initialQuery: query);
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.technicians,
        redirect: (context, state) {
          if (state.uri.path == RoutePaths.technicians) {
            return RoutePaths.professionalsBrowse;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: ':userId',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final userId = int.parse(state.pathParameters['userId']!);
              final subcategoryRaw =
                  state.uri.queryParameters['subcategoryId'];
              final subSubRaw = state.uri.queryParameters['subSubCategoryId'];
              final contextSubcategoryId = subcategoryRaw == null
                  ? null
                  : int.tryParse(subcategoryRaw);
              final contextSubSubCategoryId = subSubRaw == null
                  ? null
                  : int.tryParse(subSubRaw);
              return TechnicianDetailScreen(
                userId: userId,
                contextSubcategoryId: contextSubcategoryId,
                contextSubSubCategoryId: contextSubSubCategoryId,
              );
            },
            routes: [
              GoRoute(
                path: 'services/:subSubCategoryId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final userId = int.parse(state.pathParameters['userId']!);
                  final subSubCategoryId = int.parse(
                    state.pathParameters['subSubCategoryId']!,
                  );
                  return TechnicianServiceDetailScreen(
                    userId: userId,
                    subSubCategoryId: subSubCategoryId,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'catalog',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final userId =
                          int.parse(state.pathParameters['userId']!);
                      final subSubCategoryId = int.parse(
                        state.pathParameters['subSubCategoryId']!,
                      );
                      return TechnicianServiceCatalogScreen(
                        userId: userId,
                        subSubCategoryId: subSubCategoryId,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'materials',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final userId =
                          int.parse(state.pathParameters['userId']!);
                      final subSubCategoryId = int.parse(
                        state.pathParameters['subSubCategoryId']!,
                      );
                      final title = state.uri.queryParameters['title'];
                      return RelatedMaterialsScreen(
                        technicianUserId: userId,
                        professionSubSubCategoryId: subSubCategoryId,
                        serviceName: title ?? '',
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'projects/:projectId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final userId = int.parse(state.pathParameters['userId']!);
                  final projectId = int.parse(
                    state.pathParameters['projectId']!,
                  );
                  return TechnicianFeaturedProjectDetailScreen(
                    userId: userId,
                    projectId: projectId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.productOffers,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProductOffersScreen(),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['productId']!);
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: RoutePaths.sellerCatalog,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final sellerId = int.parse(state.pathParameters['sellerId']!);
          final currentProductRaw =
              state.uri.queryParameters['currentProductId'];
          final currentProductId = currentProductRaw == null
              ? null
              : int.tryParse(currentProductRaw);
          return SellerCatalogScreen(
            sellerId: sellerId,
            currentProductId: currentProductId,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.exploreSubcategories,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final categoryId = int.parse(state.pathParameters['categoryId']!);
          final title = state.uri.queryParameters['title'] ?? 'Explorar';
          return ExploreSubcategoriesScreen(
            categoryId: categoryId,
            title: title,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.myProfile,
        builder: (_, _) => const MyProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.myApplication,
        builder: (_, _) => const MyApplicationScreen(),
      ),
      GoRoute(
        path: RoutePaths.technicianPerformance,
        builder: (_, _) => const TechnicianPerformanceScreen(),
      ),
      GoRoute(
        path: RoutePaths.technicianContactLeads,
        builder: (_, _) => const TechnicianContactLeadsScreen(),
      ),
      GoRoute(
        path: RoutePaths.categories,
        builder: (_, _) => const CategoriesScreen(),
        routes: [
          GoRoute(
            path: ':categoryId/subcategories',
            builder: (context, state) {
              final categoryId = int.parse(state.pathParameters['categoryId']!);
              final categoryName = state.uri.queryParameters['name'] ?? 'Categoría';
              return SubcategoriesScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              );
            },
            routes: [
              GoRoute(
                path: ':subcategoryId/sub-subcategories',
                builder: (context, state) {
                  final subcategoryId =
                      int.parse(state.pathParameters['subcategoryId']!);
                  final name = state.uri.queryParameters['name'] ?? 'Subcategoría';
                  return SubSubCategoriesScreen(
                    subcategoryId: subcategoryId,
                    subcategoryName: name,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.adminApplications,
        builder: (_, _) => const AdminApplicationsScreen(),
        routes: [
          GoRoute(
            path: ':userId',
            builder: (context, state) {
              final userId = int.parse(state.pathParameters['userId']!);
              return AdminApplicationDetailScreen(userId: userId);
            },
          ),
        ],
      ),
    ],
  );
}

class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(Ref ref) {
    ref.listen(authNotifierProvider, (_, _) => notifyListeners());
    ref.listen(activeAppViewProvider, (_, _) => notifyListeners());
  }
}
