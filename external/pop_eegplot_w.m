% pop_eegplot_w() - Visually inspect EEG data using a scrolling display.
%                 Perform rejection or marking for rejection of visually 
%                 (and/or previously) selected data portions (i.e., stretches 
%                 of continuous data or whole data epochs).
%    Almost identical to pop_eegplot(), but allow scroll with mouse wheel, 
%    to remove channels / components, looks better in wide-screen monitor.
%
% Usage:
%   >> pop_eegplot_w( EEG ) % Scroll EEG channel data. Allow marking for rejection via
%                         % button 'Update Marks' but perform no actual data rejection.
%                         % Do not show or use marks from previous visual inspections
%                         % or from semi-auotmatic rejection.
%   >> pop_eegplot_w( EEG, icacomp, superpose, reject );
%
% Graphic interface:
%   "Add to previously marked rejections" - [edit box] Either YES or NO. 
%                    Command line equivalent: 'superpose'.
%   "Reject marked trials" - [edit box] Either YES or NO. Command line
%                    equivalent 'reject'.
% Inputs:
%   EEG        - input EEG dataset
%   icacomp    - type of rejection 0 = independent components;
%                                  1 = data channels. {Default: 1 = data channels}
%   superpose  - 0 = Show new marks only: Do not color the background of data portions 
%                    previously marked for rejection by visual inspection. Mark new data 
%                    portions for rejection by first coloring them (by dragging the left 
%                    mouse button), finally pressing the 'Update Marks' or 'Reject' 
%                    buttons (see 'reject' below). Previous markings from visual inspection 
%                    will be lost.
%                1 = Show data portions previously marked by visual inspection plus 
%                    data portions selected in this window for rejection (by dragging 
%                    the left mouse button in this window). These are differentiated 
%                    using a lighter and darker hue, respectively). Pressing the 
%                    'Update Marks' or 'Reject' buttons (see 'reject' below)
%                    will then mark or reject all the colored data portions.
%                {Default: 0, show and act on new marks only}
%   reject     - 0 = Mark for rejection. Mark data portions by dragging the left mouse 
%                    button on the data windows (producing a background coloring indicating 
%                    the extent of the marked data portion).  Then press the screen button 
%                    'Update Marks' to store the data portions marked for rejection 
%                    (stretches of continuous data or whole data epochs). No 'Reject' button 
%                    is present, so data marked for rejection cannot be actually rejected 
%                    from this eegplot_w() window. 
%                1 = Reject marked trials. After inspecting/selecting data portions for
%                    rejection, press button 'Reject' to reject (remove) them from the EEG 
%                    dataset (i.e., those portions plottted on a colored background. 
%                    {default: 1, mark for rejection only}
%
%  topcommand   -  Input deprecated.  Kept for compatibility with other function calls
% Outputs:
%   Modifications are applied to the current EEG dataset at the end of the
%   eegplot_w() call, when the user presses the 'Update Marks' or 'Reject' button.
%   NOTE: The modifications made are not saved into EEGLAB history. As of v4.2,
%   events contained in rejected data portions are remembered in the EEG.urevent
%   structure (see EEGLAB tutorial).
%
% Original author: Arnaud Delorme, CNL / Salk Institute, 2001-2002
% Modified by: Mindaugas Baranauskas, 2017
%
% See also: eeglab(), eegplot_w(), eegplot(), pop_eegplot(), pop_rejepoch()

% Copyright (C) 2001-2002 Arnaud Delorme, Salk Institute, arno@salk.edu
% Copyright (C) 2017 Mindaugas Baranauskas
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% 2002-01-25 reformated help & license -ad 
% 2002-03-07 added srate argument to eegplot_w call -ad
% 2002-03-27 added event latency recalculation for continuous data -ad
% 2017-01-24 allow select channels/components for rejection -mb

function com = pop_eegplot_w( EEG, icacomp, superpose, reject, topcommand, varargin)

com = '';
if ~exist('topcommand','var')
    topcommand = [];
end;
if nargin < 1
	help pop_eegplot_w;
	return;
end;	
if nargin < 2
	icacomp = 1;
end;	
if nargin < 3
	superpose = 0;
end;
if nargin < 4
	reject = 1;
end;
if icacomp == 0
	if isempty( EEG.icasphere )
		disp('Error: you must run ICA first'); return;
	end;
end;

if nargin < 3 && EEG.trials > 1

	% which set to save
	% -----------------
    uilist       = { { 'style' 'text' 'string' 'Add to previously marked rejections? (checked=yes)'} , ...
         	         { 'style' 'checkbox' 'string' '' 'value' 1 } , ...
                     { 'style' 'text' 'string' 'Reject marked trials? (checked=yes)'} , ...
         	         { 'style' 'checkbox' 'string' '' 'value' 0 } };
    result = inputgui( { [ 2 0.2] [ 2 0.2]} , uilist, 'pophelp(''pop_eegplot_w'');', ...
                       fastif(icacomp==0, 'Manual component rejection -- pop_eegplot_w()', ...
								'Reject epochs by visual inspection -- pop_eegplot_w()'));
	size_result  = size( result );
	if size_result(1) == 0 return; end;
   
   if result{1}, superpose=1; end;
   if ~result{2}, reject=0; end;

end;


if icacomp == 1
     elecrange = [1:EEG.nbchan];
else elecrange = [1:size(EEG.icaweights,1)];
end;

if reject
    com1 = ...
        [  'EEGTMP=EEG; '...
        'if ~isempty(TMPREJCHN); '];
    if icacomp == 1
        com1 = [ com1 ...
            '  [EEGTMP LASTCOM1] = pop_select(EEGTMP, ''nochannel'',TMPREJCHN); ' ];
    else
        com1 = [ com1 ...
            '  [EEGTMP LASTCOM1] = pop_subcomp(EEGTMP, TMPREJCHN); ' ];
    end;
    com1 = [ com1 ...
        '  if ~isempty(LASTCOM1),' ...
        '     EEGTMP = eegh(strrep(LASTCOM1,''EEGTMP'',''EEG''), EEGTMP); ' ...
        '  end;' ...
        'else LASTCOM1=''''; ' ...
        'end; ' ];
    if EEG.trials > 1
        com3 = '[EEGTMP LASTCOM2] = pop_rejepoch(EEGTMP, tmprej, 0); ' ;
    else
        com3 = '[EEGTMP LASTCOM2] = eeg_eegrej(EEGTMP,eegplot2event(TMPREJ, -1)); ' ;
    end;
    
    % Call from Darbeliai pop_nuoseklus_apdorojimas ?
    CallFromDarbeliai=0;
    figDarb=findobj('name', 'pop_nuoseklus_apdorojimas', 'Type','figure','Tag','Darbeliai');
    if ~isempty(figDarb)
        DarbObj1=findobj(figDarb,'tag','pushbutton1');
        DarbObj2=findobj(figDarb,'tag','checkbox_baigti_anksciau');
        if ~isempty(DarbObj1) && ~isempty(DarbObj2)
            if and(strcmpi(get(DarbObj1,'Enable'),'off'), strcmpi(get(DarbObj2,'Visible'),'on'))
                CallFromDarbeliai=1;
            end;
        end;
    end;
    if CallFromDarbeliai
        newset_param=', 0, ''setname'', EEGTMP.setname'; % don't ask for saving
    else
        newset_param=', CURRENTSET'; % ask for saving
    end;
    
    com4 = [ ...
        'if ~isempty(LASTCOM2),' ...
        '     EEGTMP = eegh(strrep(LASTCOM2,''EEGTMP'',''EEG''), EEGTMP);' ...
        'end;' ...
        'if or(~isempty(LASTCOM1),~isempty(LASTCOM2))' ...
        '  [ALLEEG EEG CURRENTSET tmpcom] = pop_newset(ALLEEG, EEGTMP' newset_param ');' ... 
        '  if ~isempty(tmpcom),' ...
        '     eegh(tmpcom); ' ...
        '     eeglab(''redraw''); ' ...
        '  end; ' ...
        'end; ' ...
        'clear EEGTMP tmpcom TMPREJ TMPREJCHN LASTCOM1 LASTCOM2;' ];
end;

if EEG.trials > 1
    if icacomp == 1 
                    macrorej  = 'EEG.reject.rejmanual';
        			macrorejE = 'EEG.reject.rejmanualE';
    else			macrorej  = 'EEG.reject.icarejmanual';
        			macrorejE = 'EEG.reject.icarejmanualE';
    end;
    colrej = EEG.reject.rejmanualcol;
	rej  = eval(macrorej);
	rejE = eval(macrorejE);
	
	% ---------- begin of modified eeg_rejmacro ----------
    % script macro for generating command and old rejection arrays
    
    if ~exist('nbpnts','var');
        nbpnts = EEG.pnts;
    end;
    
    % mix all type of rejections
    if icacomp
        nChan = EEG.nbchan;
    else
        nChan = size(EEG.icaweights,1);
    end
    if superpose == 2
        com2 = ['if ~isempty(TMPREJ), ' ...
            '  icaprefix = ' fastif(icacomp, '''''', '''ica''') ';' ...
            '  for indextmp = 1:length(EEG.reject.disprej),' ...
            '     eval([ ''colortmp = EEG.reject.rej'' EEG.reject.disprej{indextmp} ''col;'' ]);' ...
            '     [tmprej tmprejE] = eegplot2trial(TMPREJ,' int2str(nbpnts) ', EEG.trials, colortmp, []);' ...
            '     if ~isempty(tmprejE),' ...
            '          tmprejE2 = zeros(' int2str(nChan) ', length(tmprej));' ...
            '          tmprejE2([' int2str(elecrange) '],:) = tmprejE;' ...
            '     else ' ...
            '          tmprejE2 = [];' ...
            '     end;' ...
            '     eval([ ''EEG.reject.'' icaprefix ''rej'' EEG.reject.disprej{indextmp} ''= tmprej;'' ]);' ...
            '     eval([ ''EEG.reject.'' icaprefix ''rej'' EEG.reject.disprej{indextmp} ''E = tmprejE2;'' ]);' ...
            '  end;' ];
    else
        com2 = [ 'if ~isempty(TMPREJ),' ...
            '  icaprefix = ' fastif(icacomp, '''''', '''ica''') ';' ...
            '  [tmprej tmprejE] = eegplot2trial(TMPREJ,' int2str(nbpnts) ', EEG.trials, [' num2str(colrej) '], []);' ...
            '  if ~isempty(tmprejE),' ...
            '     tmprejE2 = zeros(' int2str(nChan) ', length(tmprej));' ...
            '     tmprejE2([' int2str(elecrange) '],:) = tmprejE;' ...
            '  else ' ...
            '     tmprejE2 = [];' ...
            '  end;' ...
            macrorej '= tmprej;' macrorejE '= tmprejE2;' ...
            ... % below are manual rejections
            '  tmpstr = [ ''EEG.reject.'' icaprefix ''rejmanual'' ];' ...
            '  if ~isempty(tmprej) eval([ ''if ~isempty('' tmpstr ''),'' tmpstr ''='' tmpstr ''| tmprej; else '' tmpstr ''=tmprej; end;'' ]); end; ' ...
            '  if ~isempty(tmprejE2) eval([ ''if ~isempty('' tmpstr ''E),'' tmpstr ''E='' tmpstr ''E| tmprejE2; else '' tmpstr ''E=tmprejE2; end;'' ]); end; ' ];
    end;
    
    if reject
        com_ = [ com1 com2 com3 'else LASTCOM2='''' ; end; ' com4 ];
    else
        com_ = [ com2 ...
            ' warndlg2(strvcat(''Epochs (=trials) marked for rejection have been noted.'',' ...
            '''To actually reject these epochs, use '', ''Tools > Reject data epochs > Reject marked epochs''), ''Warning'');' ...
            '[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); eeglab(''redraw''); end;' ];
    end;
    
    % the first part is used to convert the eegplot_w output
    command = [  com_ topcommand 'clear indextmp colortmp icaprefix tmpcom tmprej tmprejE tmprejE2 TMPREJ;' ];
    
    if all(colrej == EEG.reject.rejmanualcol)
        oldrej = [];  % for manual rejection, old rejection are
        oldrejE = []; % the current rejection
    else
        oldrej  = eval(macrorej);
        oldrejE = eval(macrorejE);
    end;
    
    switch superpose
        case 0
            rejeegplot = trial2eegplot(  rej, rejE, nbpnts, colrej);
        case 1
            rejeegplottmp = trial2eegplot(  oldrej, oldrejE, nbpnts, min(colrej+0.15, [1 1 1]));
            if ~isempty(rejeegplottmp) 
                rejeegplot = [ rejeegplottmp ];
            else
                rejeegplot = [];
            end;
            rejeegplottmp = trial2eegplot(  rej, rejE, nbpnts, colrej);
            if ~isempty(rejeegplottmp)
                rejeegplot = [ rejeegplot; rejeegplottmp ];
            end;
        case 2
            rejeegplot = [];
            for index = 1:length(EEG.reject.disprej)
                if ~isempty(EEG.reject.disprej{index})
                    eval([ 'colortmp = EEG.reject.rej' EEG.reject.disprej{index} 'col;']);
                    if any(colortmp ~= colrej) % test if current rejection (if color different)
                        if icacomp == 0 % ica
                            currentname = [ 'EEG.reject.icarej' EEG.reject.disprej{index} ];
                        else
                            currentname = [ 'EEG.reject.rej' EEG.reject.disprej{index} ];
                        end;
                        currentcolor =  [ 'EEG.reject.rej' EEG.reject.disprej{index} 'col' ];
                        eval( [ 'rejeegplottmp = trial2eegplot( ' currentname ',' currentname ...
                            'E, nbpnts,' currentcolor ');' ]);
                        if ~isempty(rejeegplottmp), rejeegplot = [ rejeegplot; rejeegplottmp ]; end;
                    end;
                end;
            end;
            rejeegplottmp = trial2eegplot(  rej, rejE, nbpnts, colrej);
            if ~isempty(rejeegplottmp)
                rejeegplot = [ rejeegplot; rejeegplottmp ];
            end;
    end;
    if ~isempty(rejeegplot)
        rejeegplot = rejeegplot(:,[1:5,elecrange+5]);
    else
        rejeegplot = [];
    end;
    eegplotoptions = { 'events', EEG.event, 'winlength', 5, 'winrej', ...
        rejeegplot, 'xgrid', 'off', 'wincolor', EEG.reject.rejmanualcol, ...
        'colmodif', { { EEG.reject.rejmanualcol EEG.reject.rejthreshcol EEG.reject.rejconstcol ...
        EEG.reject.rejjpcol     EEG.reject.rejkurtcol   EEG.reject.rejfreqcol } } };
    
    if ~reject
        eegplotoptions = { eegplotoptions{:}  'butlabel', 'UPDATE MARKS' };
    end;

    % ---------- end of modified eeg_rejmacro ----------
    
else % case of a single trial (continuous data)
    eeglab_options; % changed from eeglaboptions 3/30/02 -sm
    if reject == 0, command = '';
    else
        command = [com1 com3 com4 ];
        
        if nargin < 4
            res = questdlg2( strvcat('Mark stretches of continuous data for rejection', ...
                                     'by dragging the left mouse button. Click on marked', ...
                                     'stretches to unmark. When done,press "REJECT" to', ...
                                     'excise marked stretches (Note: Leaves rejection', ...
                                     'boundary markers in the event table).'), 'Warning', 'Cancel', 'Continue', 'Continue');
            if strcmpi(res, 'Cancel'), return; end;
        end;
    end;
    eegplotoptions = { 'events', EEG.event };
end;

if ~isempty(EEG.chanlocs) && icacomp == 1
    eegplotoptions = { eegplotoptions{:}  'eloc_file', EEG.chanlocs(elecrange) };
else
    if ~icacomp 
        try gcompreject=EEG.reject.gcompreject;
        catch
            gcompreject=zeros(1,size(EEG.icaweights,1));
        end;
        tmpstruct=struct('badchan',num2cell(gcompreject));
    end;
    for index = 1:length(elecrange)
        tmpstruct(index).labels = int2str(elecrange(index));
    end;
    if exist('tmpstruct','var')
        eegplotoptions = { eegplotoptions{:}  'eloc_file' tmpstruct };
    end;
end;

if EEG.nbchan > 100
    disp('pop_eegplot_w() note: Baseline subtraction disabled to speed up display');
    eegplotoptions = { eegplotoptions{:} 'submean' 'off' };
end;

if icacomp == 1
	eegplot_w( EEG.data, 'srate', EEG.srate, 'title', [ 'Scroll channel activities -- eegplot_w(): ' EEG.setname], ...
			  'limits', [EEG.xmin EEG.xmax]*1000 , 'command', command, eegplotoptions{:}, varargin{:});
else
    tmpdata = eeg_getdatact(EEG, 'component', [1:size(EEG.icaweights,1)]);
	eegplot_w( tmpdata, 'srate', EEG.srate, 'title', [ 'Scroll component activities -- eegplot_w(): ' EEG.setname], ...
			 'limits', [EEG.xmin EEG.xmax]*1000 , 'command', command, eegplotoptions{:}, varargin{:});
end;
com = [ com sprintf('pop_eegplot_w( %s, %d, %d, %d);', inputname(1), icacomp, superpose, reject) ];
return;
