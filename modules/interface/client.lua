-- Module is deprecated and provided for compatibility
-- All functions are now part of with ox_lib

exports('Keyboard', lib.inputDialog)

exports('Progress', function(options, completed)
	local success = lib.progressBar(options)

	if completed then
		completed(not success)
	end
end)

exports('CancelProgress', lib.cancelProgress)
exports('ProgressActive', lib.progressActive)
