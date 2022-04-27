<div align='center'><img src='https://user-images.githubusercontent.com/65407488/147992899-93998c0a-75fb-4055-8c06-8da8c49342d6.png'/></div>
<div align='center'><h3><a href='https://overextended.github.io/docs/ox_inventory/'>Přečti dokumentaci pro nastavení, instalaci a integraci</a></h3></div>


# Rámec

Inventář byl navržen se záměrem posunout se směrem k obecnější / samostatné struktuře, aby jej bylo možné integrovat do jakéhokoli rámce bez přílišných potíží. _někdy brzy_ napíšu průvodce pro ruční nastavení podpory. Mezitím bude fungovat bez jakýchkoli změn, pokud použijete nejnovější aktualizace **[ESX Legacy](https://github.com/esx-framework/esx-legacy)**.

# Konfigurace
Viz [dokumentace](https://overextended.github.io/docs/ox_inventory/) nastavení vaší konfigurace.
Po nastavení můžete do souboru 'server.cfg'
```
exec @ox_inventory/config.cfg
ensure ox_inventory
```

# Protokolování

Zahrnutý protokolovací modul využívá datadog k ukládání protokolovaných dat, které lze rozšířit pro lepší analytiku a metriky. Zaregistrujte si účet na [datadoghq](https://www.datadoghq.com/).
_bezplatný plán_ je dostačující pro většinu uživatelských účelů a poskytuje mnohem více užitečných funkcí než typické podivné protokoly neshod používané v jiných zdrojích.

Jakmile se zaregistrujete, vygenerujte klíč API a přidejte `set datadog:key 'apikey'` do konfigurace serveru.


# Funkce

### Obchody

- Vytváří různé obchody pro 24/7, střelivo, obchody s alkoholem, prodejní automaty atd.
- Obchody s omezeným zaměstnáním, jako je policejní zbrojnice.
- Položky lze omezit na konkrétní pracovní zařazení a licence.
- Definujte cenu pro každou položku a dokonce povolte jinou měnu (černé peníze, pokerové žetony atd.).


### Položky

- Obecná data položky sdílená mezi objekty.
- Specifická data uložená pro každý slot s metadaty pro uložení vlastních informací.
- Zbraně, příslušenství a odolnost.
- Flexibilní použití položek umožňuje ukazatele průběhu, zpětná volání serveru a zrušení pomocí jednoduchých funkcí a exportů.
- Podpora pro položky registrované u ESX.


### Skrýše

- Zabezpečení na straně serveru zabraňuje libovolnému přístupu k jakékoli skrýši.
- Podpora osobních úložišť, které lze otevřít s různými identifikátory.
- Úkryty s omezeným zaměstnáním a také skříňka na policejní důkazy.
- Exporty serveru umožňují registraci skrýší z jakéhokoli zdroje (viz [zde](https://github.com/overextended/ox_inventory_examples/blob/main/server.lua)).
- Přístup k malým skrýšám prostřednictvím kontejnerů, jako jsou papírové sáčky, z používání předmětu.
- Odkládací schránky a kufry vozidel, pro vlastní i nevlastní.


### Dočasné skrýše

- Popelnice, kapky a vozidla pro nehráče.
- Loot tables umožňují uživatelům najít náhodné položky v kontejnerech a ve vozidlech, která nevlastní.


<br><div><h4 align='center'><a href='https://discord.gg/overextended'>Server Discord</a></h4></div><br>


<table><tr><td><h3 align='center'>Právní doložky</h2></tr></td>
<tr><td>
Ox Inventory pro ESX Legacy

Copyright © 2022 [Linden](https://github.com/thelindat), [Dunak](https://github.com/dunak-debug), [Luke](https://github.com/LukeWasTakenn)


Tento program je svobodný software: můžete jej dále distribuovat a/nebo upravovat
to za podmínek GNU General Public License, jak byla zveřejněna
Free Software Foundation, buď verze 3 licence, nebo
(podle vašeho uvážení) jakékoli pozdější verze.


Tento program je distribuován v naději, že bude užitečný,
ale BEZ JAKÉKOLI ZÁRUKY; dokonce bez předpokládané záruky
OBCHODOVATELNOST nebo VHODNOST PRO KONKRÉTNÍ ÚČEL. Viz
Další podrobnosti naleznete v GNU General Public License.


Měli byste obdržet kopii GNU General Public License
spolu s tímto programem.
Pokud ne, podívejte se na <https://www.gnu.org/licenses/>
</td></tr></table>
