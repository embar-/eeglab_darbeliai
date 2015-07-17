% eeg_ikelk - duomenų įkėlimas EEGLAB struktūros pavidalu kone iš bet kokios vienos EEG rinkmenos 
% [EEG]=eeg_ikelk(kelias,rinkmena)

function [EEG]=eeg_ikelk(Kelias, Rinkmena)

    try % Importuoti kaip EEGLAB *.set
        EEG = pop_loadset('filename',Rinkmena,'filepath',Kelias);
    catch 
        Kelias_ir_rinkmena=fullfile(Kelias, Rinkmena);
        % Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
        fprintf('\n%s\n%s...\n', Kelias_ir_rinkmena, lokaliz('ne EEGLAB rinkmena'));
        try % Importuoti per BIOSIG
            EEG=pop_biosig(Kelias_ir_rinkmena);
            EEG=eegh( ['pop_biosig(' Kelias_ir_rinkmena ')' ], EEG);
        catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
            fprintf('%s...\n', lokaliz('BIOSIG negali nuskaityti'));
            try % Importuoti per FILEIO
                EEG=pop_fileio(Kelias_ir_rinkmena);
                EEG=eegh( ['pop_fileio(' Kelias_ir_rinkmena ')' ], EEG);
            catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                fprintf('%s...\n', lokaliz('FILEIO negali nuskaityti'));
                try % Įkelti tiesiogiai į MATLAB
                    load(Kelias_ir_rinkmena,'-mat');
                catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                    fprintf('%s...\n', lokaliz('MATLAB negali nuskaityti'));
                    try % Bent tuščią EEGLAB EEG struktūrą pasiūlyti
                        [~, EEG] = pop_newset([],[],[]);
                    catch %; Pranesk_apie_klaida(lasterr, mfilename, Kelias_ir_rinkmena, 0);
                        % Belieka tuščią grąžinti...
                        EEG=[];
                    end;
                end;
            end;
        end;
    end;
    
    