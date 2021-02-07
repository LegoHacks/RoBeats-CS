--[[
    RoBeats CS Auto Player

    By Spencer#0003

    I actually documentated this script :flushed:

    To the RoBeats CS devs,
        Nice attempt of jumpscaring people who use my script (https://sperg.club/uploads/ixBJSEGqHs12bdih.png) but this was a VERY EASY unpatch :lolfuckyou:
        07/02/21: You changed it to a rickroll? Too bad you can't patch for shit :lolfuckyou:
]]

-- ScriptWare support

local getupvalue = (getupvalue or debug.getupvalue);

-- Init

local replicatedStorage = game:GetService("ReplicatedStorage");
local runService = game:GetService("RunService");

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Utilities/main/UI.lua"))();

-- Main

local getNoteType;
local _game, trackSystem;
local password; --> Fuck your shit jumpscare, cunt.

do --> Do blocks are sexy.
    local trackSystemModule = require(replicatedStorage.Local.TrackSystem);
    local _gameModule = require(replicatedStorage.Local.GameLocal);

    local trackSystemNew = trackSystemModule.new;
    local gameLocalNew = _gameModule.new;

    _gameModule.new = newcclosure(function(...)
        _game = gameLocalNew(...); --> Grab the game table.
        password = getupvalue(_game.can_mult, 1);
        return _game;
    end);

    trackSystemModule.new = newcclosure(function(...)
        trackSystem = trackSystemNew(...); --> Grab the tracksystem.
        return trackSystem;
    end);

    -- Thanks lolasj12491294

    local noteResults = require(replicatedStorage.Shared.NoteResult); -- Auto updating because you "devs" are fucking autistic, love you though no homo :)

    local enum_res = {
        missResult = noteResults.Miss;
        okayResult = noteResults.Okay;
        goodResult = noteResults.Good;
        greatResult = noteResults.Great;
        perfectResult = noteResults.Perfect;
        marvelousResult = noteResults.Marvelous;
    };

    local mapped_e = {
        enum_res.marvelousResult;
        enum_res.perfectResult;
        enum_res.greatResult;
        enum_res.goodPercentage;
        enum_res.okayResult;
        enum_res.missPercentage;
    };

    function getNoteType()
        local r = Random.new();
        for i, v in ipairs{library.flags.marvelousPercentage, library.flags.perfectPercentage, library.flags.greatPercentage, library.flags.goodPercentage, library.flags.okayResult} do
            if (r:NextNumber(0, 100) <= v) then
                return mapped_e[i];
            end;
        end;

        return enum_res.missPercentage;
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
    text = "Okay";
    flag = "okayResult";
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
            if (syn_context_set or setidentity) then
                (syn_context_set or setidentity)(2); --> Synapse and ScriptWare fucking error without this :kms:
            end;
            
            local noteType = getNoteType();
            local note = notes:get(i, password); --> Get the note.
            local noteTrack = note:get_track_index(); --> Get the track index.
            local testResult, testScoreResult = note.test_hit(note, _game); --> Test note hit result e.g. Marvelous, perfect etc.
            local testRelease, releaseScoreResult = note.test_release(note, _game); --> Test note hit result e.g. Marvelous, perfect etc.

            if (syn_context_set) then
                syn_context_set(7); --> Restore original context.
            elseif (setidentity) then
                setidentity(8); --> ScriptWare's context is 8 instead of 7 for some reason.
            end;

            local track = trackSystem:get_track(noteTrack); --> Get track.

            if (testResult and testScoreResult == noteType) then
                track:press(); --> Press track (doesn't actually hit note).
                note:on_hit(_game, noteType, i, password); --> Fire on hit event for current note with chosen result e.g. Marvelous.
                delay(math.random(0.01, 0.5), function()
                    if (note.Type ~= "HeldNote") then
                        track:release(); --> Release the track.
                    end;
                end);
            elseif (testRelease and releaseScoreResult == noteType) then
                if (note.Type == "HeldNote") then
                    note:on_release(_game, noteType, i, password); --> If note is held, release it.
                    track:release(); --> Release the track.
                end;
            end;
        end;
    end;
end);

library:Init();
