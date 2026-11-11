# Une équipe d'agents qui ne communique que par le dépôt

Ce projet met en pratique la section 2 du cours 4 (« Les systèmes multi-agents : coordonner,
communiquer »). À partir d'une idée d'une ligne, une équipe d'agents opencode écrit un petit module
Python : sa spécification, son code, ses tests et sa revue. Les agents ne se parlent pas : ils
s'échangent des fichiers, par git.

## 1. Installation : opencode et un modèle

Comme au cours 3 : [opencode](https://opencode.ai), en version 2.2.5 ou plus récente, et un modèle.
Suivez la section 1 du [README du projet du cours 3](https://github.com/otrack/projet-aise-cours3/blob/main/README.md),
avec l'une de ses deux premières options :

- option A, Mistral : *Ministral 3 14B* (`mistral/ministral-14b-2512`) ;
- option B, un modèle gratuit d'OpenCode Zen, par exemple *DeepSeek V4.1 Flash Free*
  (`opencode/deepseek-v4.1-flash-free`).

L'option C (un modèle local, avec Ollama) est déconseillée ici, sauf si vous avez une machine
puissante : ce projet demande beaucoup plus de ressources locales que les TP précédents. Il faut aussi
git, et Python 3.10 ou plus.

Les commandes ci-dessous utilisent le modèle de l'option A : avec l'option B, remplacez
`mistral/ministral-14b-2512` par `opencode/deepseek-v4.1-flash-free`.

## 2. L'équipe

Un *lead* et quatre sous-agents, chacun avec un seul rôle, et ses propres fichiers :

| agent | rôle | ses fichiers |
|---|---|---|
| `lead` | appelle chaque sous-agent à son tour, puis fusionne sa branche dans `main` | aucun |
| `product-manager` | transforme l'idée en spécification | `SPEC.md` |
| `coder` | implémente la spécification | `src/<module>.py` |
| `qa-tester` | écrit les tests à partir de `SPEC.md`, **sans lire le code**, les lance | `tests/test_<module>.py`, `QA_REPORT.md` |
| `reviewer` | relit le tout, et rend un verdict | `REVIEW.md` |

Les règles de l'équipe sont dans [`AGENTS.md`](AGENTS.md), que lisent tous les agents :

- **une branche par agent** : chaque sous-agent travaille dans son propre *worktree* git,
  `.worktrees/<agent>`, sur sa branche `agent/<agent>` ; un *worktree* est un second répertoire de
  travail du même dépôt, sur une autre branche ;
- **les échanges passent par `main`** : avant de travailler, un agent fusionne `main` dans sa
  branche ; quand il a fini, il commite, et le *lead* fusionne sa branche dans `main` ;
- **chaque fichier a un seul propriétaire**, le seul à le modifier : deux agents n'éditent jamais
  le même fichier, donc les fusions se font sans conflit ;
- **l'oracle reste indépendant** : le qa-tester ne lit jamais `src/`.

Ces règles ne sont pas que des consignes : les **permissions** de chaque agent les imposent. Par
exemple, celles du qa-tester, dans `.opencode/agents/qa-tester.md`, lui interdisent de lire le code,
dans tous les *worktrees* (`*` reconnaît aussi `/`), et ne lui laissent modifier que ses fichiers :

```yaml
  - action: read
    resource: "*src/*"
    effect: deny
```

Une règle `deny` est appliquée par opencode, quoi que décide le modèle : celui-ci reçoit
`Permission denied: read`.

| fichier | rôle |
|---|---|
| `AGENTS.md` | les règles de l'équipe |
| `.opencode/agents/<agent>.md` | chaque agent : sa description, ses permissions, son *prompt* |
| `.opencode/skills/<agent>/SKILL.md` | le savoir-faire de chaque sous-agent, qu'il charge en premier |
| `.opencode/commands/team.md` | la commande `/team` (détaillée ci-dessous) |
| `opencode.json` | les permissions communes à tous les agents |
| `team.sh` | la même équipe, dirigée par un script au lieu du *lead* (section 5) |

## 3. Lancer l'équipe

Depuis ce répertoire, marquez d'abord le point de départ, pour pouvoir y revenir :

```sh
git tag -f depart
```

Puis lancez opencode, choisissez le modèle (`/models`), et donnez l'idée à la commande `/team` :

```text
/team un module Python de conversion en chiffres romains
```

`/team` crée les *worktrees* des quatre sous-agents, puis confie l'idée au *lead*. Le *lead*
appelle le product-manager, le coder, le qa-tester et le reviewer, l'un après l'autre, et fusionne
la branche de chacun dans `main` ; si le reviewer demande des changements, il fait un tour de
correction, et un seul. Comptez plusieurs dizaines de requêtes au modèle.

Si vous ne souhaitez pas utiliser l'interface d'opencode, attention : `opencode run` ne reconnaît pas
les commandes. Donnez alors l'idée directement au *lead*, qui crée lui-même les *worktrees* :

```sh
opencode run --agent lead --model mistral/ministral-14b-2512 "Idée : un module Python de conversion en chiffres romains"
```

Pour repartir de zéro, supprimez les *worktrees* et les branches des agents, puis revenez au point
de départ :

```sh
for a in product-manager coder qa-tester reviewer; do
  git worktree remove --force .worktrees/$a; git branch -D agent/$a
done
git reset --hard depart
```

## 4. Observer le résultat

Le dépôt garde la trace de tout ce que l'équipe a fait :

```sh
git log --graph --all --oneline              # une branche par agent, et ses fusions dans main
git log --oneline agent/qa-tester            # l'historique d'une branche
git show agent/coder                         # le dernier commit du coder
git diff depart main --stat                  # tout ce que l'équipe a produit
git log --format='%h %s' -- src/             # qui a modifié src/ ?
python3 -m unittest discover -s tests -v     # les tests, sur main
```

Puis lisez `SPEC.md`, `QA_REPORT.md` et `REVIEW.md`, à la racine.

## 5. Variante : un *lead* qui n'est pas un modèle

`team.sh` joue le rôle du *lead*, sans modèle : il crée les *worktrees*, lance chaque sous-agent
avec `opencode run`, dans un ordre fixé, et fusionne sa branche dans `main`. Les sous-agents, leurs
*skills* et leurs permissions sont les mêmes qu'avec `/team`.

```sh
./team.sh "un module Python de conversion en chiffres romains" mistral/ministral-14b-2512
```

C'est la différence entre un *workflow*, dont le code fixe l'enchaînement, et un agent, qui le
décide : le premier est plus prévisible, le second plus souple.

## 6. Les tâches

1. **Lancer l'équipe**, sur l'idée ci-dessus, puis lire son travail. Qui a commité quoi, et sur
   quelle branche ? Chaque fichier n'a-t-il été modifié que par son propriétaire ? Les tests
   couvrent-ils chaque critère d'acceptation de `SPEC.md` ? Passent-ils sur `main` ? Le verdict du
   reviewer est-il justifié ?
2. **Changer d'idée** : repartez de zéro, et donnez à l'équipe une autre idée, par exemple
   « un module Python qui vérifie un numéro IBAN », ou « la distance d'édition entre deux mots ».
   Où l'équipe se trompe-t-elle ? Une erreur de la spécification se retrouve-t-elle dans le code
   et dans les tests ?
3. **Changer une règle**, et observer l'effet :
   - demandez au qa-tester de lire le code, et lisez sa réponse :
     `opencode run --agent qa-tester --model mistral/ministral-14b-2512 "Lis .worktrees/qa-tester/src/ avant d'écrire les tests. Your worktree is .worktrees/qa-tester."` ;
   - ajoutez une convention à `AGENTS.md` (par exemple : toute fonction lève `TypeError` sur un
     argument du mauvais type), commitez-la, et relancez l'équipe : qui la respecte, qui l'oublie ?
   - le coder et le qa-tester ne dépendent que de `SPEC.md` : modifiez le *prompt* du *lead* pour
     les lancer en parallèle (l'outil `subagent` a une option `background`).
