:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).

% Routes HTTP
:- http_handler(root(investigate), investigate_handler, []).
:- http_handler(root(.), home_page, []).

% Suspects et faits
suspect(john).
suspect(mary).
suspect(alice).
suspect(bruno).
suspect(sophie).

has_motive(john, vol).
has_motive(mary, assassinat).
has_motive(alice, escroquerie).

was_near_crime_scene(john, vol).
was_near_crime_scene(mary, assassinat).

has_fingerprint_on_weapon(john, vol).
has_fingerprint_on_weapon(mary, assassinat).

has_bank_transaction(alice, escroquerie).
has_bank_transaction(bruno, escroquerie).

owns_fake_identity(sophie, escroquerie).

% Regles de culpabilite
is_guilty(Suspect, vol) :-
    suspect(Suspect),
    has_motive(Suspect, vol),
    was_near_crime_scene(Suspect, vol),
    has_fingerprint_on_weapon(Suspect, vol).

is_guilty(Suspect, assassinat) :-
    suspect(Suspect),
    has_motive(Suspect, assassinat),
    was_near_crime_scene(Suspect, assassinat),
    has_fingerprint_on_weapon(Suspect, assassinat).

is_guilty(Suspect, escroquerie) :-
    suspect(Suspect),
    has_motive(Suspect, escroquerie),
    ( has_bank_transaction(Suspect, escroquerie)
    ; owns_fake_identity(Suspect, escroquerie)
    ).

% API handler
investigate_handler(Request) :-
    http_parameters(Request, [
        suspect(Suspect, [atom]),
        crime(Crime, [atom])
    ]),
    (   is_guilty(Suspect, Crime) ->
        Result = guilty
    ;   Result = not_guilty
    ),
    format('Content-type: application/json~n~n'),
    format('{"result": "~w", "suspect": "~w", "crime": "~w"}~n', [Result, Suspect, Crime]).

% Page d'accueil
home_page(_Request) :-
    format('Content-type: text/html~n~n'),
    write('<!DOCTYPE html>
<html>
<head>
    <title>Police Investigation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        .form-group {
            margin: 25px 0;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
            font-size: 1.1em;
        }
        select {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 2px solid #ddd;
            border-radius: 8px;
            background: white;
        }
        button {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 15px 30px;
            cursor: pointer;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            width: 100%;
            margin-top: 20px;
        }
        button:hover {
            transform: translateY(-2px);
        }
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .result {
            margin-top: 25px;
            padding: 20px;
            border-radius: 10px;
            font-size: 20px;
            font-weight: bold;
            text-align: center;
        }
        .guilty {
            background: #ffe6e6;
            color: #d32f2f;
            border: 2px solid #ffcdd2;
        }
        .not-guilty {
            background: #e8f5e8;
            color: #388e3c;
            border: 2px solid #c8e6c9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>POLICE INVESTIGATION</h1>

        <div class="form-group">
            <label for="suspect">Select Suspect:</label>
            <select id="suspect">
                <option value="john">John</option>
                <option value="mary">Mary</option>
                <option value="alice">Alice</option>
                <option value="bruno">Bruno</option>
                <option value="sophie">Sophie</option>
            </select>
        </div>

        <div class="form-group">
            <label for="crime">Crime Type:</label>
            <select id="crime">
                <option value="vol">Theft</option>
                <option value="assassinat">Murder</option>
                <option value="escroquerie">Fraud</option>
            </select>
        </div>

        <button onclick="investigate()" id="investigateBtn">
            START INVESTIGATION
        </button>

        <div id="result"></div>
    </div>

    <script>
        async function investigate() {
            const suspect = document.getElementById("suspect").value;
            const crime = document.getElementById("crime").value;
            const btn = document.getElementById("investigateBtn");
            const resultDiv = document.getElementById("result");

            btn.disabled = true;
            btn.textContent = "INVESTIGATING...";

            try {
                const response = await fetch("/investigate?suspect=" + suspect + "&crime=" + crime);
                const data = await response.json();

                const isGuilty = data.result === "guilty";
                const resultText = isGuilty ? "GUILTY" : "NOT GUILTY";
                const className = isGuilty ? "guilty" : "not-guilty";

                resultDiv.innerHTML = "<div class=\\"result " + className + "\\">" +
                    suspect.toUpperCase() + " is " + resultText + " of " + crime.toUpperCase() +
                    "</div>";

            } catch (error) {
                resultDiv.innerHTML = "<div class=\\"result\\" style=\\"background: #fff3cd; color: #856404;\\">" +
                    "ERROR: " + error.message + "</div>";
            }

            btn.disabled = false;
            btn.textContent = "START INVESTIGATION";
        }
    </script>
</body>
</html>').

% Demarrer le serveur
start_server :-
    http_server(http_dispatch, [port(8080)]),
    format('Server started on http://localhost:8080~n').

% Arreter le serveur
stop_server :-
    http_stop_server(8080, []).