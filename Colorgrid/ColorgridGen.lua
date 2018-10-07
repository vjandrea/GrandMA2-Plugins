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
        gma.echo('Found colorgrid_row_count');
        local temp = gma.show.getvar('colorgrid_row_count');
        row_count = tonumber(temp);
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
    
        -- callback_progress_All = gma.gui.progress.start("All Row");
        -- gma.gui.progress.setrange(callback_progress_All,1,400);
        -- gma.gui.progress.set(callback_progress_All,progress);
        
        
        --Create Vars
        for j = 0, 12 do
            gma.cmd('SetVar $colorgrid_All_'..colornames_prgm[j+1]..' = 0');
            
            -- progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
        end
        
        --Create Sequences and Execs for All Colors
        for j = 0, 12 do
            -- progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
            
            -- Store Seq and assign it to Executor
            gma.cmd('ClearAll'); 
            gma.cmd('Store Sequence '..startseq_num+j);
            gma.cmd('Assign Sequence '..startseq_num+j..' At Executor /o '..startexec_page..'.'..startexec_num+j);
            gma.cmd('Label Executor '..startexec_page..'.'..startexec_num+j..' /name "All '..colornames[j+1]..'"');
            
            --Build command: Exclude the current exec from the command allcolorexec_offcmd
            allcolorexec_cmd[j+1] = allcolorexec_offcmd..'-'..startexec_page..'.'..startexec_num+j..'; '..allcolorexec_cmd[j+1];
            --Assign command to Cue
            gma.cmd('Assign Executor '..startexec_page..'.'..startexec_num+j..' Cue 1 /cmd="'..allcolorexec_cmd[j+1]..'"');
            
        end
        
      -- gma.gui.progress.stop(callback_progress_All);
    end
    
    -- Reset Progress
    -- progress = 1;
    -- callback_progress_Fixture = gma.gui.progress.start("Fixture Row");
    -- gma.gui.progress.setrange(callback_progress_Fixture,1,600);
    -- gma.gui.progress.set(callback_progress_Fixture,progress);
    
    
    --Executor with Color Data for the Fixturegroup
    for j = 0, 12 do
        -- progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
    
        --Call Preset
        gma.cmd('Group '..fixt_group..' At Preset 4.'..globalcolorpresets+j);
        
        --Store Preset Data in Sequence
        gma.cmd('Store Sequence '..seq_num+j);
        
        --Assign Sequence to Executor
        gma.cmd('Assign Sequence '..seq_num+j..' At Executor /o '..startexec_page..'.'..exec_num+j);
        
        --Label Executor
        gma.cmd('Label Executor '..startexec_page..'.'..exec_num+j..' /name "'..fixt_group_name..' '..colornames[j+1]..'"');
        
        --Assign Command to Off all All Color Executors except the All Color Executor for this color
        gma.cmd('Assign Executor '..startexec_page..'.'..exec_num+j..' Cue 1 /cmd="'..allcolorexec_offcmd..'-'..startexec_page..'.'..startexec_num+j..'"');

        --Add this Executor to the command of the All Color Executor for this color to this exec
        allcolorexec_cmd[j+1] = allcolorexec_cmd[j+1]..' + '..startexec_page..'.'..exec_num+j;
        gma.cmd('Assign Executor '..startexec_page..'.'..startexec_num+j..' Cue 1 /cmd="'..allcolorexec_cmd[j+1]..'"');
        
        -- {'White', 'Red', 'Orange', 'Yellow', 'Fern Green', 'Green', 'Sea Green', 'Cyan', 'Lavender', 'Blue', 'Violet', 'Magenta', 'Pink'}
        
        
        --Set Appearence
        local color_r = ({  [0] = '100', 
                            [1] = '100',
                            [2] = '100',
                            [3] = '100',
                            [4] = '50',
                            [5] = '0',
                            [6] = '0',
                            [7] = '0',
                            [8] = '0',
                            [9] = '0',
                            [10] = '50',
                            [11] = '100',
                            [12] = '100',
                        })[i];
                        
        local color_g = ({  [0] = '100', 
                            [1] = '0',
                            [2] = '0',
                            [3] = '0',
                            [4] = '50',
                            [5] = '100',
                            [6] = '100',
                            [7] = '100',
                            [8] = '100',
                            [9] = '100',
                            [10] = '50',
                            [11] = '0',
                            [12] = '0',
                        })[i];
                        
        local color_b = ({  [0] = '100', 
                            [1] = '0',
                            [2] = '0',
                            [3] = '0',
                            [4] = '0',
                            [5] = '0',
                            [6] = '50',
                            [7] = '100',
                            [8] = '100',
                            [9] = '100',
                            [10] = '100',
                            [11] = '100',
                            [12] = '50',
                        })[i];
        gma.cmd('Appearance '..startexec_page..'.'..exec_num+j..' /red='..color_r..' /green='..color_g..' /blue='..color_b..';');                
        
        
        gma.cmd('ClearAll');
    end
    
    setAllVarsFromShowfile();
    
    ::EOF::
end

function cleanup()
     gma.echo("Cleanup called");
end

return start, cleanup;