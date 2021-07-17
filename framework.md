---
title: ESX Legacy Installation
---


<h4 align='center'>You should only be manually updating your ESX if you have a modified version already, in which case it's assumed you have a brain.<br><br>
This guide will only link to the lines you will need to modify, assuming you are using ESX Legacy from the official repository.<br><br>
Furthermore, I am only linking the <b>bare minimum</b> for inventory support.<br><br></h4>


	
- client/functions.lua
	- [L294-L302](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-fb88ff8ef626f8b3556af9308eba9d1acc16eff1e4643b62e04197e07afed7e0L294-L302)
	- [L746-L993](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-fb88ff8ef626f8b3556af9308eba9d1acc16eff1e4643b62e04197e07afed7e0L746-L993)
- client/main.lua
	- [L83-L85](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL83-L85)
	- [L98-L129](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL98-L129)
	- [L149-L220](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL149-L220)
	- [L253-L291](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL253-L291)
	- [L302-L309](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL302-L309)
	- [L371-L401](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL371-L401)
	- [L443-L488](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-6f0b2f6b34829d0f65728f2508a4f5e2ef0d39d59b554b3ec8613c8feaacf74dL443-L488)
- imports.lua
	- [Replace](https://github.com/thelindat/es_extended/blob/linden/imports.lua)
- server/classes/player.lua
	- [Replace](https://github.com/thelindat/es_extended/blob/linden/server/classes/player.lua)
- server/commands.lua
	- [L35-L126](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-a5b0e1d03fa7124c18dc99fc93d4c0748e84a8bacfd97c9efdea45f0bba2d34dL35-L126) (ignore 101-108)
- server/common.lua
	- [L168-R229](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-7de0b3abd8e0d4812e3c98126b9f6902f2ead62bc09a9c9d3601bb3cfc849b75L168-R229)
	- [L310-L329](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-7de0b3abd8e0d4812e3c98126b9f6902f2ead62bc09a9c9d3601bb3cfc849b75L310-L329)
- server/main.lua
	- [Replace](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L6-R6)
	- [Replace](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L181-L212)
	- [L224-L245](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L224-L245)
	- [Replace](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L276-R224)
	- [Replace](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L295-R247)
	- [L351-L548](https://github.com/thelindat/es_extended/compare/cc5d425ba119748b4c283e2909006a24939dfb9b...814c7596bc29a1fff4f686450f2545f3a16f8975?diff=unified#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088L351-L548)

### Add to server/common.lua
```lua
AddEventHandler('linden_inventory:loaded', function(data)
	ESX.Items = data
end)
```

<h4 align='center'>If this confused you, just <b><a href='https://github.com/thelindat/es_extended'>download the fork</a></b>.</h4>
