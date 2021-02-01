
    var disabled = false
    var drag = false
    var dropLabel = 'Drop'
    var dropName = 'drop'
    var toplamkg = 0
    var rightinvKg = 0
    var count = 0
    var dropweight = 50
    var dropSlots = 50
    var rightinvtype = null
    var inventoryidd = null
    var timer = null
    var HSN = []
    var leftinventory = 'playerinventory'
    var rightinventory = null
    Display = function(bool) {
        if (bool) {
            $(".inventory-main").fadeIn(300);
            $('.inventory-main').show()
        } else {
            $(".inventory-main").fadeOut(300);
            $('.inventory-main').hide()
            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
            $(".item-slot").remove();
            $(".ItemBoxes").remove();
            $(".inventory-main-leftside").find(".item-slot").remove();
            $('.inventory-main-rightside').removeData("invId")
            toplamkg = 0
        }
    }
    console.log("[hsn-inventory] = Successfully Loaded :)")
    Display(false)
    window.addEventListener('message', function(event) {
        if (event.data.message == 'openinventory') {
            HSN.SetupInventory(event.data)
            DragAndDrop()
        } else if (event.data.message == 'close') {
            Display(false)
            inventoryidd = null

        } else if (event.data.message == 'refresh') {
            HSN.RefreshInventory(event.data)
        } else if (event.data.message == 'hsn-hotbar') {
            HSN.Hotbar(event.data.inventory) 
        }else if (event.data.message == "notify") {
            HSN.NotifyItems(event.data.item,event.data.text)
        }
    })

    HSN.Hotbar = function(inventory) {
        var durability = HSN.InventoryGetDurability(100)
        // // soon
    }



    HSN.NotifyItems = function(item, text) {
        if (timer !== null) {
            clearTimeout(timer)
        }
        var $itembox = $(".itembox-container.template").clone();
        $itembox.removeClass('template');
        $itembox.html('<div id="itembox-action"><p>' + text + '</p></div><div id="itembox-label"><p>'+item.label+'</p></div><div class="itembox-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div>');
        $(".itemboxes-container").prepend($itembox);
        $itembox.fadeIn(250);
        setTimeout(function() {
            $.when($itembox.fadeOut(300)).done(function() {
                $itembox.remove()
            });
        }, 3000);
    }

    HSN.InventoryGetDurability = function(quality) {
        if (quality == undefined || null) {
            quality = 100
        }
        var color = "#0bb80b"
        var text = "PERFECT"
        var width = 100
        if (quality == 100) {
            color = "#0bb80b",
            text = parseInt(quality).toFixed(2),
            width = quality
        } else if (quality >= 80 && quality <= 100) {
            color = "#0bb80b",
            text = parseInt(quality).toFixed(2),
            width = quality
        } else if (quality >= 50 && quality <= 80) {
            color = "#0bb80b81",
            text = parseInt(quality).toFixed(2),
            width = quality
        } else if (quality >= 20 && quality <= 50) {
            color = "#ca790fcb",
            text = parseInt(quality).toFixed(2),
            width = quality
        } else if (quality >= 1 && quality <= 20) {
            color = parseInt(quality).toFixed(2),
            text = "BAD",
            width = quality
        } else if (quality == 0) {
            color = "crimson",
            text = "BROKEN",
            width = 100
        }
        return [color = color,text = text,width = width];

    }

    HSN.RefreshInventory = function(data) {
        $.each(data.inventory, function (i, item) {
            if ((item != null)) {
                toplamkg = toplamkg +(item.weight * item.count);
                if ((item.name).split("_")[0] == "WEAPON") {
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                    var durability = HSN.InventoryGetDurability(item.metadata.durability)
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[2]}).find('p').html(durability[1]);
                } else {
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                }
            }
        })
    }
    

    HSN.InventoryMessage = function(message, type) {
        $.post("http://hsn-inventory/notification", JSON.stringify({
            message: message,
            type: type
        }));
    }

    HSN.RemoveItemFromSlot = function(inventory,slot) {
        inventory.find("[inventory-slot=" + slot + "]").removeData("ItemData");
        inventory.find("[inventory-slot=" + slot + "]").find(".item-slot-label").remove();
        inventory.find("[inventory-slot=" + slot + "]").find(".item-slot-img").remove();
        inventory.find("[inventory-slot=" + slot + "]").find(".item-slot-count").remove();
    }


    HSN.SetupInventory = function(data) {     
        $('.playername').html(data.name)
        for(i = 1; i < (data.slots); i++) {
            $(".inventory-main-leftside").find("[inventory-slot=" + i + "]").remove();
            $(".inventory-main-leftside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
            //$(".inventory-main-rightside").data("Owner", data.rightinventory.type);
        }
        Display(true)
        // player inventory
        $('.inventory-main-leftside').data("invTier", "Playerinv")
        $.each(data.inventory, function (i, item) {
            if ((item != null)) {
                toplamkg = toplamkg +(item.weight * item.count);
                if ((item.name).split("_")[0] == "WEAPON") {
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                        var durability = HSN.InventoryGetDurability(item.metadata.durability)
                        $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0], "width": durability[2]}).find('p').html(durability[1]);
                } else {
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                    $(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                }
            }
        })


        $(".leftside-weight").html(toplamkg.toFixed(1) + '/'+ data.maxweight+ 'kg' )
        if (data.rightinventory !== undefined) {
            $('.inventory-main-rightside').data("invTier", data.rightinventory.type)
            $('.inventory-main-rightside').data("invId", data.rightinventory.name)
            inventoryidd = data.rightinventory.name
            rightinvtype = data.rightinventory.type
            $('.rightside-name').html(data.rightinventory.name)
                for(i = 1; i < (data.rightinventory.slots); i++) {
                    $(".inventory-main-rightside").find("[inventory-slot=" + i + "]").remove();
                    $(".inventory-main-rightside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
                    $(".inventory-main-rightside").find("[inventory-slot=" + i + "]").addClass("drag-item");
                }
                if (data.rightinventory.type == 'shop') {
                    inventoryidd = data.rightinventory.name
                    $(".rightside-weight").html("") // hide weight 
                    $.each(data.rightinventory.inventory, function (i, item) {
                        if ((item != null)) {
                            if ((item.name).split("_")[0] == "WEAPON") {
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.price) + '$)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                                    var durability = HSN.InventoryGetDurability(item.metadata.durability)
                                    $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width":durability[2]}).find('p').html(durability[1]);
                            } else {
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.price) + '$)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                            }
                        }
                    })
                } else {
                    var rightweight = 0
                $.each(data.rightinventory.inventory, function (i, item) {
                    if ((item != null)) {
                        rightweight = rightweight +(item.weight * item.count);
                        $(".rightside-weight").html(rightweight.toFixed(1) + '/'+ 100 + 'kg' )
                        if ((item.name).split("_")[0] == "WEAPON") {
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                                var durability = HSN.InventoryGetDurability(item.metadata.durability)
                                $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[2]}).find('p').html(durability[1]);
                        } else {
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.weight * item.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
                            $(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
                        }
                    }
                })
            }
        } else {
            $('.rightside-name').html("Drop")
            $('.inventory-main-rightside').data("invTier", "drop")
            rightinvtype = 'drop'
            $(".rightside-weight").html(0 + '/'+ dropweight + 'kg' )
            for(i = 1; i < (dropSlots); i++) {
                $(".inventory-main-rightside").find("[inventory-slot=" + i + "]").remove();
                $(".inventory-main-rightside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
            }
        }
    }

    

    
    function DragAndDrop() {
        $(".drag-item").draggable({
            helper: 'clone',
            appendTo: "body",
            scroll: true,
            revertDuration: 0,
            revert: "invalid",
            cancel: ".itemdragclose",
            start: function(event, ui) {
                IsDragging = true;
                $(this).find("img").css("filter", "brightness(50%)");
                var itemData = $(this).data("ItemData");
                count = $("#item-count").val();
            },
            stop: function() {
                setTimeout(function(){
                    IsDragging = false;
                }, 300)
                $(this).find("img").css("filter", "brightness(100%)");
            },
        });
    
        $(".ItemBoxes").droppable({ // player inventory slots
            hoverClass: 'ItemBoxes-hoverClass',
            drop: function(event, ui) {
                setTimeout(function(){
                    IsDragging = false;
                }, 300)
                 curslot = ui.draggable.attr("inventory-slot");
                 fromInventory = ui.draggable.parent();
                 var inv = fromInventory.data('invTier')
                 toInventory = $(this).parent()
                 toSlot = $(this).attr("inventory-slot");
                 fromData = fromInventory.find("[inventory-slot=" + curslot + "]").data("ItemData");
                if (count == "" || count == 0) {
                    count = fromData.count
                }
                SwapItems(fromInventory, toInventory, curslot, toSlot)
            },
        });
    
         $(".use").droppable({
            hoverClass: 'button-hover',
            drop: function(event, ui) {
                setTimeout(function(){
                    IsDragging = false;
                }, 300)
                fromData = ui.draggable.data("ItemData");
                fromInventory = ui.draggable.parent();
                inv = fromInventory.data('invTier')
                    $.post("http://hsn-inventory/UseItem", JSON.stringify({
                        item: fromData,
                        inv : inv
                    }));
                    if (fromData.closeonuse) {
                        HSN.CloseInventory()
                    }
            }
        });
    }


    $(document).on("mouseenter", ".ItemBoxes", function(e){
        e.preventDefault();
        var Item = $(this).data("ItemData")
        if (Item != undefined) {
            $(".iteminfo").fadeIn(100);
            $(".iteminfo-label").html('<p>'+Item.label+'</p>')
            $(".iteminfo-description").html('<p><strong>'+Item.description+'<p><strong>')
            if ((Item.name).split("_")[0] == "WEAPON") {
                if (Item.metadata.weaponlicense == null || undefined) {
                    Item.metadata.weaponlicense = "HSN"
                }
                if (Item.metadata.durability == null || undefined) {
                    Item.metadata.durability = 100
                }
                if (Item.metadata.ammo == null || undefined) {
                    Item.metadata.ammo = "Unknown"
                }
                $(".iteminfo-description").append('<p>Weapon License: <strong>'+Item.metadata.weaponlicense+'<p><strong>')
                $(".iteminfo-description").append('<p>Durability: <strong>'+parseInt(Item.metadata.durability).toFixed(2)+''+'%<p><strong>')
                $(".iteminfo-description").append('<p>Weapon Ammo : <strong>'+Item.metadata.ammo+'<p><strong>')
            }
        } else {
            $(".iteminfo").fadeOut(100);
        }
    });

    HSN.CloseInventory = function() {
        $.post('http://hsn-inventory/exit', JSON.stringify({
            type : rightinvtype,
            invid : inventoryidd
        }));
        
        Display(false)
    }


    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://hsn-inventory/exit', JSON.stringify({
                type : rightinvtype,
                invid : inventoryidd
            }));
            Display(false)
            return
        }
    };
    $(document).on('click', '.close', function(e){
        $.post('http://hsn-inventory/exit', JSON.stringify({
            type : rightinvtype,
            invid : inventoryidd
        }));
        
        Display(false)
    });

    SwapItems = function(fromInventory, toInventory, fromSlot, toSlot) {
        fromItem = fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData");
        inv = fromInventory.data('invTier')
        inv2 = toInventory.data('invTier')
        toinvId = toInventory.data('invId')
        toinvId2 = fromInventory.data('invId')
        toItem = toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData");
        var fromSlot = Number(fromSlot)
        var toSlot = Number(toSlot)
        if (toItem !== undefined) { // stack
            if(((fromItem.name).split("_")[0] == "WEAPON") && ((toItem.name).split("_")[0] == "WEAPON")) {
                // fromItem durability
                var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
                // toItem durability
                var durability2 = HSN.InventoryGetDurability(toItem.metadata.durability)
                toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + (fromItem.weight * fromItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
                fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + (toItem.weight * toItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
                toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
                fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability2[0],"width":durability2[2]}).find('p').html(durability2[1]);
                toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
                fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
                toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                    type : "swap",
                    toslot:  toSlot,
                    frominv : inv,
                    toinv : inv2,
                    toItem: fromItem,
                    fromslot: fromSlot,
                    fromItem: toItem,
                    invid: toinvId,
                    invid2 :toinvId2
                }));
            } else if (fromItem.name == toItem.name && toItem.stackable && count == fromItem.count) { // stack
                var fromcount = Number(fromItem.count) // set strings to number //  idk why i did this but it wasn't working
                var toCount = Number(toItem.count)
                var newcount = (fromcount + toCount)
                var newDataItem = {}
                newDataItem.name = toItem.name
                newDataItem.label = toItem.label
                newDataItem.count = newcount
                newDataItem.metadata = toItem.metadata
                newDataItem.stackable = toItem.metadata
                newDataItem.description = toItem.description
                newDataItem.weight = toItem.weight
                newDataItem.price = toItem.price
                toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + newcount + ' (' + (toItem.weight * newcount).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
                toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", newDataItem);
                fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
                toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                    type : "freeslot",
                    frominv : inv,
                    toinv : inv2,
                    emptyslot : fromSlot,
                    toslot: toSlot,
                    item : newDataItem,
                    invid: toinvId,
                    invid2 :toinvId2
                }));
                HSN.RemoveItemFromSlot(fromInventory, fromSlot)
            } else if (fromItem.name !== toItem.name && count == fromItem.count) { // swap
                if ((toItem.name).split("_")[0] == "WEAPON") {
                    var durability = HSN.InventoryGetDurability(toItem.metadata.durability)
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + (toItem.weight * toItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
                    toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + (fromItem.weight * fromItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');   
                    toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
                    toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                    $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                        type: "swap",
                        toslot:  toSlot,
                        frominv : inv,
                        toinv : inv2,
                        toItem: fromItem,
                        fromslot: fromSlot,
                        fromItem: toItem,
                        invid: toinvId,
                        invid2 :toinvId2
                    }));
                } else if ((fromItem.name).split("_")[0] == "WEAPON") {
                    var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
                    toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + (fromItem.weight * fromItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
                    toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + (toItem.weight * toItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');   
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
                    toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
                    toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                    $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                        type : "swap",
                        toslot:  toSlot,
                        frominv : inv,
                        toinv : inv2,
                        toItem: fromItem,
                        fromslot: fromSlot,
                        fromItem: toItem,
                        invid: toinvId,
                        invid2 :toinvId2
                    }));
                } else {
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + (toItem.weight * toItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');   
                    toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + (fromItem.weight * fromItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
                    toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
                    toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                    $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                        type : "swap",
                        toslot:  toSlot,
                        frominv : inv,
                        toinv : inv2,
                        toItem: fromItem,
                        fromslot: fromSlot,
                        fromItem: toItem,
                        invid: toinvId,
                        invid2 :toinvId2
                    }));
                }
            }       
        } else {
            if (fromItem.count < count) {
                HSN.InventoryMessage('You can not do this',2)
                return
            }
                if(((fromItem.name).split("_")[0] == "WEAPON")) {
                    var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
                    toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + (fromItem.weight * fromItem.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
                    toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
                    toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                    toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                    toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
                    fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
                    HSN.RemoveItemFromSlot(fromInventory,fromSlot)
                    $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                        type : "freeslot",
                        frominv : inv,
                        toinv : inv2,
                        emptyslot : fromSlot,
                        toslot: toSlot,
                        item : fromItem,
                        invid: toinvId,
                        invid2 :toinvId2
                    }));
                } else {
                    if (fromItem.count > count) {
                        var oldslotCount = fromItem.count - count
                        oldItemData = {}
                        newItemData = {}
                        oldItemData.count = oldslotCount
                        oldItemData.name = fromItem.name
                        oldItemData.label = fromItem.label
                        oldItemData.stackable = fromItem.stackable
                        oldItemData.description = fromItem.description
                        oldItemData.metadata = fromItem.metadata
                        oldItemData.weight = fromItem.weight
                        oldItemData.slot = fromSlot
                        oldItemData.price = fromItem.price

                        newItemData.count = count
                        newItemData.label = fromItem.label
                        newItemData.name = fromItem.name
                        newItemData.stackable = fromItem.stackable
                        newItemData.description = fromItem.description
                        newItemData.metadata = fromItem.metadata
                        newItemData.weight = fromItem.weight
                        newItemData.slot = toSlot
                        newItemData.price = fromItem.price
                        fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + oldItemData.name + '.png'+'" alt="' + oldItemData.name + '" /></div><div class="item-slot-count"><p>' + oldItemData.count + ' (' + (oldItemData.weight * oldItemData.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + oldItemData.label + '</p></div></p></div>');
                        fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", oldItemData);
                        toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newItemData.name + '.png'+'" alt="' + newItemData.name + '" /></div><div class="item-slot-count"><p>' + newItemData.count + ' (' + (newItemData.weight * newItemData.count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + newItemData.label + '</p></div></p></div>');
                        toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", newItemData);
                        toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                        toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
                        fromInventory.find("[inventory-slot=" + fromSlot + "]").removeClass("itemdragclose");
                        fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
                        $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                            type: "yarimswap",
                            frominv : inv,
                            toinv : inv2,
                            toSlot: toSlot,
                            fromSlot: fromSlot,
                            oldslotItem: oldItemData,
                            newslotItem: newItemData,
                            invid: toinvId,
                            invid2 :toinvId2
                        }));
                    } else if (fromItem.count == count) {
                       var fromSlot = Number(fromSlot)
                       var toSlot = Number(toSlot)
                        HSN.RemoveItemFromSlot(fromInventory,fromSlot)
                        toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + count + ' (' + (fromItem.weight * count).toFixed(1) + ')</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
                        toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
                        toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
                        toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
                        fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
                        $.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
                            type : "freeslot",
                            frominv : inv,
                            toinv : inv2,
                            emptyslot : fromSlot,
                            toslot: toSlot,
                            item : fromItem,
                            invid: toinvId,
                            invid2 :toinvId2
                            
                        }));
                    }
                }
        } 
        DragAndDrop()
    }
