--imguiExample (CLIENT) by Dudekahedron, 2022

local M = {}

local logTag = "imguiExample" --used for identifying this plugin in console and log

local gui_module = require("ge/extensions/editor/api/gui") --editor module
local gui = {setupEditorGuiTheme = nop}

local im = ui_imgui --beamNG's imgui functions, see ...\BeamNG.drive\lua\common\extensions\ui\imgui_gen.lua

local imguiExampleWindowOpen = im.BoolPtr(true) --default state of the window
local ffi = require('ffi') --useful for some imgui lua / c++ translation

local function imguiExample() --called by onUpdate every update, put what you want to be drawn in here.
	gui.setupWindow("imguiExample")
	im.Begin("Hello World, I am a window")
	im.Indent()
	im.Text("Hello World, I am text.")
	im.SameLine()
	im.Button("The Hello World Button")
	im.Unindent()
	im.End()
end

local function onUpdate(dt) --called every update
	if worldReadyState == 2 then --checking to make sure everything has completely loaded before showing the imgui
		if imguiExampleWindowOpen[0] == true then --if the state of the window is true
			imguiExample() --we draw things in this function
		end
	end
end

local function onExtensionLoaded() --called when loaded by the game, in MP, this is durring server connection
	gui_module.initialize(gui)
	gui.registerWindow("imguiExample", im.ImVec2(358,65)) --register and define the dimensions of the window
	gui.showWindow("imguiExample")
	log('W', logTag, "imguiExample LOADED")
end

local function onExtensionUnloaded() --called when extension is unloaded
	log('W', logTag, "imguiExample UNLOADED")
end

M.dependencies = {"ui_imgui"}

M.onUpdate = onUpdate

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

M.imguiExampleWindowOpen = imguiExampleWindowOpen

return M
