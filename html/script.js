
	var disabled = false
	var drag = false
	var dropLabel = 'Drop'
	var dropName = 'drop'
	var toplamkg = 0
	var rightweight = 0
	var count = 0
	var dropSlots = 51
	var rightinvtype = null
	var inventoryidd = null
	var timer = null
	var HSN = []
	var leftinventory = 'playerinventory'
	var rightinventory = null
	var maxweight = 24000
	var playerfreeweight = 0
	var rightfreeweight = 0
	var availableweight = 0

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
		} else if (event.data.message == 'hsn-hotbar') {
			//HSN.Hotbar(event.data.items) 
		}else if (event.data.message == "notify") {
			HSN.NotifyItems(event.data.item,event.data.text)
		}
	})

	HSN.Hotbar = function(hotbar) {
		
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
		var color = "#1d1d1de8"
		var text = ''
		var width = 100
		if (quality == 100) {
			color = "#0bb80b",
			text = '',
			width = quality
		} else if (quality >= 80 && quality <= 100) {
			color = "#0bb80b",
			text = '',
			width = quality
		} else if (quality >= 50 && quality <= 80) {
			color = "#0bb80b81",
			text = '',
			width = quality
		} else if (quality >= 20 && quality <= 50) {
			color = "#ca790fcb",
			text = '',
			width = quality
		} else if (quality >= 1 && quality <= 20) {
			color = '#5c0b0bcb;',
			text = '',
			width = quality
		} else if (quality == 0) {
			color = '#1d1d1de8',
			text = '',
			width = 100
		}
		//parseInt(quality).toFixed(2)
		return [color = color,text = text,width = width];

	}

	HSN.RefreshInventory = function(data) {
		toplamkg = 0
		for(i = 1; i < (data.slots); i++) {
			$(".inventory-main-leftside").find("[inventory-slot=" + i + "]").remove();
			$(".inventory-main-leftside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
		}
		$.each(data.inventory, function (i, item) {
			if (item != null) {
				toplamkg = toplamkg +(item.weight * item.count);
				if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined || null) {
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
					var durability = HSN.InventoryGetDurability(item.metadata.durability)
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[2]}).find('p').html(durability[1]);
				} else {
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
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
		maxweight = data.maxweight
		$('.playername').html(data.name)
		for(i = 1; i < (data.slots); i++) {
			$(".inventory-main-leftside").find("[inventory-slot=" + i + "]").remove();
			$(".inventory-main-leftside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
			//$(".inventory-main-rightside").data("Owner", data.rightinventory.type);
		}
		Display(true)
		// player inventory
		$('.inventory-main-leftside').data("invTier", "Playerinv")
		toplamkg = 0
		$.each(data.inventory, function (i, item) {
			if ((item != null)) {
				toplamkg = toplamkg +(item.weight * item.count);
				if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined || null) {					
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
						var durability = HSN.InventoryGetDurability(item.metadata.durability)
						$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0], "width": durability[2]}).find('p').html(durability[1]);
				} else {
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
					$(".inventory-main-leftside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
				}
			}
		})


		$(".leftside-weight").html((toplamkg/1000).toFixed(2) + '/'+ maxweight/1000 + 'kg' )
		if (data.rightinventory !== undefined) {
			$('.inventory-main-rightside').data("invTier", data.rightinventory.type)
			$('.inventory-main-rightside').data("invId", data.rightinventory.name)
			inventoryidd = data.rightinventory.name
			rightinvtype = data.rightinventory.type
			data.rightinventory.maxweight = (data.rightinventory.slots*9).toFixed(0)
			$('.rightside-name').html(data.rightinventory.name)
				for(i = 1; i < (data.rightinventory.slots); i++) {
					$(".inventory-main-rightside").find("[inventory-slot=" + i + "]").remove();
					$(".inventory-main-rightside").append('<div class="ItemBoxes" inventory-slot=' + i +'></div> ')
				}
				if (data.rightinventory.type == 'shop') {
					inventoryidd = data.rightinventory.name
					$(".rightside-weight").html("") // hide weight 
					$.each(data.rightinventory.inventory, function (i, item) {
						if (item != null) {
							if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined || null) {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.price) + '$)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item).data("location", data.rightinventory.name);
								//$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
									var durability = HSN.InventoryGetDurability(item.metadata.durability)
									$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width":durability[2]}).find('p').html(durability[1]);
							} else {
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + (item.price) + '$)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item).data("location", data.rightinventory.name);
								//$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
							}
						}
					})

				} else {
					rightweight = 0
					$(".rightside-weight").html('')
				$.each(data.rightinventory.inventory, function (i, item) {
					if (item != null) {
						rightweight = rightweight +(item.weight * item.count);
						if ((item.name).split("_")[0] == "WEAPON" && item.metadata.durability !== undefined || null) {
							
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
								var durability = HSN.InventoryGetDurability(item.metadata.durability)
								$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").find(".item-slot-durability-bar").css({"background-color": durability[0],"width": durability[2]}).find('p').html(durability[1]);
						} else {
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src="images/' + item.name + '.png'+'" alt="' + item.name + '" /></div><div class="item-slot-count"><p>' + item.count + ' (' + ((item.weight * item.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + item.label + '</p></div></p></div>');
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").data("ItemData", item);
							$(".inventory-main-rightside").find("[inventory-slot=" + item.slot + "]").addClass("drag-item");
						}
					}
				})
				$(".rightside-weight").append('<span id="rightside-curweight">' + rightweight/1000 + '</span>')
				$(".rightside-weight").append('/<span id="rightside-maxweight">' + data.rightinventory.maxweight + '</span>kg')
			}
		} else {
			$('.rightside-name').html("Drop")
			$('.inventory-main-rightside').data("invTier", "drop")
			rightinvtype = 'drop'
			$(".rightside-weight").html('')
			$(".rightside-weight").append('<span id="rightside-curweight">' + rightweight/1000 + '</span>')
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
				} else if (count.startsWith('0')) {
					count = fromData.count
					$("#item-count").val(0)
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

	$(document).on("click", ".ItemBoxes", function(e){
		if ($(this).data("location") !== undefined || null) {
			e.preventDefault();
			var Item = $(this).data("ItemData")
			var location = $(this).data("location")
			var htmlCount = $("#item-count").val()
			if ((Item != undefined) && (location != undefined)) {
				$.post("http://hsn-inventory/BuyFromShop", JSON.stringify({
					data : Item,
					location : location,
					count : htmlCount
				}));
			}
		}
	})


	$(document).on("mouseenter", ".ItemBoxes", function(e){
		e.preventDefault();
		var Item = $(this).data("ItemData")
		if (Item != undefined) {
			$(".iteminfo").fadeIn(100);
			$(".iteminfo-label").html('<p>'+Item.label+' <span style="float:right;">(' + Item.weight + 'g)</span></p><hr class="line">')
			$(".iteminfo-description").html('')
			if (Item.description) { $(".iteminfo-description").append('<p>'+Item.description+'</p>')};
			if (Item.metadata) {
				if (Item.metadata.type) { $(".iteminfo-description").append('<p>'+Item.metadata.type+'</p>')};
				if (Item.metadata.description) { $(".iteminfo-description").append('<p>'+Item.metadata.description+'</p>')};
				if ((Item.name).split("_")[0] == "WEAPON" && Item.metadata.durability !== undefined || null) {
					if (Item.metadata.ammo !== undefined || null) { $(".iteminfo-description").append('<p>Weapon Ammo: '+Item.metadata.ammo+'</p>') }
					if (Item.metadata.durability !== undefined || null) { $(".iteminfo-description").append('<p>Durability: '+parseInt(Item.metadata.durability).toFixed(0)+''+'%</p>') }
					if (Item.metadata.weaponlicense !== undefined || null) { $(".iteminfo-description").append('<p>Serial Number: '+Item.metadata.weaponlicense+'</p>') }
					if (Item.metadata.components) { $(".iteminfo-description").append('<p>Components: '+Item.metadata.components+'</p>')};
					if (Item.metadata.weapontint) { $(".iteminfo-description").append('<p>Tint: '+Item.metadata.weapontint+'</p>')};
				}
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

	is_table_equal = function(obj1, obj2) {
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
		if (toItem !== undefined || null ) { // stack
			if (count <= fromItem.count || count <= toItem.count) {
				if(((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined || null) && ((toItem.name).split("_")[0] == "WEAPON" && toItem.metadata.durability !== undefined || null)) {
					// fromItem durability
					if (fromItem.metadata.durability) { var durability = HSN.InventoryGetDurability(fromItem.metadata.durability) }
					// toItem durability
					if (toItem.metadata.durability) { var durability2 = HSN.InventoryGetDurability(toItem.metadata.durability) }
					toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + ((fromItem.weight * fromItem.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
					fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + ((toItem.weight * toItem.count) /1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
					toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
					fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability2[0],"width":durability2[2]}).find('p').html(durability2[1]);
					toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
					fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
					fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
					toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
					$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
						type : "swap",
						toSlot:  toSlot,
						frominv : inv,
						toinv : inv2,
						toItem: fromItem,
						fromSlot: fromSlot,
						fromItem: toItem,
						invid: toinvId,
						invid2 :toinvId2
					}));
				} else if (fromItem.name == toItem.name && toItem.stackable && is_table_equal(toItem.metadata, fromItem.metadata)) { // stack
						var fromcount = Number(fromItem.count) // set strings to number //  idk why i did this but it wasn't working
						var toCount = Number(toItem.count)
						var newcount = (fromcount + toCount)
						var newDataItem = {}
						newDataItem.name = toItem.name
						newDataItem.label = toItem.label
						newDataItem.count = Number(newcount)
						newDataItem.metadata = toItem.metadata
						newDataItem.stackable = toItem.metadata
						newDataItem.description = toItem.description
						newDataItem.weight = toItem.weight
						newDataItem.price = toItem.price
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + newcount + ' (' + ((toItem.weight * newcount)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", newDataItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
							type : "freeslot",
							frominv : inv,
							toinv : inv2,
							emptyslot : fromSlot,
							toSlot: toSlot,
							item : newDataItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
						
						HSN.RemoveItemFromSlot(fromInventory, fromSlot)
				} else if (fromItem.name !== toItem.name && inv2 == inv) { // swap
					if ((toItem.name).split("_")[0] == "WEAPON" && toItem.metadata.durability !== undefined || null) {
						var durability = HSN.InventoryGetDurability(toItem.metadata.durability)
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + ((toItem.weight * toItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + ((fromItem.weight * fromItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');   
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
							type: "swap",
							toSlot:  toSlot,
							frominv : inv,
							toinv : inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
					} else if ((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined || null) {
						var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + ((fromItem.weight * fromItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						toInventory.find("[inventory-slot=" + toSlot + "]").find(".item-slot-durability-bar").css({"background-color":durability[0],"width":durability[2]}).find('p').html(durability[1]);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + ((toItem.weight * toItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');   
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
							type : "swap",
							toSlot:  toSlot,
							frominv : inv,
							toinv : inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
					} else if (inv2 == inv) {
						fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + toItem.name + '.png'+'" alt="' + toItem.name + '" /></div><div class="item-slot-count"><p>' + toItem.count + ' (' + ((toItem.weight * toItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + toItem.label + '</p></div></p></div>');   
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + ((fromItem.weight * fromItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
						fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", toItem);
						toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
						fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("drag-item");
						toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
						$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
							type : "swap",
							toSlot:  toSlot,
							frominv : inv,
							toinv : inv2,
							toItem: fromItem,
							fromSlot: fromSlot,
							fromItem: toItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
					}
				}	   
			}
		} else {
			playerfreeweight = maxweight - toplamkg
			rightfreeweight = 100000
			if (document.body.contains(document.getElementById('rightside-maxweight'))) {rightfreeweight = (document.getElementById('rightside-maxweight').innerHTML)*1000}
			availableweight = 0
			//inv = from
			//inv2 == to
			if (inv2 !== 'Playerinv') {availableweight = rightfreeweight} else {availableweight = playerfreeweight}
			
			if (availableweight !== 0 && (fromItem.weight * count) <= availableweight) {
				if (count <= fromItem.count) {
					if(((fromItem.name).split("_")[0] == "WEAPON" && fromItem.metadata.durability !== undefined || null)) {
						var durability = HSN.InventoryGetDurability(fromItem.metadata.durability)
						toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + fromItem.count + ' (' + ((fromItem.weight * fromItem.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-durability"><div class="item-slot-durability-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
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
							toSlot: toSlot,
							item : fromItem,
							invid: toinvId,
							invid2 :toinvId2
						}));
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


							fromInventory.find("[inventory-slot=" + fromSlot + "]").html('<div class="item-slot-img"><img src="images/' + oldItemData.name + '.png'+'" alt="' + oldItemData.name + '" /></div><div class="item-slot-count"><p>' + oldItemData.count + ' (' + ((oldItemData.weight * oldItemData.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + oldItemData.label + '</p></div></p></div>');
							fromInventory.find("[inventory-slot=" + fromSlot + "]").data("ItemData", oldItemData);
							toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + newItemData.name + '.png'+'" alt="' + newItemData.name + '" /></div><div class="item-slot-count"><p>' + newItemData.count + ' (' + ((newItemData.weight * newItemData.count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + newItemData.label + '</p></div></p></div>');
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
							toInventory.find("[inventory-slot=" + toSlot + "]").html('<div class="item-slot-img"><img src="images/' + fromItem.name + '.png'+'" alt="' + fromItem.name + '" /></div><div class="item-slot-count"><p>' + count + ' (' + ((fromItem.weight * count)/1000).toFixed(2) + 'kg)</p></div><div class="item-slot-label"><p><div class="item-slot-label"><p>' + fromItem.label + '</p></div></p></div>');
							toInventory.find("[inventory-slot=" + toSlot + "]").data("ItemData", fromItem);
							toInventory.find("[inventory-slot=" + toSlot + "]").addClass("drag-item");
							toInventory.find("[inventory-slot=" + toSlot + "]").removeClass("itemdragclose");
							fromInventory.find("[inventory-slot=" + fromSlot + "]").addClass("itemdragclose");
							$.post("http://hsn-inventory/saveinventorydata", JSON.stringify({
								type : "freeslot",
								frominv : inv,
								toinv : inv2,
								emptyslot : fromSlot,
								toSlot: toSlot,
								item : fromItem,
								invid: toinvId,
								invid2 :toinvId2
								
							}));
						}
					}

					if (inv2 !== 'Playerinv') {
						if (inv2 !== inv) {
							rightweight = rightweight + (fromItem.weight * count)
							$("#rightside-curweight").html(((rightweight)/1000).toFixed(2) )
							toplamkg = toplamkg - (fromItem.weight * count)
							$(".leftside-weight").html(((toplamkg)/1000).toFixed(2) + '/'+ maxweight/1000 + 'kg' )
						}
					} else {
						if (inv2 !== inv) {
							rightweight = rightweight - (fromItem.weight * count)
							$("#rightside-curweight").html(((rightweight)/1000).toFixed(2) )
							toplamkg = toplamkg + (fromItem.weight * count)
							$(".leftside-weight").html(((toplamkg)/1000).toFixed(2) + '/'+ maxweight/1000 + 'kg' )
						}
					}

				}
			} else {
				if (inv2 == 'Playerinv') { HSN.InventoryMessage('You can not carry that much', 2) }
			}
		}
		DragAndDrop()
	}
