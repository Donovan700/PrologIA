% =======================================================
% SYSTÈME D'ENQUÊTE POLICIÈRE - Police Investigation System
% =======================================================

% Types de crimes disponibles
crime_type(vol).
crime_type(assassinat).
crime_type(escroquerie).

% =======================================================
% BASE DE FAITS - SUSPECTS ET PREUVES
% =======================================================

% Liste des suspects
suspect(john).
suspect(mary).
suspect(alice).
suspect(bruno).
suspect(sophie).

% Preuves pour le vol (john)
has_motive(john, vol).
was_near_crime_scene(john, vol).
has_fingerprint_on_weapon(john, vol).

% Preuves pour l'assassinat (mary)
has_motive(mary, assassinat).
was_near_crime_scene(mary, assassinat).
has_fingerprint_on_weapon(mary, assassinat).

% Preuves pour l'escroquerie
has_motive(alice, escroquerie).
has_bank_transaction(alice, escroquerie).
has_bank_transaction(bruno, escroquerie).
owns_fake_identity(sophie, escroquerie).

% Témoins oculaires (pour compléter les cas)
eyewitness_identification(mary, assassinat).

% =======================================================
% RÈGLES DE DÉTERMINATION DE CULPABILITÉ
% =======================================================

% Règle pour le vol - nécessite 3 preuves
is_guilty(Suspect, vol) :-
    suspect(Suspect),
    has_motive(Suspect, vol),
    was_near_crime_scene(Suspect, vol),
    has_fingerprint_on_weapon(Suspect, vol).

% Règle pour l'assassinat - mobile + proximité + (empreintes OU témoin)
is_guilty(Suspect, assassinat) :-
    suspect(Suspect),
    has_motive(Suspect, assassinat),
    was_near_crime_scene(Suspect, assassinat),
    ( has_fingerprint_on_weapon(Suspect, assassinat)
    ; eyewitness_identification(Suspect, assassinat)
    ).

% Règle pour l'escroquerie - mobile + (transaction bancaire OU fausse identité)
is_guilty(Suspect, escroquerie) :-
    suspect(Suspect),
    has_motive(Suspect, escroquerie),
    ( has_bank_transaction(Suspect, escroquerie)
    ; owns_fake_identity(Suspect, escroquerie)
    ).

% =======================================================
% PRÉDICATS UTILITAIRES
% =======================================================

% Vérifier si un suspect existe
valid_suspect(Suspect) :-
    suspect(Suspect).

% Vérifier si un type de crime existe
valid_crime_type(CrimeType) :-
    crime_type(CrimeType).

% Lister tous les suspects coupables pour un crime donné
find_all_guilty(CrimeType, GuiltyList) :-
    findall(Suspect, is_guilty(Suspect, CrimeType), GuiltyList).

% Lister toutes les preuves contre un suspect pour un crime donné
list_evidence(Suspect, CrimeType, Evidence) :-
    findall(Proof, evidence_against(Suspect, CrimeType, Proof), Evidence).

% Prédicat auxiliaire pour collecter les preuves
evidence_against(Suspect, CrimeType, motive) :-
    has_motive(Suspect, CrimeType).
evidence_against(Suspect, CrimeType, near_scene) :-
    was_near_crime_scene(Suspect, CrimeType).
evidence_against(Suspect, CrimeType, fingerprints) :-
    has_fingerprint_on_weapon(Suspect, CrimeType).
evidence_against(Suspect, CrimeType, bank_transaction) :-
    has_bank_transaction(Suspect, CrimeType).
evidence_against(Suspect, CrimeType, fake_identity) :-
    owns_fake_identity(Suspect, CrimeType).
evidence_against(Suspect, CrimeType, eyewitness) :-
    eyewitness_identification(Suspect, CrimeType).

% =======================================================
% INTERFACE INTERACTIVE
% =======================================================

% Point d'entrée principal avec interface interactive
start_investigation :-
    writeln('=============================================='),
    writeln('SYSTÈME D\'ENQUÊTE POLICIÈRE'),
    writeln('=============================================='),
    writeln(''),
    writeln('Commandes disponibles:'),
    writeln('1. investigate(Suspect, CrimeType) - Enquêter sur un suspect'),
    writeln('2. list_suspects - Lister tous les suspects'),
    writeln('3. list_crimes - Lister tous les types de crimes'),
    writeln('4. find_guilty(CrimeType) - Trouver tous les coupables d\'un crime'),
    writeln('5. show_evidence(Suspect, CrimeType) - Montrer les preuves'),
    writeln(''),
    writeln('Exemple: investigate(john, vol).'),
    writeln('').

% Enquêter sur un suspect spécifique
investigate(Suspect, CrimeType) :-
    ( \+ valid_suspect(Suspect) ->
        format('ERREUR: ~w n\'est pas un suspect valide.~n', [Suspect])
    ; \+ valid_crime_type(CrimeType) ->
        format('ERREUR: ~w n\'est pas un type de crime valide.~n', [CrimeType])
    ; is_guilty(Suspect, CrimeType) ->
        format('RÉSULTAT: ~w est COUPABLE de ~w.~n', [Suspect, CrimeType]),
        show_evidence(Suspect, CrimeType)
    ;   format('RÉSULTAT: ~w n\'est PAS COUPABLE de ~w.~n', [Suspect, CrimeType]),
        show_evidence(Suspect, CrimeType)
    ).

% Lister tous les suspects
list_suspects :-
    writeln('SUSPECTS:'),
    forall(suspect(S), format('- ~w~n', [S])).

% Lister tous les types de crimes
list_crimes :-
    writeln('TYPES DE CRIMES:'),
    forall(crime_type(C), format('- ~w~n', [C])).

% Trouver tous les coupables d'un type de crime
find_guilty(CrimeType) :-
    find_all_guilty(CrimeType, GuiltyList),
    ( GuiltyList = [] ->
        format('Aucun coupable trouvé pour ~w.~n', [CrimeType])
    ;   format('Coupables de ~w:~n', [CrimeType]),
        forall(member(Guilty, GuiltyList), format('- ~w~n', [Guilty]))
    ).

% Afficher les preuves contre un suspect
show_evidence(Suspect, CrimeType) :-
    list_evidence(Suspect, CrimeType, Evidence),
    ( Evidence = [] ->
        writeln('Aucune preuve trouvée.')
    ;   writeln('Preuves:'),
        forall(member(Proof, Evidence), format('- ~w~n', [Proof]))
    ).

% =======================================================
% ENTRÉE PRINCIPALE (pour utilisation en ligne de commande)
% =======================================================

main :-
    current_input(Input),
    read(Input, Query),
    process_query(Query),
    halt.

% Traitement des requêtes
process_query(crime(Suspect, CrimeType)) :-
    !,
    ( is_guilty(Suspect, CrimeType) ->
        writeln(guilty)
    ;   writeln(not_guilty)
    ).

process_query(start) :-
    !,
    start_investigation.

process_query(Query) :-
    format('Requête non reconnue: ~w~n', [Query]),
    writeln('Utilisez crime(suspect, type_crime) ou start.').

% =======================================================
% EXEMPLES D'UTILISATION
% =======================================================
/*
Exemples de requêtes:

?- investigate(john, vol).
?- investigate(mary, assassinat).
?- investigate(alice, escroquerie).
?- find_guilty(escroquerie).
?- show_evidence(john, vol).
?- list_suspects.
?- list_crimes.
*/