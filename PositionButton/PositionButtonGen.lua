-- Position Buttons
-- created by: Leo Kuenne
-- Version: 1
-- State: Stable
-- Desc:
-- This Plugin stores a given range of presets to a cuelist on an executor. The Cues are labeled like the cues are named with the option to remove a given phrase from the name.


local getHandle = gma.show.getobj.handle

function getLabel(str)
  return gma.show.getobj.label(getHandle(str))
end

function start()

    local startpreset = tonumber(gma.textinput('Start Positionpreset:', 'Tile'));
    local endpreset = tonumber(gma.textinput('End Positionpreset:', 'Tile'));
    local count = endpreset - startpreset;
    local exec = gma.textinput('Executorbutton:','Page.Buttonnumber');
    local execName = gma.textinput('Execsname','name');
    local charsToRemove = gma.textinput('Remove first chars:','String');
    
    gma.cmd('ClearAll');
    gma.cmd('SelFix '..startpreset);
    for j = 0,count do
        gma.cmd('Call Preset 2.'..startpreset+j);
        gma.cmd('Store Exec '..exec..' Cue '..j+1);
        local s = getLabel('Preset 2.'..startpreset+j);
        gma.cmd('Label Exec '..exec..' Cue '..j+(1)..' \"'..string.gsub(s,charsToRemove,'')..'\"');
    end
    
    gma.cmd('Label Exec '..exec..' \"'..execName..'\"');


end

function cleanUP()
    
    gma.echo('CleanUp called');

end

return start, cleanUP();