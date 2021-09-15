---
title: Defining default metadata
---
This function is used internally when adding or buying items to define metadata. You can add additional items here to give them new default values.

!!! info
	```lua
	Items.Metadata(xPlayer, item, metadata, count)
	```

	| Argument   | Type | Explanation |
	| ---------- | ----------- |
	| xPlayer    | class | Player triggering the function |
	| item       | table | The item being manipulated |
	| metadata   | Extra metadata to be added to the item |
	| count      | Number of items to be added |