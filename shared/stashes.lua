Config.PoliceEvidence = vector3(474.2242, -990.7516, 26.2638) -- /evidence # while near this point

-- Do not define job for anyone to have access to the stash
-- Property stashes need to be handled with your property resource using the export (look at Snippets)
Config.Stashes = {
	--{ coords = vector3(474.2242, -990.7516, 26.2638), slots = 70, name = 'Police Evidence', job = 'police' }, using command instead
	{ coords = vector3(301.4374, -599.2748, 43.2821), slots = 70, name = 'Hospital Cloakroom', job = 'ambulance' },
}
