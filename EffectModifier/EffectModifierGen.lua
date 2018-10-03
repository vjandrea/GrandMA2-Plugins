-- Effect Modifier
-- created by: Leo Kuenne
-- Version: 0.5
-- State: Alpha
-- Desc:
-- This plugin generates Sequences that modify specific effects in the effect pool.
-- They hold commands which assign different groups, blocks, phase, direction and wings to the effect.
-- The type of sequence is defined by the variables at the top of the script.


-- ToDo:
-- Instead of counts, define the items to modify the effects in string arrays
-- Generate Macros for the Wings Modifier. There is a limited char count in the cmdline of the cue.

local getHandle = gma.show.getobj.handle

function getLabel(str)
  return gma.show.getobj.label(getHandle(str))
end

function start()

    local i_startseq = 1;
    
    local i_effectitem = 1;
    local i_effectitemcount = 4;
    local i_effectlines = 2;
    
    local b_groups = 1;
    local i_groupscount = 4;
    
    local b_blocks = 1;
    local i_blockscount = 4;
    
    local b_wings = 1;
    local i_wingscount = 4; --From 2 on! Cue 1 is None, Cue 2 is 2, Cue 3 is 3
    local b_wingsWithSym = 1;
    
    local b_phase = 1;
    local i_phasecount = 5;
    local b_dir = 1;
    local i_dircount = 4;
    
    if b_groups == 1 then
        for i = 0, i_groupscount do
            gma.cmd('Store Seq '..i_startseq..' Cue '..(i+1)..';');
            gma.cmd('Assign Seq '..i_startseq..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /groups='..i..'\" ;')
            gma.cmd('Assign Seq '..i_startseq..' Cue '..(i+1)..' /name= \"'..((i ~= 0) and i or 'None'  )..'\" ;')
     
        end
        gma.cmd('Assign Seq '..i_startseq..' /name=\"Groups";');
    end
    
    if b_blocks == 1 then
        for i = 0, i_blockscount do
            gma.cmd('Store Seq '..(i_startseq+1)..' Cue '..(i+1)..'; ');
            gma.cmd('Assign Seq '..(i_startseq+1)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /blocks='..i..'\" ;');
            gma.cmd('Assign Seq '..(i_startseq+1)..' Cue '..(i+1)..' /name= \"'..((i ~= 0) and i or 'None'  )..'\" ;')
        end
        gma.cmd('Assign Seq '..(i_startseq+1)..' /name=\"Blocks";');
    end
    
    if b_wings == 1 then
        if b_wingsWithSym == 1 then
        
        else
            for i = 0, i_wingscount do
                gma.cmd('Store Seq '..(i_startseq+2)..' Cue '..(i+1)..'; ');
                gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /wings='..i..'\" ;');
                gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /name= \"'..((i ~= 0) and i or 'None'  )..'\" ;');
            end
        end
    
    
--    
--        for i = 0, i_wingscount do
--            if i == 0 then
--                gma.cmd('Store Seq '..(i_startseq+2)..' Cue '..(i+1)..'; Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /wings='..i..'\" ;');
--                gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /name= \"None\" ;');
--            end
--            
--            if i > 0 then
--                if b_wingsWithSym == 1 then
--                    local s_cmdline = '';                    
--                    for c = 0, (i_effectitemcount-1) do
--                        for j = 1, (i_effectlines) do
--                            if j % 2 == 0 then
--                                s_cmdline = s_cmdline..'Assign Effect 1.'..(i_effectitem+c)..'.'..(j)..' /wings='..(i+1)..'; ';
--                            else
--                                s_cmdline = s_cmdline..'Assign Effect 1.'..(i_effectitem+c)..'.'..(j)..' /wings='..-(i+1)..'; ';
--                            end
--                        end
--                    end
--                    
--                    gma.cmd('Store Seq '..(i_startseq+2)..' Cue '..(i+1)..'; ');
--                    gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /cmd= \"'..s_cmdline..'\" ;');
--                    gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /name= \"'..((i ~= 0) and (''..(i+1)..'..-'..(i+1)..'') or 'None'  )..'\" ;');
--                else
--                    gma.cmd('Store Seq '..(i_startseq+2)..' Cue '..(i+1)..'; Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /wings='..(i+1)..'\" ;');
--                    gma.cmd('Assign Seq '..(i_startseq+2)..' Cue '..(i+1)..' /name= \"'..(i+1)..'\" ;');
--                end
--            end
--            
--        end
--        gma.cmd('Assign Seq '..(i_startseq+2)..' /name=\"Wings";');--
    end
    
    if b_phase == 1 then
        for i = 0, (i_phasecount-1) do
            local cmdline = ({[0] = '0..0', [1] = '0..90', [2] = '0..180', [3] = '0..270', [4] = '0..360'})[i];
            gma.cmd('Store Seq '..(i_startseq+3)..' Cue '..(i+1)..'; ');
            gma.cmd('Assign Seq '..(i_startseq+3)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /phase='..cmdline..'\" ;');
            gma.cmd('Assign Seq '..(i_startseq+3)..' Cue '..(i+1)..' /name= \"'..cmdline..'\" ;');
        end
        gma.cmd('Assign Seq '..(i_startseq+3)..' /name=\"Phase";');
    end
    
    if b_dir == 1 then
        for i = 0, (i_dircount-1) do
            local cmdline = ({[0] = '>', [1] = '<', [2] = '>bounce', [3] = '<bounce'})[i];
            gma.cmd('Store Seq '..(i_startseq+4)..' Cue '..(i+1)..'; ');
            gma.cmd('Assign Seq '..(i_startseq+4)..' Cue '..(i+1)..' /cmd= \"Assign Effect 1.'..i_effectitem..' Thru 1.'..i_effectitem + i_effectitemcount..' /dir='..cmdline..'\" ;');
            gma.cmd('Assign Seq '..(i_startseq+4)..' Cue '..(i+1)..' /name= \"'..cmdline..'\" ;');
        end
        gma.cmd('Assign Seq '..(i_startseq+4)..' /name=\"Dir";');
    end
    
end

function cleanUP()
    
    gma.echo('CleanUp called');

end

return start, cleanUP();