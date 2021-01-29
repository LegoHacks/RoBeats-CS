--[[
    RoBeats CS Auto Player

    By Spencer#0003

    I actually documentated this script :flushed:
]]

-- Init

local replicatedStorage = game:GetService("ReplicatedStorage");
local runService = game:GetService("RunService");

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Utilities/main/UI.lua"))();

-- Main

local getNoteType;
local _game, trackSystem;

do --> Do blocks are sexy.
    local trackSystemModule = require(replicatedStorage.Local.TrackSystem);
    local _gameModule = require(replicatedStorage.Local.GameLocal);

    local trackSystemNew = trackSystemModule.new;
    local gameLocalNew = _gameModule.new;

    _gameModule.new = newcclosure(function(...)
        _game = gameLocalNew(...); --> Grab the game table.
        return _game;
    end);

    trackSystemModule.new = newcclosure(function(...)
        trackSystem = trackSystemNew(...); --> Grab the tracksystem.
        return trackSystem;
    end);

    ------

    local marvelousResult, perfectResult, greatResult, goodResult, badResult, missResult = 6, 5, 4, 3, 2, 1;

    function getNoteType()
        local marvelous = Random.new():NextNumber(0, 100) <= library.flags.marvelousPercentage;
        local perfect = Random.new():NextNumber(0, 100) <= library.flags.perfectPercentage;
        local great = Random.new():NextNumber(0, 100) <= library.flags.greatPercentage;
        local good = Random.new():NextNumber(0, 100) <= library.flags.goodPercentage;
        local bad = Random.new():NextNumber(0, 100) <= library.flags.badPercentage;
    
        if (marvelous) then --> Calculate note type.
            return marvelousResult;
        elseif (perfect) then
            return perfectResult;
        elseif (great) then
            return greatResult;
        elseif (good) then
            return okayResult;
        end;
    
        return 0;
    end;
end;

local robeatsCS = library:CreateWindow("RoBeats CS");

robeatsCS:AddSlider({
    text = "Marvelous";
    flag = "marvelousPercentage";
    min = 0;
    max = 100;
    default = 100;
});

robeatsCS:AddSlider({
    text = "Perfect";
    flag = "perfectPercentage";
    min = 0;
    max = 100;
    default = 0;
});

robeatsCS:AddSlider({
    text = "Great";
    flag = "greatPercentage";
    min = 0;
    max = 100;
    default = 0;
});

robeatsCS:AddSlider({
    text = "Good";
    flag = "goodPercentage";
    min = 0;
    max = 100;
    default = 0;
});

robeatsCS:AddSlider({
    text = "Bad";
    flag = "badPercentage";
    min = 0;
    max = 100;
    default = 0;
});

robeatsCS:AddSlider({
    text = "Miss";
    flag = "missPercentage";
    min = 0;
    max = 100;
    default = 0;
});

robeatsCS:AddToggle({
    text = "Enabled";
    flag = "enabled";
});

runService:BindToRenderStep("RoBeat CS Hackles", 5, function()
    if (library.flags.enabled and _game and trackSystem) then
        local notes = trackSystem._notes;
        for i = 1, notes:count() do --> Loop through each note
            if (syn_context_set) then
                syn_context_set(2); --> Synapse fucking errors without this :kms:
            end;
            
            local noteType = getNoteType();
            local note = notes:get(i); --> Get the note.
            local noteTrack = note:get_track_index(); --> Get the track index.
            local testResult, testScoreResult = note.test_hit(note, _game); --> Test note hit result e.g. Marvelous, perfect etc.

            if (syn_context_set) then
                syn_context_set(7); --> Restore original context.
            end;

            if (testResult and testScoreResult == noteType) then
                local track = trackSystem:get_track(noteTrack); --> Get track.
                track:press(); --> Press track (doesn't actually hit note).

                note:on_hit(_game, noteType, i); --> Fire on hit event for current note with chosen result e.g. Marvelous.

                if (note.Type == "HeldNote") then
                    note:on_release(_game, noteType, i); --> If note is held, release it.
                end;
                
                track:release(); --> Release the track.
            end;
        end;
    end;
end);

library:Init();
