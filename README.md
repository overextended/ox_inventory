# hsn-inventory
Advanced Inventory System for Fivem

Setup / EN


Setup / TR
Stabil çalışması için es_extended v1 final kullanmak zorundasınız.
https://cdn.discordapp.com/attachments/800735373965525076/805815461932433408/unknown.png -- es_extended/server/main.lua
Üstteki satırları bulup benim eklediğim yere "TriggerEvent("hsn-inventory:setplayerInventory",xPlayer.identifier,xPlayer.inventory)" eventini eklemelisiniz.

https://cdn.discordapp.com/attachments/800735373965525076/805815947080106034/Screenshot_1.png -- es_extended/server/main.lua

üstteki kodların hepsini yorum satırına çevirin.

es_extended/server/functions.luada ESX.SavePlayer fonksiyonunu bulup bu şekilde çevirin.
https://pastebin.pl/view/fbce3242 -- code

Sunucu açıkken envanteri restartlarsanız itemlerinizin hepsi silinip extended kaydı olmayacaktır...
