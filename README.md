# Système d'Enquête Policière en Prolog

> Un système expert d'enquête policière développé en SWI-Prolog avec interface web intégrée. Utilise la logique de Prolog pour déterminer la culpabilité des suspects basée sur les preuves disponibles.

## 👥 Équipe de Développement
Classe : M1 GB Groupe 1

Membres du Groupe :

- VONIARIMALALA Fiaro Miangaly - 2381
- ANDRIANARIVONY Zo Michael - 2382
- RAMIARIMANANA Sompitriniaina To Désiré - 2405
- RANDRIATSEHENO Rajo Stelly - 2417
- RAKOTO SEDSON Bryan Donovan - 2444
- MIARINIAINA Lai Troy Mi Erica - 2532

## 🚀 Installation et Lancement Rapide

### Prérequis
- **SWI-Prolog** (version 8.0+)
- **Navigateur web moderne** (Chrome, Firefox, Safari, Edge)
- **Port 8080** disponible

### Installation de SWI-Prolog

#### Windows
```bash
# Télécharger sur https://www.swi-prolog.org/download/stable
# Ou par Chocolatey
choco install swi-prolog
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install swi-prolog
```

### 🎯 Démarrage en 3 étapes

1. **Cloner le repository**
```bash
git clone https://github.com/Donovan700/PrologIA.git
cd PrologIA
```

2. **Lancer le serveur**
```bash
swipl -s server.pl -g start_server
```

3. **Accéder à l'application**
```
http://localhost:8080
```

---

## 📝 Utilisation

### Interface Web
1. **Sélectionner un suspect** dans la liste déroulante
2. **Choisir le type de crime** (Vol, Assassinat, Escroquerie)
3. **Cliquer sur "START INVESTIGATION"**
4. **Consulter le résultat** (GUILTY/NOT GUILTY)

### Test en Ligne de Commande Prolog
```prolog
?- [server].
?- is_guilty(john, vol).
true.

?- is_guilty(alice, assassinat).
false.
```

---

## 🎯 Fonctionnalités

- **Système expert en Prolog** : Logique déclarative pour l'analyse des preuves
- **Interface web moderne** : HTML/CSS/JavaScript intégré
- **API REST** : Endpoint JSON pour les requêtes d'investigation
- **Serveur HTTP intégré** : Basé sur SWI-Prolog HTTP library
- **Analyse en temps réel** : Résultats instantanés basés sur la base de connaissances
- **Interface responsive** : Compatible desktop et mobile

---

## 🧠 Règles Logiques

### Base de Données des Suspects

| Suspect | Vol | Assassinat | Escroquerie |
|---------|-----|------------|-------------|
| John    | ✅  | ❌         | ❌          |
| Mary    | ❌  | ✅         | ❌          |
| Alice   | ❌  | ❌         | ✅          |
| Bruno   | ❌  | ❌         | ✅          |
| Sophie  | ❌  | ❌         | ✅          |

### Règles d'Inférence

#### Vol
```prolog
is_guilty(Suspect, vol) :-
    suspect(Suspect),
    has_motive(Suspect, vol),
    was_near_crime_scene(Suspect, vol),
    has_fingerprint_on_weapon(Suspect, vol).
```

#### Assassinat
```prolog
is_guilty(Suspect, assassinat) :-
    suspect(Suspect),
    has_motive(Suspect, assassinat),
    was_near_crime_scene(Suspect, assassinat),
    has_fingerprint_on_weapon(Suspect, assassinat).
```

#### Escroquerie
```prolog
is_guilty(Suspect, escroquerie) :-
    suspect(Suspect),
    has_motive(Suspect, escroquerie),
    ( has_bank_transaction(Suspect, escroquerie)
    ; owns_fake_identity(Suspect, escroquerie)
    ).
```

---

## 🔧 Architecture

### Components
- **Backend Prolog** : Moteur d'inférence et serveur HTTP
- **Frontend HTML/JS** : Interface utilisateur intégrée
- **Base de connaissances** : Faits et règles sur les suspects
- **API REST** : Communication JSON

---

## 📡 API

### Endpoint d'Investigation

**GET** `/investigate`

**Paramètres :**
- `suspect` (string) : Nom du suspect (john, mary, alice, bruno, sophie)
- `crime` (string) : Type de crime (vol, assassinat, escroquerie)

**Exemple de requête :**
```bash
curl "http://localhost:8080/investigate?suspect=mary&crime=assassinat"
```

**Réponse JSON :**
```json
{
  "result": "guilty",
  "suspect": "mary",
  "crime": "assassinat"
}
```

---

## 🛠️ Développement

### Ajouter un Nouveau Suspect

1. **Déclarer le suspect**
```prolog
suspect(nouveau_suspect).
```

2. **Ajouter les faits**
```prolog
has_motive(nouveau_suspect, crime_type).
was_near_crime_scene(nouveau_suspect, crime_type).
```

3. **Mettre à jour l'interface HTML**
```html
<option value="nouveau_suspect">Nouveau Suspect</option>
```

### Ajouter un Nouveau Crime

1. **Créer la règle**
```prolog
is_guilty(Suspect, nouveau_crime) :-
    suspect(Suspect),
    nouvelle_condition(Suspect, nouveau_crime).
```

2. **Ajouter les faits nécessaires**
```prolog
nouvelle_condition(suspect_name, nouveau_crime).
```

---

## 🤝 Contribuer

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **Commit** vos changements (`git commit -am 'Ajouter nouvelle fonctionnalité'`)
4. **Push** la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. **Créer** une Pull Request

---

## 📚 Ressources

- [SWI-Prolog Documentation](https://www.swi-prolog.org/pldoc/)
- [Prolog Tutorial](https://www.swi-prolog.org/pldoc/man?section=quickstart)
- [HTTP Library Guide](https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/http.html%27))
