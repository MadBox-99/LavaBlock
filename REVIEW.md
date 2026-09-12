# LavaBlock — teljes átvizsgálás

**Verzió:** 0.1.7 (`info.json:3`) · **Vizsgálat dátuma:** 2026-09-12 · **Módszer:** három párhuzamos modell-ügynök (kód, balansz, ökoszisztéma) + kézi visszaellenőrzés a forráson.

**Terjedelem:** 178 kódfájl (172 `.lua`), ~1 MB. A `graphics/` PNG-ket nem töltöttem le, csak a fájllistát — az asset-hivatkozásokat ez alapján ellenőriztem.

> **Frissítés — 2026-09-12.** A kén-recept kompatibilitási problémája (4.1 első sor) **javítva**: az `sulfur` klónozás + `hidden = true` helyett most egy saját `lava-block-lava-ocean` surface property választja szét a két receptet. Érintett fájlok: `prototypes/surface-properties.lua` (új), `data.lua`, `prototypes/island-generation.lua`, `prototypes/recipes/sulfur-lava.lua`, `data-final-fixes.lua`, `locale/en/LavaBlock.cfg`, `migrations/LavaBlock_0.1.8.json` (új).
>
> A 34 hivatkozás nélküli Pyroclast-fájl státusza **igazolva**: valóban halott kód (a Pyroclast 0.1.17 forrásában nincs cross-mod require a LavaBlockra).
>
> Ugyanekkor **két megállapítást visszavontam** a vanilla adatok ellenőrzése után — lásd a 2.6 szakasz utolsó két pontját (urán-baktérium).

---

## 0. Vezetői összefoglaló

A koncepció erős és a fájlszerkezet rendezett (moduláris `prototypes/` fa, külön recept-/tech-fájlok, changelog, CLAUDE.md fejlesztői doksi). A mod azonban **jelenleg négy különböző szinten törik**, és ezek közül kettő játékot indíthatatlanná tesz:

| Szint | Állapot |
|---|---|
| **Indíthatóság** | ❌ A kezdőkészletből nem vezet út az első lávacseppig — a játék 0 lépésnél megáll |
| **Térképgenerálás** | ⚠️ A `grass-1` autoplace valószínűleg hibára fut (elavult `basis_noise` hívás) |
| **Belső balansz** | ⚠️ Két ingyen-ebéd (anyag- és energiateremtés), több szigorúan dominált „fejlett" ág |
| **Más modokkal együttélés** | ❌ „Egyedüli mod" feltételezéssel íródott; a népszerű 2.0-s bolygómodok mellett a kén craftolhatatlanná válik |

A jó hír: **ezek javíthatók, és nagyrészt egysoros / kétsoros javítások.** A rossz hír: a mod jelen állapotában nem játszható végig, tehát a portálon lévő 0.1.6/0.1.7 minden letöltője falba fut.

**Amit a mod jól csinál** (érdemes megtartani): a vas/réz/szén kitermelési arányok egymáshoz képest tökéletesen konzisztensek (mind 0,5 érc / 100 láva); az energia tudatosan *nem* szűk keresztmetszet, a láva *mennyisége* a valuta — ez jó skyblock-design; a `control.lua` helyesen használja a 2.0-s `storage`-ot (sehol nincs `global`), nincs desync-kockázat; a `research_trigger`-alapú produktivitás-láncok (`ore-clearing-productivity`, `circuit-crafting-productivity`) görbéi egészségesek.

---

## 1. P0 — Játékot blokkoló hibák

### 1.1 Indulási deadlock: nincs út az első lávához ❗

`control.lua:110-127` — a kezdőkészlet: **1 chemical plant, 2 napelem, 1 kis oszlop, 2 fogaskerék, 3 cső.** A crashsite le van tiltva (`control.lua:100-107`, `set_created_items({})`), tehát más forrás nincs.

A zárt kör:

- Lávához **offshore pumpa** kell → a vanilla recept 2 elektronikus áramkör + 1 fogaskerék + 1 cső
- Áramkörhöz vas- és rézlemez kell → lemezhez érc → érc csak lávából (`prototypes/recipes/extraction/iron-extraction.lua`)
- **→ lávához láva kell.**

Kisegítő utak, amiket megvizsgáltam és mind zsákutca:

- `wood-extraction` (`prototypes/recipes/extraction/wood-extraction.lua:5,12`) — `enabled = true`, `category = "crafting"`, **nulla bemenet** → kézzel craftolható fa. De fából nincs áramkör.
- `steam-power` automatikusan kikutatva (`control.lua:155`) — a kazánhoz **víz** kell, víz csak `steam-condensation`-ből, ami gőzből, ami lávából.
- Sziklák: a `prototypes/island-generation.lua:42` `default_enable_all_autoplace_controls = false`-t állít, és az `autoplace_controls` táblát teljesen lecseréli (csak `enemy-base` + `trees` marad). Ha maradnának is sziklák, azok követ és szenet adnak, vasércet nem.

**Javítás (válassz egyet):**

```lua
-- control.lua:110-116 — a legkisebb beavatkozás:
player.insert({ name = "offshore-pump",       count = 1 })
player.insert({ name = "solar-panel",         count = 4 })   -- 2 → 4
player.insert({ name = "accumulator",         count = 1 })
player.insert({ name = "small-electric-pole", count = 4 })   -- 1 → 4
player.insert({ name = "pipe",                count = 10 })  -- 3 → 10
```

Másodlagos, de ide tartozó gond: **2 napelem = ~120 kW csúcs**, a chemical plant fogyasztása ~210 kW. A gyár nappal is csak ~57%-on pörögne, éjjel állna. Innen a 4 panel + 1 akkumulátor javaslat.

### 1.2 Elavult `basis_noise` hívás — a térképgenerálás elszáll ❗

`prototypes/noise-expressions/lava-block-generator.lua:12`

```lua
"(abs(basis_noise(x, y, map_seed, seed1, scale, 1)) > 0.88) & ..."
```

A Factorio 2.0-ban a beépített zajfüggvények **nevesített argumentumokat** várnak. A vanilla adatbázis kizárólag így hívja:
`"basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 123, input_scale = input_scale, output_scale = output_scale}"` ([factorio-data/base/prototypes/noise-expressions.lua](https://github.com/wube/factorio-data/blob/master/base/prototypes/noise-expressions.lua)). A projekt saját `CLAUDE.md`-je is ezt írja elő.

A kifejezés a `grass-1` `probability_expression`-jében fut, a `grass-1` pedig benne van a Nauvis tile-listájában (`prototypes/island-generation.lua:74`) → a hiba **új játék indításakor / map-gen előnézetben** jön elő, nem betöltéskor.

```lua
expression =
  "(abs(basis_noise{x=x, y=y, seed0=map_seed, seed1=seed1, input_scale=scale, output_scale=1}) > 0.88)"
.." & (abs(basis_noise{x=x+50, y=y+50, seed0=map_seed, seed1=seed2, input_scale=scale*0.5, output_scale=1}) > 0.85)"
.." & (abs(basis_noise{x=x-50, y=y-50, seed0=map_seed, seed1=seed1+seed2, input_scale=scale*0.3, output_scale=1}) > 0.87)"
```

Megjegyzés: a `map_seed + 1000` / `+ 5000` trükk is felesleges — a rétegeket a `seed1` különbözteti meg, a `seed0` mindig `map_seed`.

> ⚠️ Ez a jelentés egyetlen olyan pontja, amit nem tudtam 100%-ig bizonyítani (nem futtattam a játékot). A vanilla-konvenció és a saját CLAUDE.md alapján viszont nagy valószínűséggel hibás. **Egy új játék indítása 10 másodperc alatt eldönti.**

### 1.3 „Minden a lávából jön" — kivéve, hogy nem: ingyen anyagteremtés ❗

`prototypes/recipes/air/extraction/air-extraction.lua:6` → `ingredients = {}`

```
air-extraction:               (semmi)          → 500 compressed-air / 2 mp
air-electrostatic-adsorption: 500 compressed-air → 500 air          / 2 mp
extract-iron-from-air:        500 air           → 10 vasérc         / 2 mp
```

Az `air-compressor` `crafting_speed = 2.0` (`prototypes/entity/air-compressor.lua:6`), tehát minden lépés 1 mp → **3 géppel, 1:1:1 arányban 10 vasérc/mp, nulla anyagköltséggel.**

Összevetés ugyanerre a 10 érc/mp-re:

| | Gépek | Terület | Láva | Energia |
|---|---|---|---|---|
| Levegő-lánc | 3 × air-compressor (3×3) | **27 tile** | **0** | ~1,1 MW |
| Láva-lánc | 8 × chemical plant + ~7 pumpa | ~85 tile | **8000 láva/mp** | ~1,7 MW |

A changelog azt ígéri, hogy ez „throughput-matched … at a high energy cost" (`changelog.txt:22`), de az `air-compressor` az `assembling-machine-3` deepcopy-ja változatlan `energy_usage`-dzsel — **a levegős út energiában is olcsóbb.** Az `air-cooler` tech (`prototypes/technologies/air-cooler.lua`) után a teljes lávagazdaság feleslegessé válik.

**Javítás:**
```lua
-- air-extraction.lua
ingredients = { { type = "fluid", name = "steam", amount = 100 } },  -- vagy { item = "coal", amount = 1 }
energy_required = 4,
-- extraction-from-air.lua: 10 → 5 érc, energy_required = 4
-- entity/air-compressor.lua: energy_usage = "1500kW" explicit
```
Cél: a levegős út legyen ~1,5× jobb *terület/mp*-ben, de ~2× rosszabb *energiában*.

### 1.4 Ingyen energia: a cryo-lávahűtés termodinamikailag lehetetlen ❗

`prototypes/recipes/lava-cooling-with-liquid-nitrogen.lua:8-17`

3000 láva + 10 folyékony nitrogén → **2000 gőz @ 1000 °C** + melléktermékek (8 tégla, 0,5 kalcit, 4+4 lemez átlagban), 3 mp alatt.

| Tétel | Érték |
|---|---|
| Bemenet fűtőértéke (3020 × 25 kJ, `data-updates.lua:7`) | **75,5 MJ** |
| Kimenet nyers hőtartalma (2000 × 985 °C × 200 J) | **394 MJ** |
| Ebből gőzturbinával kinyerhető (max. 500 °C) | **194 MJ** |

**→ 2,6× (turbinával) ill. 5,2× (nyers hő) szorzó.** Ez egyben feleslegessé teszi a `geo-thermal-turbine`-t, ami **kétszer drágább technológia** (2000 vs. 1000 egység) és rosszabb output.

**Javítás:** `2000 gőz @ 1000 °C` → **`1500 gőz @ 500 °C`** (= 145 MJ, 1,9× szorzó — még mindig jutalmazó), vagy maradjon 1000 °C és csökkenjen **700 egységre**. A `stone-brick` valószínűségét 0,8 → 0,5-re érdemes venni (jelenleg ez a legolcsóbb téglaforrás: 377 láva/tégla).

### 1.5 Az `industrialised-chemical-plant` megszerezhetetlen és használhatatlan ❗

Három hiba egyszerre:

1. `prototypes/recipes/industrialised-chemical-plant.lua:6` → **`crafting_category = "chemical"`** — ilyen kulcs nincs a RecipePrototype-ban, a helyes név `category`. A recept így a default `"crafting"` kategóriába esik.
2. A recept `enabled = false`, és **semmilyen technológia nem oldja fel** (végiggrepeltem az összes tech-effektet).
3. Az entitás `crafting_categories = { "chemical" }` (`prototypes/entity/industrialised-chemical-plant.lua:6`), de a **`chemical` kategóriát egyetlen recept sem használja** a modban. A tényleges eloszlás: `chemistry` ×24, `crafting-with-fluid` ×17, `lava-centrifuge` ×5, `crafting` ×5, `cryogenic-cooling` ×4, `oil-processing` ×2, `gas-mix` ×2, `gas` ×2, **`chemical` ×0**.

Vagyis a gép nem gyártható le, és ha lenne is, üres lenne.

---

## 2. P1 — Balansz és progresszió

### 2.1 A „fejlett" kohászati ág rosszabb, mint a kezdő

| Útvonal | Számítás | **Láva / vaslemez** |
|---|---|---|
| **Alap**: `iron-extraction` → kőkohó | 1000 láva → 5 érc → 5 lemez | **200** |
| `iron-smelting` + `iron-smelting-cooling` | 5000 + 1000 = 6000 láva → 50 olvadt → 10 lemez | **600** |
| `iron-smelting` + cryo-cooling | 24 000 + 400 láva → 80 lemez | **305** |
| **Centrifuga**: `concentrated-ore-extraction` → kohó | 5000 láva → 100 érc → 100 lemez | **50** |

Az `advanced-lava-smelting` **666 egység × 66 mp = 43 956 labor-másodperc** (egy laborral ~12 óra) egy **3×-os visszalépésért**. A megtérüléshez ~16 produktivitási szint kellene. Mire a játékos odaér, a centrifuga-út (50 láva/lemez) amúgy is jobb.

**Javítás:** emeld az `iron-smelting`/`copper-smelting` hozamát 50 → **150 olvadt fémre** 5000 lávából — így az alapút azonnal paritásba kerül (200 láva/lemez), a produktivitás pedig valódi nyereség lesz. Emellett a cryo-receptek kapjanak `allow_productivity = true`-t, különben 30 szint után a gyengébb water-cooling recept 2×-esen veri őket.

### 2.2 Szigorúan dominált receptek (csapdák)

| Recept | LavaBlock | Alternatíva | Arány |
|---|---|---|---|
| `brick-smelting` (10 000 láva → 2 tégla) | **5000 láva/tégla** | kő → vanilla tégla: 800 | **6,25× rosszabb** |
| `lava-flying-robot-frame` (5000 láva az 1 acél helyett) | 5000 LE | 1 acél = 1000 LE | **5× rosszabb** |
| `lava-speed-module` | 7500 LE/db | vanilla ~6595 LE | 14% drágább **+ 1500 kutatás** |
| `lava-speed-module-2` | ~109 000 LE | vanilla ~108 570 | tiszta paritás **+ 750 kutatás** |
| `rare-mineral-extraction` (urán) | 1000 láva/érc | alap `uranium-extraction`: 1333 | csak **25% javulás** 1000 kutatásért |

A `brick-smelting` külön is problémás: 3333 láva/mp névleges igénye **fizikailag nem etethető** egy csőcsatlakozáson (~1000/mp körüli telítés). Ugyanez igaz a `steam-generation`-re (5000 láva/mp) és a `calcite-synthesis`-re (5000 láva/mp).

**Javítás:** `brick-smelting` → **2000 láva → 3 tégla** (667/tégla, kicsit jobb a kőútnál, és a rá épülő 5 produktivitás-szint értelmet nyer). `lava-flying-robot-frame` → 5000 → **1000 láva**. Modulreceptek: 10 000 → **4000**, 15 000 → **6000**, 40 000 → **15 000** láva.

### 2.3 Halott tartalom — kutatás nulla hatásért

| Elem | Költség | Probléma |
|---|---|---|
| `lava-modules` | 1000 egység | **`effects = {}`** (`prototypes/technologies/modules/lava-modules.lua:6`) |
| `enchanted-science-pack` | 1000 egység | **Egyetlen LavaBlock-tech sem fogyasztja** — csak a külön Pyroclast mod |
| `circuit-science-pack` | 300 egység + ~6690 LE/db | **Egyetlen felhasználó**: `circuit-crafting-productivity` |
| `geo-thermal-turbine` | 2000 egység | Valószínűleg **soha nem működik** (lásd 2.5), és amúgy is rosszabb a felénél árazott cryo-hűtésnél |
| `foundation-platform-disable` | 10 000 foundation trigger | ≈ **6,5 milliárd láva** → soha nem sül el. A `settings.lua:9` default 10000 ezért értelmetlen. Ráadásul a **katalizátort** tiltja le, nem a foundationt — a játékos előre bespájzolhat (stack 100) |
| `prototypes/recipes/pyroclast/**`, `technologies/pyroclast-*`, `planet/pyroclast.lua`, `tiles/sulfuric-acid-lake.lua`, `recipes/crafting-machine-tints/*` | **34 fájl** | **Igazolt halott kód.** A require-gráf a belépési pontokból (`data.lua`, `data-updates.lua`, `data-final-fixes.lua`, `control.lua`, `settings.lua`) nem éri el őket, és a különálló **Pyroclast 0.1.17 sem** hivatkozik rájuk: nincs benne egyetlen `require("__LavaBlock__…")` sem, és nem is függ a LavaBlocktól. Saját, **újabb** másolata van mindegyikből (pl. `pyroclast-generator.lua` 11 341 B vs. a LavaBlockban maradt 7 677 B). Azonos prototípusnevek → mivel a LavaBlock a Pyroclast **után** tölt be, egy véletlen visszakapcsolás a régi változatokkal írná felül az újakat |

### 2.4 A `military-science-pack-2` és az aszteroida-produktivitás árazása

A `military-science-pack-2` receptje (`prototypes/recipes/military-science-pack-2.lua`) **5 uránium-235 + 1 elektromagnetikus üzem** → 2 csomag. Ez csomagonként **fél elektromagnetikus üzem + 2,5 U-235**, ami láva-ekvivalensben ~4,8 millió.

Erre épül az `asteroid-productivity-simple/advanced` `count_formula = "1.5^L*1000"`:

| Szint | Kutatási egység | = ennyi elektromagnetikus üzem |
|---|---|---|
| 1 | 1 500 | 750 |
| 5 | 7 594 | 3 797 |
| 10 | 57 665 | **28 832** |
| 20 | 3 325 257 | **1 662 628** |

**Az 1. szint sem szerezhető meg.** Ráadásul a prereq (railgun + tesla + tüzérség + urán + EM-üzem) a teljes végjáték, miközben az aszteroida-produktivitás a vanillában korai Space Age tartalom → **fordított progresszió**.

**Javítás:** a receptben az `electromagnetic-plant` helyett 10 szupravezető + 10 volfrámkarbid, `uranium-235` 5 → 1, eredmény 2 → 4. A `count_formula` `1.5^L*1000` → **`1.2^L*1000`** (ez a mod saját, jól működő `circuit-crafting-productivity` görbéje). A `military-science-pack-2` prereq vegyük le az aszteroida-produktivitásról.

### 2.5 Ellenőrizendő: működik-e egyáltalán a geo-thermal turbine?

`prototypes/entity/geo-thermal-turbine.lua:16-17` → `fluid_box.filter = "lava"`, `minimum_temperature = 1000`. A Space Age lávájának alapértelmezett hőmérséklete ennél alacsonyabb, és a mod sehol nem írja felül (csak a `fuel_value`-t, `data-updates.lua:7`). **Ha így van, a turbinába soha nem lehet lávát tölteni.** Ez egy 2000 egységes technológia — érdemes egy teszt-indítással ellenőrizni.

### 2.6 Egyéb balansz-megjegyzések

- **A kezdősziget ~8× nagyobb a hirdetettnél.** `prototypes/noise-expressions/lava-block-generator.lua:44` → `(40 - distance) / 10` = **~40 tile sugarú, ~5027 tile** szárazföld. A `control.lua:161-163` 25×25-ös landfill-foltja csak erre rakódik rá. A területszűke mint mechanika a korai-közép játékban gyakorlatilag nem létezik. Javaslat: `(14 - distance) / 5` (~28×28).
- **A README fő ígérete nincs implementálva.** „Land can only be expanded through research" (`README.md:21`, `info.json:25`) — **nincs ilyen technológia**. A `landfill` recept `enabled = true` az első pillanattól (`prototypes/items/landfill.lua:2`). A locale-ban árválkodnak a nem létező `lava-block-add-landfill` / `lava-block-nullius-add-landfill` kulcsok (`locale/en/LavaBlock.cfg:51-52,90`).
- **A centrifuga-ugrás túl nagy:** `concentrated-ore-extraction` 4×-es javulás (200 → 50 láva/érc) egyetlen 500-egységes technológiáért. Javaslat: 50+50 érc → **30+30** (= 83 láva/érc, 2,4×).
- **`concentrated-ore-extraction` rossz kategóriában:** `category = "crafting-with-fluid"` (`prototypes/recipes/centrifuge/concentrated-ore-extraction.lua:6`), miközben a `lava-centrifuge` entitás csak `{"lava-centrifuge"}`-t tud. A recept az AM3-ban készül, a centrifugában nem.
- **Az AM3 univerzális géppé válik** (`data-updates.lua:8-26`): megkapja a `smelting`, `chemistry`, `gas`, `pressing`, `metallurgy-or-assembling`, `cryogenics-or-assembling` kategóriákat. 4 modulhely + 1,25 sebesség mellett ez kiiktatja a kohókat és részben a vegyi üzemeket — a gépválasztás mint designelem eltűnik.
- **Urán-baci: ~~exploit~~ → vanilla-paritás.** *(Javítva 2026-09-12: az eredeti megállapítás téves volt.)* A `prototypes/recipes/fulgora/bacteria/uranium.lua:56-63` 1→4 szorzója **pontosan a vanilla**: a Space Age `iron-bacteria-cultivation` és `copper-bacteria-cultivation` is 4 darabot ad. A `surface_conditions` `pressure = 2000` szintén **helyes** — [a wiki szerint](https://wiki.factorio.com/Planets) Gleba nyomása 2000 (nem 300), és a vanilla baci-receptek ugyanezt a feltételt használják. Itt tehát nincs balansz-hiba. **Ami viszont valóban gyanús:** a mod `result_is_always_fresh = true`-t ír (`:53`), miközben a vanilla `reset_freshness_on_craft = true`-t használ ugyanerre. Ha az előbbi nem érvényes mezőnév, csendben hatástalan — érdemes ellenőrizni.
- **A mod saját bolygó-táblája hibás volt:** a törölt `data-final-fixes.lua:47-52` **Glebát 300/15-tel, Aquilót 2000/20-szal** vette fel — ez a kettő fel van cserélve. A valóság: Gleba 2000/20, Aquilo 300/15, Fulgora 800/8, Vulcanus 4000/40, Nauvis 1000/10. A `sulfur-gleba` recept tehát Aquilón volt craftolható és fordítva. Ez a 0.1.8-as átírással tárgytalanná vált, de jó példa arra, miért törékeny a bedrótozott ujjlenyomat.
- **XP-rendszer = 2,3 óra kattintás.** A 4 questsor összesen 995 XP-csomag = 99 500 XP. A legjobb ráta ~12 XP/mp (elektronikus áramkör kézi craftolása) → **~8300 mp folyamatos kézi craftolás**. A jutalom (+25% lemez-produktivitás, +150% kézi craft, +100% bányászás) tisztán eltöltött időért jár, nem gyárépítésért. Két questsorban (`crafting-mastery.lua:29`, `smelting-mastery.lua:36`) a `count` mező **halott adat** — a tábla 100/500/2000/5000/10000 értékeket definiál, de a `unit.count` `10 * level` lesz belőle; nyilvánvalóan `research_trigger`-t akartál.
- **`XP_RATES["foundation-platform-nauvis"] = 10`** (`control.lua:29`) soha nem sül el: a recept eredménye `foundation`, nem `foundation-platform-nauvis` (`prototypes/recipes/foundation-platform.lua:18`). Emiatt a `prototypes/items/foundation-platform.lua` itemje is halott prototípus.

---

## 3. P2 — Kód- és karbantartási hibák

### 3.1 Latens crash: elírt prototípusnév

`prototypes/recipes/crafting-machine-tints/industrialised-chemical-plan.lua:11,18,35,38,40,44,46,50,52,71,93`

```lua
data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set...
```

Az entitás neve `industrialised-chemical-plan**t**` → `attempt to index a nil value`. **Jelenleg nem fut le** (a fájlt semmi nem require-olja), de aki bekapcsolja, azonnal load-errort kap. A grafikus útvonalak is az elírt mappára mutatnak (`graphics/entity/industrialised-chemical-plan/…`, valójában `…-plant/`) — **5 hiányzó PNG**.

Ráadásul a két tint-fájl gyakorlatilag azonos (8571 vs. 8578 bájt); a `biochamber.lua` a **vanilla Space Age biochamber**-t írná át destruktívan. Javaslat: az egyiket törölni, a másikat paraméteres függvénnyé alakítani.

### 3.2 `research_trigger.count` nem egész szám

`prototypes/technologies/foundation-platform-productivity.lua:38`

```lua
count = (x + ((x * x) / (x + 2)) * (x / (x + 1)) + (5 / (x + 1)) * ((x * x - x) / x)) + x + 10
```

A `count` **uint**, a képlet viszont törtet ad: x=2 → 16,33; x=5 → 26,31; x=10 → 41,67; x=30 → 101,9. A testvérfájl (`advanced-lava-smelting-productivity.lua:31`) helyesen használ `math.floor`-t. A barokk kifejezés effektíve `≈ 2x + 12`, tehát lineáris — semmit nem tesz hozzá.

Emellett **progressziós fal**: az 1. szint 5000 kő, a 2. szint 16 foundation ≈ 10,4 millió láva.

```lua
count = 10 + 5 * x   -- egész, olvasható, 15…160
```

### 3.3 `util.lua` árnyékolja a core util-t

A mod gyökerében lévő `util.lua:1` (`local util = {}`) miatt a modon belüli `require("util")` a saját fájlt adja vissza. A `lib/utils.lua:38` require-ol, de eldobja a visszatérési értéket, és a **globális** `util`-ra támaszkodik (`:56-59`, `util.merge`), amit csak mellékhatásként állít be a `prototypes/entity/air-cooler.lua:1` (`require("__core__.lualib.util")`).

Ez **véletlenül működik**, mert az `entities.lua:2` az air-coolert tölti be előbb. A require-sorrend bármely átrendezése `attempt to index nil (global 'util')` hibát okoz.

```lua
-- lib/utils.lua
local util = require("__core__.lualib.util")
```
És nevezd át a mod saját helperjét `lavablock-util.lua`-ra. (Jelenleg **három** egymást átfedő segédmodul van: `util.lua`, `lib/utils.lua`, `helpers/functions.lua`.)

### 3.4 `hr_version` — a HR grafikák soha nem töltődnek be

`prototypes/entity/air-cooler.lua:44,63` — a 2.0 megszüntette a `hr_version`-t. A négy `hr-*.png` halott tartalom, és a kisebb változat rajzolódik. Javítás: a HR fájl legyen a fő `filename`, `scale = 0.34375`, a `hr_version` blokk törlendő.

### 3.5 Duplikált recept-kategória

`prototypes/recipe-category.lua:18-25` — a `lava-centrifuge` **kétszer** szerepel ugyanabban a `data:extend`-ben; a második csendben felülírja az elsőt.

### 3.6 Hiányzó és árva locale-kulcsok

**Hiányzik:**
- `item-name.enchanted-science-pack` → „Unknown key" a tooltipben és a receptnéven
- `technology-name.tungsten-from-lava` (`prototypes/technologies/lava-centrifuge.lua:51`)
- `technology-name.enchanted-science-pack`

**Árva (nincs mögötte prototípus):** `lava-block-landfill-*` + `lava-block-starting-island-size` mod-settingek (10-35. sor — a `settings.lua` csak hármat definiál), `lava-block-square-island` (44), `lava-block-add-landfill` / `lava-block-nullius-add-landfill` (51-52), `lava-ore-washing-productivity` (57, 90), `oxygen` / `nitrogen` fluidok (149-150), `lava-block-island-management` item-group (154).

**Árnyékolt:** a 83-86., 89. és 104-108. sorok hatástalanok, mert a prototípusok inline `localised_name`/`localised_description` sztringet adnak meg (pl. `prototypes/technologies/circuit-science-pack.lua:4-5`). Egy nyelvre égetett angol szöveg lefordíthatatlan.

**Idegen kulcs felülírása:** `locale/en/LavaBlock.cfg:176` → `[recipe-name] locomotive=Locomotive` felülírja a base game receptnevét.

### 3.7 Migrációk

Egyetlen migráció van: `migrations/cooling-reorder.lua` — **verziószám nélkül**. A Factorio fájlnév alapján tartja nyilván a lefutott migrációkat ([Data lifecycle](https://lua-api.factorio.com/latest/auxiliary/data-lifecycle.html)), tehát a konvenció `LavaBlock_0.1.5.lua`. A `migrations/recipe-tech.lua` **0 bájtos** — törlendő.

**Lefedetlen:** a 0.1.1-es Pyroclast-kiszervezés prototípus-eltűnése (`.json` remap kellene, különben a régi mentésekből a kutatások/itemek szó nélkül eltűnnek), és a 0.1.5-ös prereq-változás.

### 3.8 `data.raw` nil-védelem nélkül

`data-updates.lua:1-6` — hat egymás utáni, 6 szintű indexelés védelem nélkül:

```lua
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["coal"] = nil
```

Ha bármely másik mod eltávolítja az `autoplace_settings.entity`-t, a LavaBlock crash-el. Ugyanez a 8., 28., 33. sorban.

### 3.9 1.1-es maradványok (a 2.0 figyelmen kívül hagyja)

- `prototypes/entity/air-compressor.lua:21-23,33-35`: `base_area`, `base_level`, `height` a fluid boxban (2.0-ban csak `volume`)
- `prototypes/fluids/*.lua`: `pressure_to_speed_ratio`, `flow_to_energy_ratio`
- `prototypes/fluids/gases/*.lua:4`: `group = "chemistry"` — a FluidPrototype-nak nincs `group` mezője
- `prototypes/items/industrialised-chemical-plan.lua:6`: `group = "chemistry"` ugyanígy
- `prototypes/fluids/liquid-nitrogen.lua:11`: `icon_size = 32` (2.0 konvenció: 64)

### 3.10 Apróságok

- **Nem prefixelt kategórianevek:** `chemical`, `cryogenic-cooling`, `gas-mix`, `gas` (`prototypes/recipe-category.lua`). A saját CLAUDE.md is prefixet ír elő.
- **18 `chemistry` subgroup, ebből 17 használatlan** (`prototypes/item-groups/chemistry.lua:17-119`): `rocket-fuel`, `space-chemicals`, `biochemicals`, `polymer-chemicals`… Ezek szabad, vonzó nevek, amiket bármelyik kémia-mod elfoglalhat.
- **Felhasználatlan grafikák:** `brick-smelt.png`, `compressor.png`, `entity/air-compressor.png`, `fluid/lava.png`, `fluid/tungsten_liquid_scaled.png`, `numerals/num-1*.png`, `slag*.png`, `pixel_art_small.png`, `stone-brick-smelting.png`, `recipes/compressed-air.png`, `recipes/air.webp` (a `.webp` amúgy sem támogatott sprite-formátum).
- **`control.lua:134`** — `game.print` egy force-specifikus eseményről; helyesebb `force.print`.
- **`control.lua:216`** — az `on_tick` handler mindig regisztrálva van, csak korai `return`-nel véd. Dinamikus regisztráció (`script.on_event(defines.events.on_tick, nil)`, ha kiürült a lista) olcsóbb.
- **`control.lua:155`** — a `steam-power` csak `on_init`-kor kutatódik le; a később létrehozott force-ok kimaradnak (`on_force_created`).
- **`settings.lua:15`** — `lava-block-use-instabots` beállítást a `control.lua` sehol nem olvassa.
- **Emoji nyers sztringben:** `prototypes/technologies/foundation-platform-disable.lua:11-12` → `"⚠️"`. A Factorio alap betűkészlete nem feltétlenül rendereli; a `[img=warning]` a bevált megoldás.
- **Changelog formai hibák:** `Date: ????` (3. sor); 7 üres kategória (4., 24., 35., 39., 43., 60., 235.); néhány 6-szóközös sor folytatássorként parse-olódik. *(Megjegyzés: a `CLAUDE.md` tévesen tiltja a `Compatibility` kategóriát — a [hivatalos lista](https://lua-api.factorio.com/latest/auxiliary/changelog-format.html) tartalmazza.)*

---

## 4. Kompatibilitás és ökoszisztéma

A mod **„egyedüli mod" feltételezéssel** íródott. Ez a leggyorsabban javítható növekedési akadály: ma minden népszerű 2.0-s bolygómod mellett elromlik valami.

### 4.1 Konkrét ütközés-előrejelzések

| Mod | Mi törik el | Ok (`fájl:sor`) | Javítás |
|---|---|---|---|
| ~~**Maraxsis** (82K), **Cerys** (76K), **Moshine** (62K), **Muluna** (60K), **Corrundum** (58K), **Rubia** (42K), **Paracelsin** (42K)~~ ✅ **JAVÍTVA 0.1.8** | **A kén craftolhatatlan lesz az adott bolygón** → kénsav, robbanóanyag, akkumulátor-lánc leáll | `data-final-fixes.lua:42` (`original_sulfur.hidden = true`) + `:47-52` (bedrótozott 5 elemű bolygólista) + `:64-67` (`min = max` ujjlenyomat) | **Megoldva:** saját `lava-block-lava-ocean` surface property, `default_value = 0` → minden idegen bolygó automatikusan a vanilla receptet kapja |
| **Krastorio 2 Spaced Out** (58K) | A K2SO Nauvis-nyersanyagai (rare metals, mineral water, imersite) eltűnnek; az AM3-hoz adott kategóriái elvesznek | `prototypes/island-generation.lua:42-53` (autoplace_controls tábla lecserélése), `data-updates.lua:8-26` (AM3 `=` értékadással) | Csak a konkrét kulcsokat töröld ciklusban; az AM3-nál `table.insert` |
| **Planet Picker** | **Nincs deklarálva inkompatibilisnek, mégis törik** — játékosonként külön kezdőbolygót ad, a LavaBlock viszont feltétel nélkül Nauvist írja át | `control.lua:158` (`game.get_surface("nauvis")` bedrótozva) | `! planet-picker` az info.json-ba |
| **NauvisWithEverything** | Koncepcionálisan kizáró | `data-updates.lua:1-6` | `! NauvisWithEverything` |
| **Bármely mod, ami az `electric-mining-drill` techhez nyúl** és a LavaBlock után tölt be | `attempt to index a nil value`, vagy „prerequisite doesn't exist" | `data.lua:13` (`remove_technology(...)`) | Ne töröld: `hidden = true` + `enabled = false`. Így minden hivatkozás él marad |
| **Bármely mod, ami az `asteroid-productivity`-ra hivatkozik** | Ugyanaz | `data-updates.lua:42` | Ugyanaz |
| **Minden gépet adó/tierező mod** | Az AM3 univerzálissá válik → a dedikált gépek feleslegesek | `data-updates.lua:8-26` | Új gépet adj (van is!), ne a vanilla AM3-at tedd univerzálissá |
| **Starting-kit / scenario modok** | A kezdő- és respawn-tárgyak **minden konfigurációváltozáskor** kinullázódnak | `control.lua:104-105`, meghívva `:152`-ben **és** `:174`-ben | `on_configuration_changed`-ben ne nullázd újra |
| **Vulcanus-terepet érintő modok** | A `volcanic-*` tile-ok autoplace-e globálisan kicserélődik `data-final-fixes`-ben → a LavaBlock **mindig** nyer | `data-final-fixes.lua:87-117` | Csak a saját bolygód `map_gen_settings.property_expression_names`-ében írd felül |
| **`grass-1`-et használó bolygómodok** | A saját bolygójukon megjelennek a LavaBlock szigetfoltjai | `prototypes/noise-expressions/lava-block-generator.lua:5-20` | Ugyanaz: per-bolygó override |
| **Pyroclast (saját mod)** | Fordított logika: **hard dependency** (`info.json:11`), miközben a kód `if mods["Pyroclast"]`-tel véd (`data-updates.lua:47`, `data-final-fixes.lua:55`) → minden játékos kénytelen egy WIP bolygót telepíteni | `info.json:11` | `? Pyroclast >= 0.1.17` — a guardok már készen állnak rá |

### 4.2 Egészben felülírás appendelés helyett

| Hely | Mit ír felül teljesen |
|---|---|
| `prototypes/technologies.lua:18-23` | `oil-processing.effects` — minden, amit más mod oda betett, elvész |
| `prototypes/technologies.lua:25` | `oil-gathering.effects` |
| `prototypes/technologies.lua:36-39` | `uranium-mining.effects` |
| `data-updates.lua:8-26` | `assembling-machine-3.crafting_categories` |
| `prototypes/items/landfill.lua:1-3` | `landfill` recept + stack size (ráadásul `data.lua` fázisban) |
| `prototypes/island-generation.lua:78` | maga a **`nauvis` bolygóprototípus** (`data:extend` csendben felülír, nincs hibaüzenet) |
| `data-final-fixes.lua:87-117,158-163` | Vulcanus tile-ok, `territory_settings` |

A mod **tudja, hogyan kell jól**: `prototypes/technologies.lua:42-45` és `data-updates.lua:28-36` szépen `table.insert`-tel appendel. Ezt kellene mindenhol.

> **Korrekció.** Az egyik ügynök azt állította, hogy az `oil-processing` átírásával a `chemical-plant` recept sehol nem nyílik meg. **Ez nem igaz** — a `prototypes/technologies/calcite-processing-on-lava-block.lua:11` visszaadja. A hatás így „csak" az, hogy idegen modok `oil-processing`-hez fűzött unlockjai vesznek el.

### 4.3 Javasolt `info.json`

```json
{
  "name": "LavaBlock",
  "version": "0.1.8",
  "title": "LavaBlock",
  "author": "Zoltán Tamás Szabó",
  "contact": "https://github.com/MadBox-99/LavaBlock/issues",
  "homepage": "https://github.com/MadBox-99/LavaBlock",
  "factorio_version": "2.0",
  "description": "Start on a tiny landfill island surrounded by lava. No ore patches, no mining: everything is extracted from lava in chemical plants. Rewrites Nauvis terrain and removes Nauvis ore patches — not compatible with other Nauvis-terrain or alternate-start mods.",
  "dependencies": [
    "base >= 2.0.55",
    "space-age >= 2.0.55",

    "? Pyroclast >= 0.1.17",

    "! any-planet-start",
    "! planet-picker",
    "! NauvisWithEverything",

    "(?) Krastorio2-spaced-out",
    "(?) maraxsis",
    "(?) planet-muluna",
    "(?) PlanetsLib",
    "(?) alien-biomes"
  ],
  "space_travel_required": true,
  "package": {
    "git_publish_branch": "main",
    "ignore": [
      "**/*.bat", "**/*.ps1", "**/*.exe", "**/*.sh",
      "node_modules/**", "package.json", "package-lock.json",
      ".claude/**", ".vscode/**", "docs/**", "CLAUDE.md"
    ]
  }
}
```

A `(?)` (rejtett opcionális) bejegyzések **nem függőségek**, csak betöltési sorrendet kényszerítenek: a LavaBlock így biztosan utánuk fut, tehát a Nauvis-átírása determinisztikusan felülkerül. Az előtag-szemantika: `!` inkompatibilis, `?` opcionális, `+` ajánlott, `(?)` rejtett opcionális ([mod-structure](https://lua-api.factorio.com/latest/auxiliary/mod-structure.html)).

A jelenlegi `package.ignore` (`info.json:15-22`) nem rekurzív (`*.bat` vs. `**/*.bat`), és beengedi a zipbe a `.claude/`-ot (6 fájl), `.vscode/`-ot (3), a `docs/prototype-types-reference.md`-t (45 KB), a `CLAUDE.md`-t (57 KB) és a 33 halott Pyroclast-fájlt.

### 4.4 Nincs integrációs felület

`grep -rn 'remote\.'` → csak `control.lua:101-105` (freeplay-hívások). Sem adat-, sem runtime-szinten nincs semmi, amin más mod bekapcsolódhatna. Minimális, olcsó API:

```lua
-- data stage (lavablock-api.lua, require-olva a data.lua elején)
LavaBlock = LavaBlock or {}
LavaBlock.categories = {                       -- prefixelt nevekkel!
  chemical   = "lavablock-chemical",
  gas        = "lavablock-gas",
  gas_mix    = "lavablock-gas-mix",
  cryo       = "lavablock-cryogenic-cooling",
  centrifuge = "lavablock-centrifuge",
}
function LavaBlock.add_lava_extraction(recipe) ... end
function LavaBlock.register_planet_sulfur(planet_name) ... end

-- control.lua
remote.add_interface("LavaBlock", {
  get_xp            = function(force_name) ... end,
  register_xp_rate  = function(item_name, xp) ... end,   -- ma bedrótozott: control.lua:8-30
  get_start_surface = function() ... end,
  set_start_surface = function(name) ... end,            -- Planet Picker / APS integrációhoz
})
```

Plusz két `bool-setting`, amivel a durva globális hatások kikapcsolhatók: `lava-block-modify-vanilla-sulfur` és `lava-block-modify-assembler-3` (mindkettő default `true`). Aki más overhaullal kombinál, kikapcsolja, és a mod többi része használható marad.

---

## 5. Amit érdemes átvenni más modoktól

1. **Zárt, felfedezhető bootstrap-hurok — [Sea Block](https://mods.factorio.com/mod/SeaBlock).** „Create resources using algae farms and sludge filtering. Expand your island using landfill." A Sea Block első hurkja önmagát magyarázza. A LavaBlocknál a három `player.print` sor (`control.lua:124-126`) ezt próbálja pótolni — multiplayerben elgörögnek, újracsatlakozáskor elvesznek.

2. **Beépített onboarding `tips-and-tricks-item`-mel** — [TipsAndTricksItem](https://lua-api.factorio.com/latest/prototypes/TipsAndTricksItem.html). `trigger`, `skip_trigger`, `dependencies` és `simulation` mezőkkel: az első lávakinyerésnél felugró, szimulációval illusztrált magyarázat. Vanilla prototípus, ingyen van.

3. **A „kezdj itt" rész külön kísérőmodként** — [moshine-start](https://github.com/henriquegemignani/moshine-start) mintája. `LavaBlock` = tartalom (láva-receptek, gépek, science packek, bárhol használható), `LavaBlock-start` = Nauvis-terep + ércek eltávolítása + kezdőkészlet. Így a jelenlegi `! any-planet-start` helyett **együtt** működne az APS-szel és a Planet Pickerrel.

4. **[PlanetsLib](https://github.com/danielmartin0/PlanetsLib)** a Pyroclast modhoz — 117K letöltés, 205 downstream mod. „Code, graphics **and conventions** to help modders creating planets." Kézi `planet` + `space-connection` definíció helyett ez adja a bolygóhierarchiát, a starmap-ikonokat és a más bolygómodokkal való együttélést.

5. **Aprólékos függőséglista** — [Krastorio 2 info.json](https://github.com/raiguard/Krastorio2/blob/master/info.json): ~20 `(?)` + 15 `!` bejegyzés, `package.ignore` a tesztekre és képekre. Ez a „dependency honesty" mércéje.

6. **Kompatibilitási patchek külön modként + portál-FAQ** — a [Nullius](https://mods.factorio.com/mod/nullius) nem inkompatibilitást deklarál, hanem 40+ modhoz szállít portolást, és a portál FAQ fülére irányít.

---

## 6. Portál-készültség

| Tétel | Állapot | Teendő |
|---|---|---|
| thumbnail | ✅ megvan | — |
| **LICENSE fájl** | ❌ **nincs a repóban** — miközben a `CREDITS.md` átvett MIT-kódot dokumentál (Corrundum / Zach Kolansky), az MIT pedig **előírja a licencszöveg szállítását** | `LICENSE` hozzáadása a zipbe |
| verziószám-konzisztencia | ❌ `README.md:76` „Version 0.0.34", `info.json` `0.1.7`, portálon `0.1.6` | README-ből vedd ki a verziósort |
| README ↔ valóság | ❌ „Land can only be expanded through research" — nincs ilyen kutatás. A Pyroclast-szekció már a másik modban van | Leírás átírása + link a Pyroclast modra |
| info.json metaadat | ❌ nincs `contact`, nincs `homepage` | lásd 4.3 |
| zip-tartalom | ❌ bekerül a `.claude/`, `.vscode/`, `CLAUDE.md` (57 KB), `docs/` (45 KB), 33 halott fájl | lásd 4.3 `package.ignore` |
| changelog | ⚠️ `Date: ????`, 7 üres kategória, néhány rossz behúzás | takarítás kiadás előtt |
| lokalizáció | ⚠️ csak `en`; idegen kulcsokat is felülír; halott kulcsok | takarítás + `locale/hu/` olcsó plusz |
| portál-FAQ | ❌ nincs | „Miért nem tudok X-et gyártani?", „Hogyan bővítem a szigetet?", „Melyik modokkal nem megy?" |

---

## 7. Javasolt akcióterv

**0.1.8 — „játszható" kiadás (fél nap)**

1. Kezdőkészlet: `offshore-pump` + 4 napelem + akkumulátor (1.1)
2. `basis_noise` nevesített argumentumokra (1.2) — **indíts egy új játékot, ez eldönti**
3. `crafting_category` → `category` az `industrialised-chemical-plant` receptben, és oldd fel egy technológiával (1.5)
4. `foundation-platform-productivity` count-képlet → `10 + 5 * x` (3.2)
5. Duplikált `lava-centrifuge` recept-kategória törlése (3.5)
6. `concentrated-ore-extraction` kategória → `lava-centrifuge` (2.6)
7. `lib/utils.lua` explicit `require("__core__.lualib.util")` (3.3)
8. Hiányzó locale-kulcsok pótlása (3.6)

**0.2.0 — balansz-pass (1-2 nap)**

9. `air-extraction` valódi bemenetet kap (1.3)
10. Cryo-lávahűtés energiakimenete visszavágva (1.4)
11. `brick-smelting`, `lava-flying-robot-frame`, modulreceptek újraárazása (2.2)
12. `iron-smelting`/`copper-smelting` hozam 50 → 150 (2.1)
13. `military-science-pack-2` + `asteroid-productivity` újraárazása (2.4)
14. `lava-modules` törlése vagy valódi effekt; `enchanted-science-pack` beépítése vagy törlése (2.3)
15. Urán-baci szorzó 4 → 2, `allow_productivity = false`, `surface_conditions` javítása (2.6)
16. Döntés: legyen-e valódi „Island Expansion" technológia, vagy írd át a README-t (2.6)

**0.3.0 — ökoszisztéma-pass (1-2 nap)**

17. `info.json` teljes átírása + `package.ignore` (4.3)
18. `remove_technology` helyett `hidden = true` mindenütt (4.1)
19. Kén-recept generálás minden bolygóra + fallback (4.1)
20. Globális felülírások per-bolygó override-ra (Vulcanus tile-ok, `grass-1`) (4.1)
21. Prototípusnevek prefixelése (`lavablock-gas` stb.) — **ez migrációt igényel** (3.10)
22. Halott Pyroclast-fájlok törlése + migrációs `.json` remapek (2.3, 3.7)
23. `LICENSE` fájl, README javítás, portál-FAQ (6)
24. Opcionális: `remote` interfész + két kompatibilitási beállítás (4.4)

---

## 8. Ellenőrzési napló

**Amit kézzel visszaellenőriztem a forráson** (nem csak ügynök-állítás): kezdőkészlet (`control.lua:110-127`), `air-extraction` üres ingredients, `brick-smelting` 10 000 láva, cryo-hűtés 2000 gőz @1000 °C, `crafting_category` elírás, `lava-modules` üres effects, duplikált recept-kategória, `oil-processing` effects-csere, `data-final-fixes` kén-logika, `basis_noise` pozicionális hívás, `island-generation` Nauvis-felülírás, `landfill` recept `enabled = true`, AM3 kategórialista, `(40 - distance) / 10` szigetméret.

**Egy ügynök-állítást megcáfoltam:** a `chemical-plant` recept **nem** vész el — a `calcite-processing-on-lava-block` technológia visszaadja.

**Ami bizonytalan és tesztet igényel:**

- A `basis_noise` pozicionális hívása valóban hibát dob-e (1.2) — vanilla konvenció és a saját CLAUDE.md alapján igen, de nem futtattam a játékot
- A láva alaphőmérséklete, és hogy emiatt a `geo-thermal-turbine` `minimum_temperature = 1000` filtere működik-e (2.5)
- Az `industrialised_factory.png` tényleges mérete — a `lib/utils.lua:54-60` 4096×256-os lapot feltételez
- A balansz-számokban a vanilla referenciaértékek (offshore pumpa 1200 fluid/mp, chemical plant 210 kW, napelem 60 kW, gőzturbina 5,82 MW, gőz 200 J/°C) emlékezetből származnak, nem base-fájlból
- A `bobplates` belső fluidnevei (`chlorine`/`oxygen`/`nitrogen` névütközés)

---

*Források: [Factorio mod-structure](https://lua-api.factorio.com/latest/auxiliary/mod-structure.html) · [changelog-format](https://lua-api.factorio.com/latest/auxiliary/changelog-format.html) · [data-lifecycle](https://lua-api.factorio.com/latest/auxiliary/data-lifecycle.html) · [TipsAndTricksItem](https://lua-api.factorio.com/latest/prototypes/TipsAndTricksItem.html) · [factorio-data](https://github.com/wube/factorio-data) · [PlanetsLib](https://github.com/danielmartin0/PlanetsLib) · [Krastorio 2](https://github.com/raiguard/Krastorio2/blob/master/info.json) · [moshine-start](https://github.com/henriquegemignani/moshine-start) · [Sea Block](https://mods.factorio.com/mod/SeaBlock) · [Nullius](https://mods.factorio.com/mod/nullius)*
