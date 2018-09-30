-- Colorpicker
-- created by: Leo Kuenne
-- Version: 0.5
-- State: Alpha
-- Desc:
-- This Plugin generates a interactive Colorgrid for LayoutViews.

-- Changelog from version 0.4 to 0.5:
-- Removed: generating universal color presets

local globalcolorpresets = 1;
local startmacro_num = 1000;
local startseq_num = 1000;
local startexec_page = 4;
local startexec_num = 101;
local startimagestorage_num = 1000;
local startimage_num = 1030;
local layoutview_num = 10;
local layoutview_pos_startX = 0;
local layoutview_pos_startY = 0;
local layoutview_pos_spacingX = 0.25;
local layoutview_pos_spacingY = 0.25;
local resetmacro_num = 999;
local resetmacro_lines = 0;
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
    
    --All Color Macro Commands
    for j = 0, 12 do
        if gma.show.getvar('allcolormac_cmd_'..colornames_prgm[j+1]) ~= nil then
            gma.echo('Found allcolormac_cmd_'..colornames_prgm[j+1]);
            allcolormac_cmd[j+1] = gma.show.getvar('allcolormac_cmd_'..colornames_prgm[j+1]);
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
    
    for j = 0,12 do
        gma.show.setvar('allcolormac_cmd_'..colornames_prgm[j+1], allcolormac_cmd[j+1]);
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
    local mac_num = startmacro_num + 15 + (15 * row_count);
    local image_num = startimage_num + 15 + (15 * row_count);
    
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
    
        callback_progress_All = gma.gui.progress.start("All Row");
        gma.gui.progress.setrange(callback_progress_All,1,400);
        gma.gui.progress.set(callback_progress_All,progress);
        
        --Create Reset Macro
        gma.cmd('Store Macro '..resetmacro_num..';');
        
        --Create Vars
        for j = 0, 12 do
            gma.cmd('SetVar $colorgrid_All_'..colornames_prgm[j+1]..' = 0');
            
            progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
        end
        
        --Create LayoutView
        gma.cmd('Store  Layout '..layoutview_num);
        gma.cmd('Layout '..layoutview_num);
        
        --Create Sequences and Execs for All Colors
        for j = 0, 12 do
            progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
            
            -- Store Seq and assign it to Executor
            gma.cmd('ClearAll'); 
            gma.cmd('Store Sequence '..startseq_num+j);
            gma.cmd('Assign Sequence '..startseq_num+j..' At Executor /o '..startexec_page..'.'..startexec_num+j);
            gma.cmd('Label Executor '..startexec_page..'.'..startexec_num+j..' /name "All '..colornames[j+1]..'"');
            
            --Build command: Exclude the current exec from the command allcolorexec_offcmd
            allcolorexec_cmd[j+1] = allcolorexec_offcmd..'-'..startexec_page..'.'..startexec_num+j..'; '..allcolorexec_cmd[j+1];
            --Assign command to Cue
            gma.cmd('Assign Executor '..startexec_page..'.'..startexec_num+j..' Cue 1 /cmd="'..allcolorexec_cmd[j+1]..'"');
            
            --Create Macro and label it
            gma.cmd('Store Macro 1.'..startmacro_num+j);
            gma.cmd('Label Macro 1.'..startmacro_num+j..' \"All '..colornames[j+1]..'\"')
            
            --Create Macrolines for: 
            --1. Start Executor with Color Data
            gma.cmd('Store Macro 1.'..startmacro_num+j..'.1');        
            gma.cmd('Assign Macro 1.'..startmacro_num+j..'.1 /cmd = \"Go Executor '..startexec_page..'.'..startexec_num+j..'\"');
            
            --2. Copy On Image to Imageplace
            gma.cmd('Store Macro 1.'..startmacro_num+j..'.2');
            gma.cmd('Assign Macro 1.'..startmacro_num+j..'.2 /cmd = \"Copy Image '..startimagestorage_num+(2*j)..' At '..startimage_num+j..' /o\"');
            
            --3. Copy Off Image to Imageplace
            for k = 0, 12 do
                progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
            
                gma.cmd('Store Macro 1.'..startmacro_num+j..'.'..(3+k));
                if k ~= j then
                    gma.cmd('Assign Macro 1.'..startmacro_num+j..'.'..(3+k)..' /cmd = \"[$colorgrid_All_'..colornames_prgm[k+1]..' == 1]     Copy Image '..startimagestorage_num+1+(k*2)..'  At '..startimage_num+k..' /o;\"');
                end
            end
            
            --4. Label Image correctly
            gma.cmd('Store Macro 1.'..startmacro_num+j..'.16');
            gma.cmd('Assign Macro 1.'..startmacro_num+j..'.16 /cmd = \"Label Image '..startimage_num+j..' All_'..colornames[j+1]..'\"');
            
            --5. Set colorgrid_All Vars to false and for the active Color to true
            for k = 0, 12 do
                progress = progress+1; gma.gui.progress.set(callback_progress_All,progress);
                gma.cmd('Store Macro 1.'..startmacro_num+j..'.'..(17+k));
                if k ~= j then
                    gma.cmd('Assign Macro 1.'..startmacro_num+j..'.'..(17+k)..' /cmd = \"[$colorgrid_All_'..colornames_prgm[k+1]..' == 1] SetVar $colorgrid_All_'..colornames_prgm[k+1]..'=0;\"');
                end
            end
            gma.cmd('Store Macro 1.'..startmacro_num+j..'.'..(30));
            gma.cmd('Assign Macro 1.'..startmacro_num+j..'.'..(30)..' /cmd = \"SetVar $colorgrid_All_'..colornames_prgm[j+1]..' = 1;\"');
            
            --5. Go Macros for all fixtures for this Color
            gma.cmd('Store Macro 1.'..startmacro_num+j..'.'..(31));
            gma.cmd('Assign Macro 1.'..startmacro_num+j..'.'..(31)..' /cmd = \"'..allcolormac_cmd[j+1]..'\"');
            
            
            --Create Images
            gma.cmd('Copy Image '..startimagestorage_num+(1+(2*j))..' At '..startimage_num+j);
            gma.cmd('Label Image '..startimage_num+j..' \"All '..colornames[j+1]..'\"');
                
            --Assign Macro to LayoutView
            gma.cmd('ClearAll');
            gma.cmd('Assign Macro '..startmacro_num+j..' at Layout '..layoutview_num..' /x='..layoutview_pos_startX+(layoutview_pos_spacingX+1)*j..' /y='..layoutview_pos_startY..';');
        end
        
      gma.gui.progress.stop(callback_progress_All);
    end
    
    --Reset Progress
    progress = 1;
    callback_progress_Fixture = gma.gui.progress.start("Fixture Row");
    gma.gui.progress.setrange(callback_progress_Fixture,1,600);
    gma.gui.progress.set(callback_progress_Fixture,progress);
    
    
    --Executor with Color Data for the Fixturegroup
    for j = 0, 12 do
        progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
    
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
        
        gma.cmd('ClearAll');
    end
    
    
    --Macro part for the Fixturegroup
    for j = 0, 12 do
        progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
    
        --Create Macro and label it
        gma.cmd('Store Macro 1.'..mac_num+j);
        gma.cmd('Label Macro 1.'..mac_num+j..' \"'..fixt_group_name..' '..colornames[j+1]..'\"');
        
        --Create Macrolines for: 
        --1. Start Executor with Color Data
        gma.cmd('Store Macro 1.'..mac_num+j..'.1');
        gma.cmd('Assign Macro 1.'..mac_num+j..'.1 /cmd = \"Go Executor '..startexec_page..'.'..exec_num+j..'\"');
        
        --2. Copy On Image to Imageplace
        gma.cmd('Store Macro 1.'..mac_num+j..'.2');
        gma.cmd('Assign Macro 1.'..mac_num+j..'.2 /cmd = \"Copy Image '..startimagestorage_num+(2*j)..' At '..image_num+j..'/o\"');
        
        --3. Copy Off Image to Imageplace
        for k = 0, 12 do
            progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
            
            gma.cmd('Store Macro 1.'..mac_num+j..'.'..(3+k));
            if k ~= j then
                gma.cmd('Assign Macro 1.'..mac_num+j..'.'..(3+k)..' /cmd = \"[$colorgrid_'..fixt_group_name..'_'..colornames_prgm[k+1]..' == 1]     Copy Image '..startimagestorage_num+1+(k*2)..'  At '..image_num+k..' /o;\"');
            end
        end
        --4.Copy Off Image for the All Color Execs
        
        for k = 0, 12 do
            progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
            
            gma.cmd('Store Macro 1.'..mac_num+j..'.'..(16+k));
            if k ~= j then
                gma.cmd('Assign Macro 1.'..mac_num+j..'.'..(16+k)..' /cmd = \"[$colorgrid_All_'..colornames_prgm[k+1]..' == 1]     Copy Image '..startimagestorage_num+1+(k*2)..'  At '..startimage_num+k..' /o;\"');
            end
        end
        --5.Set colorgrid_Fixt Vars to false and for the active Color to true
        for k = 0, 12 do
            progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
            gma.cmd('Store Macro 1.'..mac_num+j..'.'..(29+k));
            if k ~= j then
                gma.cmd('Assign Macro 1.'..mac_num+j..'.'..(29+k)..' /cmd = \"[$colorgrid_'..fixt_group_name..'_'..colornames_prgm[k+1]..' == 1] SetVar $colorgrid_'..fixt_group_name..'_'..colornames_prgm[k+1]..'=0;\"');
            end
        end
        gma.cmd('Store Macro 1.'..mac_num+j..'.'..(30));
        gma.cmd('Assign Macro 1.'..mac_num+j..'.'..(30)..' /cmd = \"SetVar $colorgrid_'..fixt_group_name..'_'..colornames_prgm[j+1]..' = 1;\"');
        
        
        --Add this Macro to allcolor cmd and reassign cmd
        allcolormac_cmd[j+1] = allcolormac_cmd[j+1]..' + '..mac_num+j;
        gma.echo(allcolormac_cmd[j+1]);
        gma.cmd('Assign Macro 1.'..startmacro_num+j..'.'..(31)..' /cmd = \"'..allcolormac_cmd[j+1]..'\"');
        
        --Assign Macro
        gma.cmd('Assign Macro '..mac_num+j..' at Layout '..layoutview_num..' /x='..layoutview_pos_startX+(layoutview_pos_spacingX+1)*j..' /y='..layoutview_pos_startY+(layoutview_pos_spacingY+1)*(row_count+1)..';');
    end

    --Image Part
    for j = 0, 12 do
        progress = progress+1;gma.gui.progress.set(callback_progress_Fixture,progress);
        
        gma.cmd('Copy Image '..startimagestorage_num+(1+(2*j))..' At '..image_num+j);
        gma.cmd('Label Image '..image_num+j..' \"'..fixt_group_name..' '..colornames[j+1]..'\"');
    end
    
    
    gma.gui.progress.stop(callback_progress_Fixture);
    
    setAllVarsFromShowfile();
    gma.cmd('ClearAll');
    
    gma.gui.msgbox('Colorpicker','Finished!')
    
    ::EOF::
end

function cleanup()
     gma.echo("Cleanup called");
end

return start, cleanup;