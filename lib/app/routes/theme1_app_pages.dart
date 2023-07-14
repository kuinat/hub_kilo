import 'package:get/get.dart' show GetPage, Transition;

import '../middlewares/auth_middleware.dart';
import '../modules/Forms/Views/add_travel_form.dart';
import '../modules/Forms/binding/add_travel_binding.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/phone_verification_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/available_travels/binding/available_travels_binding.dart';
import '../modules/available_travels/view/available_travels_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/custom_pages/bindings/custom_pages_binding.dart';
import '../modules/custom_pages/views/custom_pages_view.dart';
import '../modules/e_provider/bindings/e_provider_binding.dart';
import '../modules/e_provider/views/e_provider_e_services_view.dart';
import '../modules/e_provider/views/e_provider_view.dart';
import '../modules/e_service/bindings/e_service_binding.dart';
import '../modules/e_service/views/e_service_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/gallery/bindings/gallery_binding.dart';
import '../modules/gallery/views/gallery_view.dart';
import '../modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/help_privacy/views/help_view.dart';
import '../modules/help_privacy/views/privacy_view.dart';
import '../modules/identity_files/Views/import_identity_files_form.dart';
import '../modules/identity_files/binding/import_identity_files_binding.dart';
import '../modules/messages/binding/message_binding.dart';
import '../modules/messages/views/chats_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rating/bindings/rating_binding.dart';
import '../modules/rating/views/rating_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/search/views/search_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/address_picker_view.dart';
import '../modules/settings/views/addresses_view.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import '../modules/travel_inspect/bindings/travel_inspect_binding.dart';
import '../modules/travel_inspect/views/travel_inspect_view.dart';
import '../modules/validate_transaction/binding/validation_Biding.dart';
import '../modules/validate_transaction/views/validate_transaction.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.RATING, page: () => RatingView(), binding: RatingBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHAT, page: () => ChatsView(), binding: MessageBinding()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESSES, page: () => AddressesView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.ADD_TRAVEL_FORM, page: () => AddTravelsView(), binding: AddTravelBinding()),
    GetPage(name: Routes.IDENTITY_FILES, page: () => ImportIdentityFilesView(), binding: ImportIdentityFilesBinding()),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () => LanguageView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESS_PICKER, page: () => AddressPickerView()),
    GetPage(name: Routes.AVAILABLE_TRAVELS, page: ()=> AvailableTravelsView(), binding: AvailableTravelBinding()),
    GetPage(name: Routes.TRAVEL_INSPECT, page: () => TravelInspectView(), binding: TravelInspectBinding()),
    GetPage(name: Routes.PROFILE, page: () => ProfileView(), binding: ProfileBinding(),
        //middlewares: [AuthMiddleware()]
    ),
    GetPage(name: Routes.CATEGORY, page: () => CategoryView(), binding: CategoryBinding()),
    GetPage(name: Routes.CATEGORIES, page: () => CategoriesView(), binding: CategoryBinding()),
    GetPage(name: Routes.VALIDATE_TRANSACTION, page: () => ValidationView(), binding: ValidationBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.PHONE_VERIFICATION, page: () => PhoneVerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.E_SERVICE, page: () => EServiceView(), binding: EServiceBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FAVORITES, page: () => FavoritesView(), binding: FavoritesBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PRIVACY, page: () => PrivacyView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.HELP, page: () => HelpView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.E_PROVIDER, page: () => EProviderView(), binding: EProviderBinding()),
    GetPage(name: Routes.E_PROVIDER_E_SERVICES, page: () => EProviderEServicesView(), binding: EProviderBinding()),
    GetPage(name: Routes.CUSTOM_PAGES, page: () => CustomPagesView(), binding: CustomPagesBinding()),
    GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    //GetPage(name: Routes.WALLETS, page: () => WalletsView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
    //GetPage(name: Routes.WALLET_FORM, page: () => WalletFormView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
  ];
}
