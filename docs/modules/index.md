---
title: Overview
---
Ox Inventory is organised into separate files which are loaded and stored in a single environment as modules.  
Most functions are included as part of a module and can only be accessed by storing a local reference to the module.

This section will provide details on several functions that are utilised in several modules or available to use in other resources as exports.

!!! note
	Modules are not typically usable outside of the resource; if you want to use them you need to look at the `exports` listed.

!!! attention
	If the documentation for a function does not include an export then it is only intended for internal use.