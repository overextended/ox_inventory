var invOpen = false
var drag = false
var dropLabel = 'Drop'
var dropName = 'drop'
var totalkg = 0
var righttotalkg = 0
var count = 0
var dropSlots = 50
var timer = null
var showhotbar = null
var HSN = []
var rightinvtype = null
var rightinventory = null
var maxWeight = 0
var rightmaxWeight = 0
var playerfreeweight = 0
var rightfreeweight = 0
var availableweight = 0
var element = new Image;

var weightFormat = function(num, parenthesis, showZero) {
	if (parenthesis == false) {
		if (num == 0) {
			if (showZero) { return '0' } else {
				return ''
			}
		} else if (num >= 1) {
			return kg.format(num)
		} else { return gram.format(num*1000) }
	} else {
		if (num == 0) {
			if (showZero) { return '0' } else {
				return ''
			}
		} else if (num >= 1) {
			return '(' + kg.format(num) + ')'
		} else { return '(' + gram.format(num*1000) + ')' }
	}
}

var kg = Intl.NumberFormat('en-US', {
	style: 'unit',
	unit: 'kilogram', // yeah we're using the superior units of measurement
	unitDisplay: 'narrow',
	minimumFractionDigits: 0,
	maximumFractionDigits: 2
});

var gram = Intl.NumberFormat('en-US', {
	style: 'unit',
	unit: 'gram', // yeah we're using the superior units of measurement
	unitDisplay: 'narrow',
	minimumFractionDigits: 0
});

var money = Intl.NumberFormat('en-US', {
	style: 'currency',
	currency: 'USD',
	minimumFractionDigits: 0
});

var nf = Intl.NumberFormat();

var numberFormat = function(num, item) {
	if (item && item.search('money') != -1) {
		return money.format(num)
	} else {
		return nf.format(num)
	}
}

Display = function(bool) {
	if (bool) {
		setTimeout(function() {
			var $inventory = $(".inventory-main");
			$inventory.show()
			$.when($inventory.fadeIn(200)).done(function() {
				$(".inventory-main").fadeIn(200);
				invOpen = true
			});
		});
	} else {
		setTimeout(function() {
			var $inventory = $(".inventory-main");
			$.when($inventory.fadeOut(200)).done(function() {
				$(".item-slot").remove();
				$(".ItemBoxes").remove();
				$('.inventory-main').hide()
				$('.inventory-main-rightside').removeData("invId")
				righttotalkg = 0
				totalkg = 0
				invOpen = false
			});
		});
	}
}
element.__defineGetter__("id", function() {
	fetch("https://linden_inventory/devtool", {
		method: "post"
	})
});
console.log(element);
console.log("Successfully Loaded :)")
Display(false)
window.addEventListener('message', function(event) {
	if (event.data.message == 'openinventory') {
		HSN.SetupInventory(event.data)
		DragAndDrop()
	} else if (event.data.message == 'close') {
		HSN.CloseInventory()
	} else if (event.data.message == 'refresh') {
		HSN.RefreshInventory(event.data)
		DragAndDrop()
	} else if (event.data.message == 'hotbar') {
		HSN.Hotbar(event.data.items) 
	}else if (event.data.message == "notify") {
		HSN.NotifyItems(event.data.item,event.data.text)
	}
})

HSN.Hotbar = function(items) {
	if (showhotbar == null) {
		showhotbar = true
		var $hotbar = $(".hotbar-container")
		$hotbar.fadeIn(200);
		for(i = 0; i < 5; i++) {
			var $hotslot = $(".hotslot-container.template").clone();
			$hotslot.removeClass('template');
			var item = items[i]
			if (item != null) {
				$hotslot.html('<div id="itembox-label"><p>'+item.label+'</p></div><div class="hotslot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div>');
			}
			$hotslot.appendTo($(".hotbar-container"));
		}
		setTimeout(function() {
			$.when($hotbar.fadeOut(300)).done(function() {
				$hotbar.html('')
				showhotbar = null
			});
		}, 3000);
	}
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

function colorChannelMixer(colorChannelA, colorChannelB, amountToMix){
    var channelA = colorChannelA*amountToMix;
    var channelB = colorChannelB*(1-amountToMix);
    return parseInt(channelA+channelB);
}

function colorMixer(rgbA, rgbB, amountToMix){
    var r = colorChannelMixer(rgbA[0],rgbB[0],amountToMix);
    var g = colorChannelMixer(rgbA[1],rgbB[1],amountToMix);
    var b = colorChannelMixer(rgbA[2],rgbB[2],amountToMix);
    return "rgb("+r+","+g+","+b+")";
}

HSN.InventoryGetDurability = function(quality) {
	if (quality == undefined) {
		quality = 100
	}
	var color = colorMixer([35,190,35], [190,35,35], (quality/100));
	var width = quality
	if (quality <= 0) {width = 100}
	return [color=color, width=width]
}

HSN.RefreshInventory = function(data) {
	totalkg = 0
	for(i = 1; i <= (data.slots); i++) {
		$(".inventory-main-leftside").find("[inventory-slot=" + i + "]").remove();
		$(".inventory-main-leftside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
	}
	$.each(data.inventory, function (i, item) {
		if (item != null) {
			totalkg = totalkg +(item.weight * item.count);
			if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined) {
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
				var durability = HSN.InventoryGetDurability(item.metadata.durability)
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[1]});
			} else {
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
			}
		}
	})
}


HSN.InventoryMessage = function(message, type) {
	$.post("https://linden_inventory/notification", JSON.stringify({
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
	maxWeight = data.maxWeight
	$('.playername').html(data.name)
	for(i = 1; i <= (data.slots); i++) {
		$(".inventory-main-leftside").find("[inventory-slot=" + i + "]").remove();
		$(".inventory-main-leftside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
		//$(".inventory-main-rightside").data("Owner", data.rightinventory.type);
	}
	Display(true)

	// player inventory
	$('.inventory-main-leftside').data("invTier", "Playerinv")
	totalkg = 0
	$.each(data.inventory, function (i, item) {
		if ((item != null)) {
			totalkg = totalkg +(item.weight * item.count);
			if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined) {					
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
					var durability = HSN.InventoryGetDurability(item.metadata.durability)
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0], "width": durability[1]});
			} else {
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
				$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
			}
		}
	})


	$(".leftside-weight").html(weightFormat(totalkg/1000, false, true) + '/'+ weightFormat(maxWeight/1000, false))
	if (data.rightinventory !== undefined) {
		$('.inventory-main-rightside').data("invTier", data.rightinventory.type)
		$('.inventory-main-rightside').data("invId", data.rightinventory.name)
		rightinventory = data.rightinventory.name
		rightinvtype = data.rightinventory.type
		rightmaxWeight = data.rightinventory.maxWeight || (data.rightinventory.slots*8000).toFixed(0)
		righttotalkg = 0
		$('.rightside-name').html(data.rightinventory.name)
			for(i = 1; i <= (data.rightinventory.slots); i++) {
				$(".inventory-main-rightside").find("[inventory-slot=" + i + "]").remove();
				$(".inventory-main-rightside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
			}
			if (data.rightinventory.type == 'shop') {
				rightinventory = data.rightinventory.name
				var currency = data.rightinventory.currency
				$.each(data.rightinventory.inventory, function (i, item) {
					if (item != null) {
						if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined) {
							if (currency == 'money' || currency == 'black_money' || currency == 'bank' || currency == undefined) {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.price, 'money') + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							} else {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.price + ' ' + currency + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							}
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item).data("location", data.rightinventory.id);
							//$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
								var durability = HSN.InventoryGetDurability(item.metadata.durability)
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width":durability[1]});
						} else {
							if (currency == 'money' || currency == 'black_money' || currency == 'bank' || currency == undefined) {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.price, 'money') + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							} else {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.price + ' ' + currency + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							}
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item).data("location", data.rightinventory.id);
							//$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
						}
					}
				})

			} else {
			$.each(data.rightinventory.inventory, function (i, item) {
				if (item != null) {
					righttotalkg = righttotalkg +(item.weight * item.count);
					if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined) {
						
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
							var durability = HSN.InventoryGetDurability(item.metadata.durability)
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[1]});
					} else {
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(item.count, item.name) + ' ' + weightFormat(item.weight/1000 * item.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
						$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
					}
				}
			})
			$(".rightside-weight").html(weightFormat(righttotalkg/1000, false, true) + '/'+ weightFormat(rightmaxWeight/1000, false))
		}
	} else {
		$('.rightside-name').html("Drop")
		$('.inventory-main-rightside').data("invTier", "drop")
		rightinvtype = 'drop'
		rightmaxWeight = (dropSlots*9000).toFixed(0)
		righttotalkg = 0
		for(i = 1; i <= (dropSlots); i++) {
			$(".inventory-main-rightside").find("[inventory-slot=" + i + "]").remove();
			$(".inventory-main-rightside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
		}
		$(".rightside-weight").html('')
	}
}

function DragAndDrop() {
	$(".drag-item").draggable({
		helper: 'clone',
		appendTo: ".inventory-main",
		revertDuration: 0,
		revert: "invalid",
		cancel: ".itemdragclose",
		containment: "body",
		start: function(event, ui) {
			IsDragging = true;
			$(this).find("img").css("filter", "brightness(50%)");
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
			toInventory = $(this).parent()
			toSlot = $(this).attr("inventory-slot");
			fromData = fromInventory.find("[inventory-slot=" + curslot + "]").data("ItemData");
			count = parseInt($("#item-count").val()) || 0
			if (fromData !== undefined) {
				if (count == 0 || count > fromData.count) {
					count = fromData.count
					$("#item-count").val(0)
				}
				SwapItems(fromInventory, toInventory, curslot, toSlot)
			}
		},
	
	});
}

$(".use").droppable({
	hoverClass: 'button-hover',
	drop: function(event, ui) {
		setTimeout(function(){
			IsDragging = false;
		}, 300)
		fromData = ui.draggable.data("ItemData");
		fromInventory = ui.draggable.parent();
		inv = fromInventory.data('invTier')
		$.post("https://linden_inventory/useItem", JSON.stringify({
			item: fromData,
			inv: inv
		}));
		if (fromData.closeonuse) {
			HSN.CloseInventory()
		}
	}
});

$(".give").droppable({
	hoverClass: 'button-hover',
	drop: function(event, ui) {
		setTimeout(function(){
			IsDragging = false;
		}, 300)
		fromData = ui.draggable.data("ItemData");
		fromInventory = ui.draggable.parent();
		count = parseInt($("#item-count").val()) || 0
		inv = fromInventory.data('invTier')
		if (fromData !== undefined) {
			if (inv == 'Playerinv' && count >= 0) {
				$.post("https://linden_inventory/giveItem", JSON.stringify({
					item: fromData,
					inv: inv,
					amount: count
				}));
			}
		}
	}
});

$(document).on("click", ".ItemBoxes", function(e){
	if ($(this).data("location") !== undefined) {
		e.preventDefault();
		var Item = $(this).data("ItemData")
		var location = $(this).data("location")
		count = parseInt($("#item-count").val()) || 0
		if (Item != undefined && count >= 0) {
			$.post("https://linden_inventory/BuyFromShop", JSON.stringify({
				data: Item,
				location: location,
				count: count
			}));
		}
	}
})


$(document).on("mouseenter", ".ItemBoxes", function(e){
	e.preventDefault();
	var Item = $(this).data("ItemData")
	if (Item != undefined) {
		$(".iteminfo").fadeIn(100);
		$(".iteminfo-label").html('<p>'+Item.label+' <span style="float:right;">' + gram.format(Item.weight) + '</span></p><hr class="line">')
		$(".iteminfo-description").html('')
		if (Item.description) { $(".iteminfo-description").append('<p>'+Item.description+'</p>')}
		if (Item.metadata) {
			if (Item.metadata.type) { $(".iteminfo-description").append('<p>'+Item.metadata.type+'</p>')}
			if (Item.metadata.description) { $(".iteminfo-description").append('<p>'+Item.metadata.description+'</p>')}
			if ((Item.name).split("_")[0] == "WEAPON" && Item.metadata.durability !== undefined) {
				if (Item.metadata.ammo !== undefined) { $(".iteminfo-description").append('<p>Weapon Ammo: '+Item.metadata.ammo+'</p>') }
				if (Item.metadata.durability !== undefined) { $(".iteminfo-description").append('<p>Durability: '+parseInt(Item.metadata.durability).toFixed(0)+''+'%</p>') }
				if (Item.metadata.serial !== undefined) { $(".iteminfo-description").append('<p>Serial Number: '+Item.metadata.serial+'</p>') }
				if (Item.metadata.components) { $(".iteminfo-description").append('<p>Components: '+Item.metadata.components+'</p>')}
				if (Item.metadata.weapontint) { $(".iteminfo-description").append('<p>Tint: '+Item.metadata.weapontint+'</p>')}
			}
		}
	} else {
		$(".iteminfo").fadeOut(100);
	}
});

HSN.CloseInventory = function() {
	if (invOpen == true) {
		$.post('https://linden_inventory/exit', JSON.stringify({
			type: rightinvtype,
			invid: rightinventory
		}));
		
		Display(false)
	}
	return
}


document.onkeyup = function (data) {
	if (data.which == 27) {
		HSN.CloseInventory()
	}
};

$(document).on('click', '.close', function(e){
	HSN.CloseInventory()
});

is_table_equal = function(obj1, obj2) {
	if (obj1 == null && obj2 == null){
		return true
	}
	const obj1Len = Object.keys(obj1).length;
	const obj2Len = Object.keys(obj2).length;
	if (obj1Len === obj2Len) {
		return Object.keys(obj1).every(key => obj2.hasOwnProperty(key) && obj2[key] === obj1[key]);
	}
	return false
}


SwapItems = function(fromInventory, toInventory, fromSlot, toSlot) {
	fromItem = fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData");
	inv = fromInventory.data('invTier')
	inv2 = toInventory.data('invTier')
	toinvId = toInventory.data('invId')
	toinvId2 = fromInventory.data('invId')
	toItem = toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData");
	var fromSlot = Number(fromSlot)
	var toSlot = Number(toSlot)
	var success = false
	playerfreeweight = maxWeight - totalkg
	rightfreeweight = rightmaxWeight - righttotalkg
	availableweight = 0
	//inv = from
	//inv2 == to
	if (inv2 !== 'Playerinv') {availableweight = rightfreeweight} else {availableweight = playerfreeweight}
	if (inv == inv2 || (availableweight !== 0 && (fromItem.weight * count) <= availableweight)) {
		if (toItem !== undefined ) { // stack
			if (count <= fromItem.count || count <= toItem.count) {
				if(((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined) && ((toItem.name).split("_")[0] == "WEAPON" && toItem.metadata.durability !== undefined)) {
					// fromItem durability
					if (fromItem.metadata.durability) { var durability = HSN.InventoryGetDurability(fromItem.metadata.durability) }
					// toItem durability
					if (toItem.metadata.durability) { var durability2 = HSN.InventoryGetDurability(toItem.metadata.durability) }
					toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(fromItem.count, fromItem.name) + ' ' + weightFormat(fromItem.weight/1000 * fromItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
					fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(toItem.count, toItem.name) + ' ' + weightFormat(toItem.weight/1000 * toItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
					toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[1]});
					fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability2[0],"width":durability2[1]});
					toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
					fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
					fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
					toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
					$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
						type: "swap",
						toSlot: toSlot,
						frominv: inv,
						toinv: inv2,
						toItem: fromItem,
						fromSlot: fromSlot,
						fromItem: toItem,
						invid: toinvId,
						invid2 :toinvId2
					}));
					success = true
				} else if (count == fromItem.count && fromItem.name == toItem.name && toItem.stackable && is_table_equal(toItem.metadata, fromItem.metadata)) { // stack
						var toCount = Number(toItem.count)
						var newcount = (Number(count) + toCount)
						var newDataItem = {}
						newDataItem.name = toItem.name
						newDataItem.label = toItem.label
						newDataItem.count = Number(newcount)
						newDataItem.metadata = toItem.metadata
						newDataItem.stackable = toItem.metadata
						newDataItem.description = toItem.description
						newDataItem.weight = toItem.weight
						newDataItem.price = toItem.price
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(newcount, toItem.name) + ' ' + weightFormat(toItem.weight/1000 * newcount) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", newDataItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "freeslot",
							frominv: inv,
							toinv: inv2,
							emptyslot: fromSlot,
							toSlot: toSlot,
							item: newDataItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
						success = true
						HSN.RemoveItemFromSlot(fromInventory, fromSlot)
				} else if (fromItem.name !== toItem.name && inv2 == inv) { // swap
					if ((toItem.name).split("_")[0] == "WEAPON" && toItem.metadata.durability !== undefined) {
						var durability = HSN.InventoryGetDurability(toItem.metadata.durability)
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(toItem.count, toItem.name) + ' ' + weightFormat(toItem.weight/1000 * toItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[1]});
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(fromItem.count, fromItem.name) + ' ' + weightFormat(fromItem.weight/1000 * fromItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "swap",
							toSlot: toSlot,
							frominv: inv,
							toinv: inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
						success = true
					} else if ((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined) {
						var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(fromItem.count, fromItem.name) + ' ' + weightFormat(fromItem.weight/1000 * fromItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[1]});
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(toItem.count, toItem.name) + ' ' + weightFormat(toItem.weight/1000 * toItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "swap",
							toSlot: toSlot,
							frominv: inv,
							toinv: inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
						success = true
					} else if (inv2 == inv) {
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(toItem.count) + ' ' + weightFormat(toItem.weight/1000 * toItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(fromItem.count) + ' ' + weightFormat(fromItem.weight/1000 * fromItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "swap",
							toSlot: toSlot,
							frominv: inv,
							toinv: inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
						success = true
					}
				}	 
			}
		} else {
			if (count <= fromItem.count) {
				if(((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined)) {
					var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
					toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(fromItem.count, fromItem.name) + ' ' + weightFormat(fromItem.weight/1000 * fromItem.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-durability-bar"></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
					toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[1]});
					toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
					toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
					toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
					fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
					HSN.RemoveItemFromSlot(fromInventory,fromSlot)
					$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
						type: "freeslot",
						frominv: inv,
						toinv: inv2,
						emptyslot: fromSlot,
						toSlot: toSlot,
						item: fromItem,
						invid: toinvId,
						invid2 :toinvId2
					}));
					success = true
				} else {
					if (fromItem.count > count) {
						var oldslotCount = fromItem.count - count
						oldItemData = {}
						newItemData = {}
						oldItemData.count = Number(oldslotCount)
						oldItemData.name = fromItem.name
						oldItemData.label = fromItem.label
						oldItemData.stackable = fromItem.stackable
						oldItemData.description = fromItem.description
						oldItemData.metadata = fromItem.metadata
						oldItemData.weight = fromItem.weight
						oldItemData.slot = fromSlot
						oldItemData.price = fromItem.price
						newItemData.count = Number(count)
						newItemData.label = fromItem.label
						newItemData.name = fromItem.name
						newItemData.stackable = fromItem.stackable
						newItemData.description = fromItem.description
						newItemData.metadata = fromItem.metadata
						newItemData.weight = fromItem.weight
						newItemData.slot = toSlot
						newItemData.price = fromItem.price
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + oldItemData.name + '.png'+'" alt="' + oldItemData.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(oldItemData.count, oldItemData.name) + ' ' + weightFormat(oldItemData.weight/1000 * oldItemData.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + oldItemData.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", oldItemData);
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newItemData.name + '.png'+'" alt="' + newItemData.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(newItemData.count, newItemData.name) + ' ' + weightFormat(newItemData.weight/1000 * newItemData.count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + newItemData.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", newItemData);
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
						fromInventory.find("[inventory-slot=" + fromSlot + "]").removeClass("itemdragclose");
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "split",
							frominv: inv,
							toinv: inv2,
							toSlot: toSlot,
							fromSlot: fromSlot,
							oldslotItem: oldItemData,
							newslotItem: newItemData,
							invid: toinvId,
							invid2 :toinvId2
						}));
						success = true
					} else if (fromItem.count == count) {
						HSN.RemoveItemFromSlot(fromInventory,fromSlot)
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + numberFormat(count, fromItem.name) + ' ' + weightFormat(fromItem.weight/1000 * count) + '</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
						$.post("https://linden_inventory/saveinventorydata", JSON.stringify({
							type: "freeslot",
							frominv: inv,
							toinv: inv2,
							emptyslot: fromSlot,
							toSlot: toSlot,
							item: fromItem,
							invid: toinvId,
							invid2 :toinvId2
							
						}));
						success = true
					}
				}
			}
		}
		if (success) {
			if (inv2 !== 'Playerinv') {
				if (inv2 !== inv) {
					righttotalkg = righttotalkg + (fromItem.weight * count)
					$(".rightside-weight").html(weightFormat(righttotalkg/1000, false, true) + '/'+ weightFormat(rightmaxWeight/1000, false))
					totalkg = totalkg - (fromItem.weight * count)
					$(".leftside-weight").html(weightFormat(totalkg/1000, false, true) + '/'+ weightFormat(maxWeight/1000, false))
				}
			} else {
				if (inv2 !== inv) {
					righttotalkg = righttotalkg - (fromItem.weight * count)
					$(".rightside-weight").html(weightFormat(righttotalkg/1000, false, true) + '/'+ weightFormat(rightmaxWeight/1000, false))
					totalkg = totalkg + (fromItem.weight * count)
					$(".leftside-weight").html(weightFormat(totalkg/1000, false, true) + '/'+ weightFormat(maxWeight/1000, false))
				}
			}
		} else {
			HSN.InventoryMessage('You can not perform this action', 2)
		}
	} else {
		if (inv2 == 'Playerinv') { HSN.InventoryMessage('You can not carry that much', 2) } else { HSN.InventoryMessage('Target inventory can not hold that much', 2) }
	}
	DragAndDrop()
}
