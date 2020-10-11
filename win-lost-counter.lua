--lua win/lose counter for obs
obs = obslua

is_enabled = false
win_counter = 0
lost_counter = 0
win_source_name = ""
lose_source_name = ""
props = nil

win_hotkey_id = obs.OBS_INVALID_HOTKEY_ID
win_del_hotkey_id = obs.OBS_INVALID_HOTKEY_ID
lost_hotkey_id = obs.OBS_INVALID_HOTKEY_ID
lost_del_hotkey_id = obs.OBS_INVALID_HOTKEY_ID

--register hotkey events
--obs_hotkey_register_frontend()

--unregister hotkey events
--obs_hotkey_unregister()

-- Hooks von OBS

--@TODO: check if this works.... bc on refresh btn clicked not set to default...
function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "is_enabled", false)
    obs.obs_data_set_default_int(settings, "win_counter", 0)
    obs.obs_data_set_default_int(settings, "lost_counter", lost_counter)
end

function script_description()
	return "Makes it easy to add a win / lost counter to obs. Increasing wins and loses is possible by declaring a hotkey under hotkey tabs for: Add Win and Add Los.\n\nMade by Christopher-Robin Fey"
end


function script_properties()
    props = obs.obs_properties_create()

    --define general props
    --obs.obs_properties_add_bool(props, "is_enabled", "Enabled")
    obs.obs_properties_add_int(props, "win_counter", "Win Counter", 0, 999, 1)
    obs.obs_properties_add_int(props, "lost_counter", "Lost Counter", 0, 999 ,1)

    --add text source /
    local winText = obs.obs_properties_add_list(props, "winLabel", "Win Text", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local lostText = obs.obs_properties_add_list(props, "lostLabel", "Lost Text", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)

	local sources = obs.obs_enum_sources()
	if sources ~= nil then
        for _, source in ipairs(sources) do
			source_id = obs.obs_source_get_id(source)
			if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
                local name = obs.obs_source_get_name(source)
                obs.obs_property_list_add_string(winText, name, name)
                obs.obs_property_list_add_string(lostText, name, name)
			end
		end
    end

    obs.source_list_release(sources);

    return props
end

function script_update(settings)
    win_source_name = obs.obs_data_get_string(settings, "winLabel")
    lose_source_name = obs.obs_data_get_string(settings, "lostLabel")
end

function script_load(settings)
    --Regsiter hotkeys
    win_hotkey_id = obs.obs_hotkey_register_frontend("win_counter.trigger", "Increment win", winCountAdd)
    win_del_hotkey_id = obs.obs_hotkey_register_frontend("win_counter_del.trigger", "Decrease win", winCountDel)
    lost_hotkey_id = obs.obs_hotkey_register_frontend("lost_counter.trigger", "Increment loss", lostCountAdd)
    lost_del_hotkey_id = obs.obs_hotkey_register_frontend("lost_counter_del.trigger", "Decrease loss", lostCountDel)

    local win_hotkey_save_array = obs.obs_data_get_array(settings, "win_counter.trigger")
    obs.obs_hotkey_load(win_hotkey_id, win_hotkey_save_array)
    obs.obs_data_array_release(win_hotkey_save_array)

    local win_del_hotkey_save_array = obs.obs_data_get_array(settings, "win_counter_del.trigger")
    obs.obs_hotkey_load(win_del_hotkey_id, win_del_hotkey_save_array)
    obs.obs_data_array_release(win_del_hotkey_save_array)

    local lost_hotkey_save_array = obs.obs_data_get_array(settings, "lost_counter.trigger")
    obs.obs_hotkey_load(lost_hotkey_id, lost_hotkey_save_array)
    obs.obs_data_array_release(lost_hotkey_save_array)

    local lost_del_hotkey_save_array = obs.obs_data_get_array(settings, "lost_counter_del.trigger")
    obs.obs_hotkey_load(lost_del_hotkey_id, lost_del_hotkey_save_array)
    obs.obs_data_array_release(lost_del_hotkey_save_array)
end


--TODO finish this
function script_save(settings)

    local win_hotkey_save_array = obs.obs_hotkey_save(win_hotkey_id)
	obs.obs_data_set_array(settings, "win_counter.trigger", win_hotkey_save_array)
	obs.obs_data_array_release(win_hotkey_save_array)

    local win_del_hotkey_save_array = obs.obs_hotkey_save(win_del_hotkey_id)
	obs.obs_data_set_array(settings, "win_counter_del.trigger", win_del_hotkey_save_array)
	obs.obs_data_array_release(win_del_hotkey_save_array)

    local lost_hotkey_save_array = obs.obs_hotkey_save(lost_hotkey_id)
	obs.obs_data_set_array(settings, "lost_counter.trigger", lost_hotkey_save_array)
    obs.obs_data_array_release(lost_hotkey_save_array)
    
    local lost_del_hotkey_save_array = obs.obs_hotkey_save(lost_del_hotkey_id)
	obs.obs_data_set_array(settings, "lost_counter_del.trigger", lost_del_hotkey_save_array)
	obs.obs_data_array_release(lost_del_hotkey_save_array)

end


function updateWinCounterLabel() 
    local text = string.format("%02d", win_counter)
	local source = obs.obs_get_source_by_name(win_source_name)
	if source ~= nil then
		local settings = obs.obs_data_create()
		obs.obs_data_set_string(settings, "text", text)
		obs.obs_source_update(source, settings)
		obs.obs_data_release(settings)
		obs.obs_source_release(source)
    end
end

function updateLostCounterLabel()
    local text = string.format("%02d", lost_counter)
	local source = obs.obs_get_source_by_name(lose_source_name)
	if source ~= nil then
		local settings = obs.obs_data_create()
		obs.obs_data_set_string(settings, "text", text)
		obs.obs_source_update(source, settings)
		obs.obs_data_release(settings)
		obs.obs_source_release(source)
    end
end


function winCountAdd(pressed)
    if not pressed then
        return
    end

    win_counter = win_counter + 1
    updateWinCounterLabel()

	return
end


function winCountDel(pressed)
    if not pressed then
        return
    end
    
    if win_counter > 0 then
        win_counter = win_counter - 1
        updateWinCounterLabel()
    end

	return
end


function lostCountAdd(pressed)
    if not pressed then
        return
    end

    lost_counter = lost_counter + 1
    updateLostCounterLabel()

    return
end


function lostCountDel(pressed)
    if not pressed then
        return
    end

    if lost_counter > 0 then
        lost_counter = lost_counter - 1
        updateLostCounterLabel()
    end

    return
end
