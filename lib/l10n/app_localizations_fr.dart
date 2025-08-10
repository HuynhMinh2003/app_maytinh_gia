// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get content_welcome_1 =>
      'L\'application permet un calcul rapide, précis et facile à utiliser.';

  @override
  String get content_welcome_2 =>
      'Toujours prête à vous aider à traiter des calculs simples ou complexes, partout et à tout moment.';

  @override
  String get con_tinue => 'Continuer';

  @override
  String get welcome => 'Bienvenue dans l\'application';

  @override
  String get app_title => 'Calculatrice';

  @override
  String get enter_pin => 'Entrez le code PIN';

  @override
  String get re_enter_pin => 'Entrez à nouveau le code PIN';

  @override
  String get confirm => 'Confirmer';

  @override
  String get msg_pin_empty => 'Veuillez entrer le code PIN !!!';

  @override
  String get msg_pin_not_match => 'Le code PIN ne correspond pas !!!';

  @override
  String get msg_pin_success => 'Code PIN configuré avec succès !!!';

  @override
  String get msg_pin_error => 'Erreur lors de la sauvegarde du code PIN.';

  @override
  String msg_error(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get calculationError => 'Erreur de calcul';

  @override
  String get setting1 => 'Configurer le code PIN';

  @override
  String get setting2 => 'Paramètres de langue';

  @override
  String get setting3 => 'Informations';

  @override
  String get setting4 => 'Évaluation';

  @override
  String get setting5 => 'Partager';

  @override
  String get type => 'Choisissez le type de média';

  @override
  String get type_1 => 'Image';

  @override
  String get type_2 => 'Vidéo';

  @override
  String get type_3 => 'Fichier favori';

  @override
  String get error_1 => 'Échec de la dissimulation de l\'image';

  @override
  String get delete_1 => 'Restaurer l\'image';

  @override
  String get delete_12 => 'Êtes-vous sûr de vouloir restaurer cette image ?';

  @override
  String get delete_13 => 'Annuler';

  @override
  String get delete_14 => 'Image restaurée avec succès !';

  @override
  String get delete_15 => 'Restaurer';

  @override
  String get title_1 => 'Images';

  @override
  String get title_2 => 'Ajouter une image';

  @override
  String get error_2 => 'Échec de la dissimulation de la vidéo';

  @override
  String get delete_2 => 'Restaurer la vidéo';

  @override
  String get delete_22 => 'Êtes-vous sûr de vouloir restaurer cette vidéo ?';

  @override
  String get delete_23 => 'Annuler';

  @override
  String get delete_24 => 'Vidéo restaurée avec succès !';

  @override
  String get delete_25 => 'Restaurer';

  @override
  String get title_12 => 'Vidéos';

  @override
  String get title_22 => 'Ajouter une vidéo';

  @override
  String get changePinTitle => 'Changer le code PIN';

  @override
  String get oldPinLabel => 'Entrez l\'ancien code PIN';

  @override
  String get newPinLabel => 'Entrez le nouveau code PIN';

  @override
  String get confirmPinLabel => 'Confirmez le nouveau code PIN';

  @override
  String get fillAllFieldsError =>
      'Tous les champs du code doivent être remplis !!!';

  @override
  String get pinMismatchError =>
      'Le nouveau code PIN et la confirmation doivent correspondre.';

  @override
  String get oldPinValidationError =>
      'Erreur de validation de l\'ancien code PIN.';

  @override
  String get oldPinIncorrectError => 'L\'ancien code PIN est incorrect.';

  @override
  String get changePinSuccess => 'Code PIN mis à jour avec succès !';

  @override
  String get changePinFailed => 'Échec du changement de code PIN.';

  @override
  String get changePinButton => 'Changer le code PIN';

  @override
  String get favoriteTitle => 'Favoris';

  @override
  String get noFavoritesMessage =>
      'Aucune image ou vidéo favorite pour le moment.';

  @override
  String get title_app => 'Informations';

  @override
  String get title_app1 => 'Informations sur l\'application';

  @override
  String get info_app =>
      'Cette application a été développée par l\'étudiant Huỳnh Nhật Minh';

  @override
  String get app_version => 'Version de l\'application';

  @override
  String get version => 'Version :';

  @override
  String get build_version => 'Code de build :';

  @override
  String get okay => 'OK';

  @override
  String get title_rate => 'Évaluer l\'application';

  @override
  String get content_rate => 'Comment évalueriez-vous cette application ?';

  @override
  String get rated => 'Envoyer';

  @override
  String get rate_info => 'Évaluation réussie';

  @override
  String get title_policy => 'Politique';

  @override
  String get content_policy =>
      'L\'application Calculatrice Fausse est destinée uniquement à des fins de divertissement. Nous ne collectons, ne stockons ni ne partageons aucune donnée personnelle des utilisateurs. Tous les calculs et données saisies sont traités uniquement sur votre appareil et ne sont jamais transmis à l\'extérieur. En utilisant l\'application, vous acceptez qu\'elle ne soit pas un outil de calcul précis à des fins éducatives ou professionnelles.';

  @override
  String get language => 'Langue';

  @override
  String get content_language => 'Langue changée avec succès';
}
