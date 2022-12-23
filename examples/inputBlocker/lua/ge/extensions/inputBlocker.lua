--inputBlocker

local M = {}

local blockedInputActions = {"editorToggle","toggleConsoleNG"} --world editor and console
local inputsBlocked = false

local function onUpdate(dt)
	if worldReadyState == 2 then
		if not inputsBlocked then
			extensions.core_input_actionFilter.setGroup('inputBlocker', blockedInputActions)
			extensions.core_input_actionFilter.addAction(0, 'inputBlocker', true)
			inputsBlocked = true
		end
	end
end

local function onWorldReadyState(state)
	worldReadyState = state
end

local function onExtensionUnloaded()
	extensions.core_input_actionFilter.setGroup('blockEditor', blockedInputActions)
	extensions.core_input_actionFilter.addAction(0, 'blockEditor', false)
end

M.onUpdate = onUpdate
M.onWorldReadyState = onWorldReadyState
M.onExtensionUnloaded = onExtensionUnloaded

return M
