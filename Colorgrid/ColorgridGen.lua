-- Colorpicker
-- created by: Leo Kuenne
-- Version: 1
-- State: Beta
-- Desc:
-- This Plugin generates a interactive Colorgrid.

-- ToDo:
-- Add an option to disable the Imagepart, so that the pure ExecButton Page can be used

local globalcolorpresets = 1;
local startseq_num = 1000;
local startexec_page = 4;
local startexec_num = 101;
local colornames = {'White', 'Red', 'Orange', 'Yellow', 'Fern Green', 'Green', 'Sea Green', 'Cyan', 'Lavender', 'Blue', 'Violet', 'Magenta', 'Pink'};
local colornames_prgm = {'white', 'red', 'orange', 'yellow', 'ferngreen', 'green', 'seaGreen', 'cyan', 'lavender', 'blue', 'violet', 'magenta', 'pink'};


--Vars coming from Showfile
local row_count = 0;
local allcolorexec_cmd = {'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor ', 'On Executor '};
local allcolormac_cmd = {'Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro ','Go Macro '};

function getAllVarsFromShowfile()

    --Row count
    gma.echo('Search colorgrid_row_count');
    if gma.show.getvar('colorgrid_row_count') ~= nil then
        row_count = tonumber(gma.show.getvar('colorgrid_row_count'));
        gma.echo('Found colorgrid_row_count: '..row_count);
    end
    
    --All Color Executors Commands
    for j = 0, 12 do
        if gma.show.getvar('allcolorexec_cmd_'..colornames_prgm[j+1]) ~= nil then
            gma.echo('Found allcolorexec_cmd_'..colornames_prgm[j+1]);
            allcolorexec_cmd[j+1] = gma.show.getvar('allcolorexec_cmd_'..colornames_prgm[j+1]);
        end
    end

end

function setAllVarsFromShowfile()
    --Set Row Count Var in Showfile
    gma.show.setvar('colorgrid_row_count', row_count+1);
    
    --Set All Color Executor Commands in Showfile
    for j = 0,12 do
        gma.show.setvar('allcolorexec_cmd_'..colornames_prgm[j+1], allcolorexec_cmd[j+1]);
    end
   
end

function start()
    
    getAllVarsFromShowfile();
    
    local start = gma.gui.confirm('Colorpicker | Row Count:'..row_count, 'Attention! Programmer will be cleared! Do you want to continue?');
    if (not start) then
        goto EOF
    end
   
    local callback_progress_All;
    local callback_progress_Fixture;
    local progress = 1;
    
    local exec_num = startexec_num + 15 + (15 * row_count);
    local seq_num = startseq_num + 15 + (15 * row_count);
    
    local fixt_group = gma.textinput('Which Fixture Group?', 'Tile');
    if (not fixt_group) then
        goto EOF
    end
    local fixt_group_name = gma.textinput('Fixture Group Name?', 'Name');
    if (not fixt_group_name) then
        goto EOF
    end

    
    --Build command to Off all Executors form start to End
    local allcolorexec_offcmd = 'Off Executor '..startexec_page..'.'..startexec_num..' Thru '..startexec_page..'.'..(startexec_num+12)..'';
    
    
    --If there are no Executors for All Fixtures yet, then create ones
    if gma.show.getobj.handle("Sequence 1000") == nil then
    
        --Create Vars
        for j = 0, 12 do
            gma.cmd('SetVar $colorgrid_All_'..colornames_prgm[j+1]..' = 0');
            
        end
        
        --Create Sequences and Execs for All Colors
        for j = 0, 12 do
            
            -- Store Seq and assign it to Executor
            gma.cmd('ClearAll'); 
            gma.cmd('Store Sequence '..startseq_num+j);
            gma.cmd('Assign Sequence '..startseq_num+j..' At Executor /o '..startexec_page..'.'..startexec_num+j);
            gma.cmd('Label Executor '..startexec_page..'.'..startexec_num+j..' /name "All '..colornames[j+1]..'"');
            
            
        end
    end
    
    --Executor with Color Data for the Fixturegroup
    for j = 0, 12 do
        
        --Call Preset
        gma.cmd('Group '..fixt_group..' At Preset 4.'..globalcolorpresets+j);
        
        --Store Preset Data in Sequence
        gma.cmd('Store Sequence '..seq_num+j);
        
        --Assign Sequence to Executor
        gma.cmd('Assign Sequence '..seq_num+j..' At Executor /o '..startexec_page..'.'..exec_num+j);
        
        --Label Executor
        gma.cmd('Label Executor '..startexec_page..'.'..exec_num+j..' /name "'..fixt_group_name..' '..colornames[j+1]..'"');
        
        --Assign Command to Off all All Color Executors except the All Color Executor for this color
        local s = startexec_page..'.'..exec_num..' Thru '..startexec_page..'.'..(exec_num+12);
        gma.cmd('Assign Executor '..startexec_page..'.'..exec_num+j..' Cue 1 /cmd="'..allcolorexec_offcmd..'-'..startexec_page..'.'..startexec_num+j..'; Off Exec '..s..' - '..startexec_page..'.'..exec_num+j..';"');

        --Add this Executor to the command of the All Color Executor for this color to this exec
        allcolorexec_cmd[j+1] = allcolorexec_cmd[j+1]..' + '..startexec_page..'.'..exec_num+j;
        gma.cmd('Assign Executor '..startexec_page..'.'..startexec_num+j..' Cue 1 /cmd="'..allcolorexec_cmd[j+1]..'"');
        
        
        --Set Appearence
        local color_r = {'100', 
                         '100',
                         '100',
                         '100',
                         '50',
                         '0',
                         '0',
                         '0',
                         '0',
                         '0',
                         '50',
                         '100',
                         '100',
                        };
                        
        local color_g = {'100', 
                         '0',
                         '50',
                         '100',
                         '100',
                         '100',
                         '50',
                         '0',
                         '50',
                         '100',
                         '50',
                         '0',
                         '0',
                        };
                        
        local color_b = {'100', 
                         '0',
                         '0',
                         '0',
                         '0',
                         '0',
                         '50',
                         '100',
                         '100',
                         '100',
                         '100',
                         '100',
                         '50',
                        };
        gma.echo(j);
        gma.cmd('Appearance Exec '..startexec_page..'.'..exec_num+j..' /red='..color_r[j+1]..' /green='..color_g[j+1]..' /blue='..color_b[j+1]..';');                
        
        
        gma.cmd('ClearAll');
    end
    
    setAllVarsFromShowfile();
    
    ::EOF::
end

function cleanup()
     gma.echo("Cleanup called");
end

return start, cleanup;