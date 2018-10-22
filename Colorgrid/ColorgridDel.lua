-- Colorpicker
-- created by: Leo Kuenne
-- Version: 0.1
-- State: Alpha
-- Desc:
-- This Plugin deletes the last line of the colorpicker.


local universalcolorpresets = 1000;
local globalcolorpresets = 1020;
local startmacro_num = 1000;
local startseq_num = 1000;
local startexec_page = 3;
local startexec_num = 101;
local startimagestorage_num = 1000;
local startimage_num = 1030;
local layoutview_num = 10;
local resetmacro_num = 999;
local row_count = 0;
local colornames = {'White', 'Red', 'Orange', 'Yellow', 'Fern Green', 'Green', 'Sea Green', 'Cyan', 'Lavender', 'Blue', 'Violet', 'Magenta', 'Pink'};
local colornames_prgm = {'white', 'red', 'orange', 'yellow', 'ferngreen', 'green', 'seaGreen', 'cyan', 'lavender', 'blue', 'violet', 'magenta', 'pink'};

function start()
    getAllVarsFromShowfile();
    
    local start = gma.gui.confirm('Colorpicker | Row Count:'..row_count, 'Attention! Programmer will be cleared! Do you want to continue?');
    if (not start) then
        goto EOF
    end
    
    gma.cmd('Delete Seq '..startseq_num..' Thru ' ..startseq_num+15+((row_count+1)*15));
    gma.cmd('Delete Image '..startimage_num..' Thru ' ..startimage_num+15+((row_count+1)*15));
    gma.cmd('Delete Macro '..startmacro_num..' Thru ' ..startmacro_num+15+((row_count+1)*15));
    gma.cmd('Delete Preset 4.'..globalcolorpresets..' Thru ' ..globalcolorpresets+15+((row_count+1)*15));
    
    --Set All Color Executor Commands in Showfile
    for j = 0,12 do
        gma.cmd('SetVar $allcolormac_cmd_'..colornames_prgm[j+1]..'=;');
        gma.cmd('SetVar $allcolorexec_cmd_'..colornames_prgm[j+1]..'=;');
        gma.cmd('SetVar $colorgrid_all_'..colornames_prgm[j+1]..'=;');
    end
    
    while true do
        local name = gma.textinput('Colorpicker', 'Name');
        if (not name) then
            break;
        end
        for j=0,12 do
            gma.cmd('SetVar $colorgrid_'..name..'_'..colornames_prgm[j+1]..'=;');
        end
    end
    
    gma.cmd('SetVar $colorgrid_row_count=;');
    
    ::EOF::
end

function getAllVarsFromShowfile()
    --Row count
    if gma.show.getvar('colorgrid_row_count') ~= nil then
        row_count = tonumber(gma.show.getvar('colorgrid_row_count'));
        gma.echo('Found colorgrid_row_count: '..row_count);
    end
end


function cleanup()
    gma.cmd('SetVar $colorgrid_row_count=;');
    gma.echo('Cleanup called');
end

return start,cleanup();
