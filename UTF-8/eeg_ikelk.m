% eeg_ikelk - duomenų įkėlimas EEGLAB struktūros pavidalu kone iš bet
% kokios vienos EEG rinkmenos [EEG]=eeg_ikelk(kelias,rinkmena)

function [EEG]=eeg_ikelk(Kelias, Rinkmena, varargin)

persistent PAPILDINIAI_JAU_PATIKRINTI

try
    g=struct(varargin);
catch
    g=struct;
end;
tikrinti_papildinius=1;
if isfield(g,'tikrinti_papildinius');
    tikrinti_papildinius=g.tikrinti_papildinius;
end;

    [Kelias_,Rinkmena_]=rinkmenos_tikslinimas(Kelias,Rinkmena);
    try % Importuoti kaip EEGLAB *.set
        EEG = pop_loadset('filename',Rinkmena_,'filepath',Kelias_);
        ivykiai={EEG.event.type};
        if ~iscellstr(ivykiai);
            for i=1:length(ivykiai);
                try
                    EEG.event(i).type=str2num(EEG.event(i).type);
                catch
                end
            end;
        end;
    catch 
        Kelias_ir_rinkmena=fullfile(Kelias_, Rinkmena_);
        % Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
        fprintf('\n%s\n%s...\n', Kelias_ir_rinkmena, lokaliz('ne EEGLAB rinkmena'));
        try % Importuoti per BIOSIG
            fprintf('%s %s...\n', lokaliz('Trying again with'), 'BIOSIG');
            diary_bsn0=get(0,'Diary');
            if strcmp(diary_bsn0,'on'); diary_zrn0=get(0,'DiaryFile'); diary('off'); end;
            diary_zrn2=tempname; diary(diary_zrn2); diary('on');
            EEG=pop_biosig(Kelias_ir_rinkmena);
            diary('off');
            if strcmp(diary_bsn0,'on'); diary(diary_zrn0); diary(diary_bsn0); end;
            if isempty(EEG.data); 
                error(lokaliz('Empty dataset'));
            end;
            EEG=eegh( ['pop_biosig(' Kelias_ir_rinkmena ')' ], EEG);
        catch %klaida; Pranesk_apie_klaida(klaida, mfilename, Kelias_ir_rinkmena, 0);
            
            % BIOPAC AcqKnowledge *.ACQ
            diary('off');
            fprintf('%s...\n', lokaliz('BIOSIG negali nuskaityti'));
            diary_fid=fopen(diary_zrn2);
            diary_prn=fgets(diary_fid);
            if ~ischar(diary_prn); diary_prn=''; end;
            fclose(diary_fid);
            delete(diary_zrn2);
            if (exist(diary_zrn0,'file') == 2) && (~strcmp(diary_zrn0,'diary')); 
                diary(diary_zrn0);
            end;
            diary(diary_bsn0);
            if ~isempty(regexp(diary_prn,'ACQ format not supported'));
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'load_acq');
                try
                    acq = load_acq(Kelias_ir_rinkmena);
                    [~, EEG] = pop_newset([],[],[]);
                    EEG.data=acq.data';
                    EEG.srate=1000/double(acq.hdr.graph.sample_time);
                    EEG.trials=1;
                    EEG.pnts=size(EEG.data,2);
                    EEG.times=(EEG.pnts-1)*double(acq.hdr.graph.sample_time);
                    EEG.xmin=0;
                    EEG.xmax=EEG.times(end)/1000;
                    EEG.nbchan=acq.hdr.graph.num_channels;
                    EEG.chanlocs=struct('labels',{acq.hdr.per_chan_data.comment_text});
                    if ~isempty(acq.markers.szText);
                        tipai=regexprep(acq.markers.szText,'^Segment .*','boundary');                        
                        ltncj=num2cell(acq.markers.lSample+1);
                        EEG.event=struct('type',tipai,'latency',ltncj,'duration',0);
                    end;
                    return;
                catch %klaida; Pranesk_apie_klaida(klaida, mfilename, Kelias_ir_rinkmena, 0);
                    fprintf('\n%s...\n', 'load_acq negali nuskaityti');
                end;
            end;
            
            [wrn_b]=warning('off','backtrace');
            try % Importuoti per FILEIO
                fprintf('%s %s...\n', lokaliz('Trying again with'), 'FILEIO');
                EEG=pop_fileio(Kelias_ir_rinkmena);
                EEG=eegh( ['pop_fileio(' Kelias_ir_rinkmena ')' ], EEG);
                % Sutvarkyti įvykių pavadinimus
                try tipai=regexprep({EEG.event.type},'[\0]*$','');
                    [EEG.event.type]=tipai{:};
                catch
                end;
            catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                fprintf('%s...\n', lokaliz('FILEIO negali nuskaityti'));
                try % Įkelti tiesiogiai į MATLAB
                    fprintf('%s %s...\n', lokaliz('Trying again with'), 'MATLAB');
                    load(Kelias_ir_rinkmena,'-mat');
                    EEG = eeg_checkset(EEG);
                catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                    fprintf('%s...\n', lokaliz('MATLAB negali nuskaityti'));
                    % Nurodyti galimai trūkstamus papildinius
                    if tikrinti_papildinius
                        if isempty(PAPILDINIAI_JAU_PATIKRINTI)
                            PAPILDINIAI_JAU_PATIKRINTI=1;
                            wrnmsg=[lokaliz('Ikelti nepavyko') drb_uzklausa('papildiniai')];
                            warning(sprintf('%s\n',wrnmsg{:}));
                            warndlg(wrnmsg,lokaliz('Duomenu ikelimas'));
                        else
                            warning(lokaliz('Ikelti nepavyko'));
                        end;
                    end;
                    try % Bent tuščią EEGLAB EEG struktūrą grąžinti
                        [~, EEG] = pop_newset([],[],[]);
                    catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                        % Belieka tuščią grąžinti...
                        EEG=[];
                    end;
                end;
            end;
            warning(wrn_b);
        end;
    end;
    
    