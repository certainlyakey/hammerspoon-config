local allowedBundleIDs = {
    "com.apple.Safari",
    "com.microsoft.VSCode",
    "com.microsoft.teams2",
    "com.mitchellh.ghostty",
    "com.figma.Desktop",
    "com.google.Chrome",
    "com.DanPristupov.Fork",
}

local function saveApps()
    local bundleIDs = {}
    for _, app in ipairs(hs.application.runningApplications()) do
        for _, bundleID in ipairs(allowedBundleIDs) do
            if app:bundleID() == bundleID then
                table.insert(bundleIDs, bundleID)
                break
            end
        end
    end
    hs.settings.set("appSnapshot", bundleIDs)
    hs.alert("Apps saved!")
    print("Saved apps: " .. table.concat(bundleIDs, ", "))
end

local function restoreApps()
    local bundleIDs = hs.settings.get("appSnapshot")
    if not bundleIDs then hs.alert("No snapshot found!"); return end
    for _, bundleID in ipairs(bundleIDs) do
        hs.application.launchOrFocusByBundleID(bundleID)
    end
    hs.alert("Apps restored!")
    print("Restored apps: " .. table.concat(bundleIDs, ", "))
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "s", saveApps)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", restoreApps)
