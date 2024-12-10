import 'package:get/get.dart' show GetPage, Transition;

import '../middlewares/auth_middleware.dart';
import '../modules/account/views/ratings_view.dart';
import '../modules/add_ravel_form/Views/add_air_travel_form.dart';
import '../modules/add_ravel_form/Views/add_travel_form.dart';
import '../modules/add_ravel_form/binding/add_travel_binding.dart';
import '../modules/identity_files/Views/attachment_list.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/splash_view.dart';
import '../modules/auth/views/verification_view.dart';
import '../modules/available_travels/binding/available_travels_binding.dart';
import '../modules/available_travels/view/available_travels_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/categories_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/e_service/bindings/e_service_binding.dart';
import '../modules/e_service/views/e_service_view.dart';
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
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/address_picker_view.dart';
import '../modules/settings/views/addresses_view.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import '../modules/signal_incident/binding/signal_incident_binding.dart';
import '../modules/signal_incident/views/incidents_view.dart';
import '../modules/signal_incident/views/signal_incident_form.dart';
import '../modules/travel_inspect/bindings/travel_inspect_binding.dart';
import '../modules/travel_inspect/views/add_reception_offer_form.dart';
import '../modules/travel_inspect/views/add_shipping_form.dart';
import '../modules/userBookings/views/create_offer_expedition.dart';
import '../modules/travel_inspect/views/travel_inspect_view.dart';
import '../modules/userBookings/views/create_reception_offer.dart';
import '../modules/userBookings/views/expeditions_offers_view.dart';
import '../modules/userBookings/views/invoice_pdf.dart';
import '../modules/userBookings/views/invoice_view.dart';
import '../modules/userBookings/views/reception_offers_view.dart';
import '../modules/userBookings/views/shippingDetails.dart';
import '../modules/userTravels/views/user_travel_selection_view.dart';
import '../modules/validate_transaction/binding/validation_Biding.dart';
import '../modules/validate_transaction/views/validate_transaction.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.SPLASH_VIEW;

  static final routes = [
    GetPage(name: Routes.SPLASH_VIEW, page: () => SplashView(), binding: AuthBinding()),
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.RATING, page: () => RatingView(), binding: RatingBinding()),
    GetPage(name: Routes.CHAT, page: () => ChatsView(), binding: MessageBinding()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESSES, page: () => AddressesView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.ADD_TRAVEL_FORM, page: () => AddTravelsView(), binding: AddTravelBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.ADD_AIR_TRAVEL_FORM, page: () => AddAirTravelsView(), binding: AddTravelBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.ADD_SHIPPING_FORM, page: () => AddShippingView(), binding: TravelInspectBinding(), transition: Transition.upToDown),
    GetPage(name: Routes.ADD_RECEPTION_OFFER_FORM, page: () => AddReceptionOfferForm(), binding: TravelInspectBinding(), transition: Transition.upToDown),
    GetPage(name: Routes.CREATE_OFFER_EXPEDITION, page: () => OfferExpeditionView(), binding: TravelInspectBinding(), transition: Transition.upToDown),
    GetPage(name: Routes.EXPEDITIONS_OFFERS_VIEW, page: () => ExpeditionsOffersView(), transition: Transition.upToDown),
    GetPage(name: Routes.RECEPTIONS_OFFERS_VIEW, page: () => ReceptionsOffersView(), transition: Transition.upToDown),
    GetPage(name: Routes.CREATE_RECEPTION_OFFER, page: () => ReceptionOffersView(), transition: Transition.upToDown),
    GetPage(name: Routes.USER_TRAVEL_SELECTION, page: () => UserTravelSelectionView(), transition: Transition.upToDown),
    GetPage(name: Routes.IDENTITY_FILES, page: () => AttachmentView(), binding: ImportIdentityFilesBinding()),
    GetPage(name: Routes.SIGNAL_INCIDENT, page: () => SignalIncidentForm()),
    GetPage(name: Routes.INCIDENTS_VIEW, page: () => IncidentsView(), binding: SignalIncidentBinding()),
    GetPage(name: Routes.RATING_LIST, page: () => RatingsView(), transition: Transition.zoom),
    GetPage(name: Routes.ADD_IDENTITY_FILES, page: () => ImportIdentityFilesView(), binding: ImportIdentityFilesBinding()),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () => LanguageView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESS_PICKER, page: () => AddressPickerView()),
    GetPage(name: Routes.AVAILABLE_TRAVELS, page: ()=> AvailableTravelsView(), binding: AvailableTravelBinding()),
    GetPage(name: Routes.TRAVEL_INSPECT, page: () => TravelInspectView(), binding: TravelInspectBinding()),
    GetPage(name: Routes.INVOICE, page: () => InvoiceView(), transition: Transition.fadeIn),
    GetPage(name: Routes.SHIPPING_DETAILS, page: () => ShippingDetails(), transition: Transition.fadeIn),
    GetPage(name: Routes.PROFILE, page: () => ProfileView(), binding: ProfileBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.INVOICE_PDF, page: () => InvoicePdf(), transition: Transition.fadeIn),
    GetPage(name: Routes.CATEGORY, page: () => CategoryView(), binding: CategoryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.CATEGORIES, page: () => CategoriesView(), binding: CategoryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.VALIDATE_TRANSACTION, page: () => ValidationView(), binding: ValidationBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.VERIFICATION, page: () => VerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.E_SERVICE, page: () => EServiceView(), binding: EServiceBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.PRIVACY, page: () => PrivacyView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.HELP, page: () => HelpView(), binding: HelpPrivacyBinding()),
    //GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding(), transition: Transition.fadeIn),
    //GetPage(name: Routes.WALLETS, page: () => WalletsView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
    //GetPage(name: Routes.WALLET_FORM, page: () => WalletFormView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
  ];
}
