-- Gobopicker
-- created by: Leo Kuenne
-- Version: 1
-- State: Alpha
-- Desc:
-- This plugin generates the macros for the gobopicker


local getHandle = gma.show.getobj.handle;

function getLabel(str)
  return gma.show.getobj.label(getHandle(str));
end

function start()
    
    local group = tonumber(gma.textinput('Group:', 'Tile'));
    local groupname = getLabel('Group '..tostring(group));        
    
    local count = tonumber(gma.textinput('Count:',''));
    local startimage = tonumber(gma.textinput('Start Image:', 'Tile'));
    local imagedest = tonumber(gma.textinput('Image Destination:',''));
    local startmacro = tonumber(gma.textinput('Start Macro:', 'Tile'));
    local startseq = tonumber(gma.textinput('Sequence:',''));
    
    gma.echo(group);
    
    gma.cmd('ClearAll');
    gma.cmd('Group '..group);
    
    for j = 0,count do
        gma.cmd('Call Preset 3.'..(1+j));
        gma.cmd('Store Sequence '..startseq+j);
        
        
        gma.cmd('Label Seq '..startseq+j..' \"'..groupname..' Gobo '..(j+1)..'\"');
        
        gma.cmd('Store Macro 1.'..startmacro+j);
        gma.cmd('Label Macro 1.'..startmacro+j..' \"'..groupname..' Gobo '..(j+1)..'\"');
        gma.cmd('Store Macro 1.'..startmacro+j..'.1;');
        gma.cmd('Store Macro 1.'..startmacro+j..'.2;');
        gma.cmd('Assign Macro 1.'..startmacro+j..'.1 /cmd=\"Off Sequence '..startseq..'  Thru '..startseq+count..';  Toggle Sequence '..startseq+j..'\";');
        gma.cmd('Assign Macro 1.'..startmacro+j..'.2 /cmd=\"Copy Image '..startimage+j..'  At Image '..imagedest..' /o\";');
    end
    

    gma.cmd('ClearAll');

end

function cleanUP()
    
    gma.echo('CleanUp called');

end

return start, cleanUP();