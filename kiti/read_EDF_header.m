function EDF_header=read_EDF_header(EDF_FAILAI)

tic;
disp(' ');
disp('EDF(+):')

EDF_header=struct;

for i=1:length(EDF_FAILAI);
    EDF_FAILAS=EDF_FAILAI{i};

        disp([ ' ' EDF_FAILAS ' ' ]);


        fid=fopen(EDF_FAILAS,'r','ieee-le');
        hdr=char(fread(fid,256,'uchar')');
        EDF_header(i).ver=str2num(hdr(1:8));            % 8 ascii : version of this data format (0)
        EDF_header(i).patientID  = char(hdr(9:88));     % 80 ascii : local patient identification
        EDF_header(i).recordID  = char(hdr(89:168));    % 80 ascii : local recording identification
        EDF_header(i).startdate=char(hdr(169:176));     % 8 ascii : startdate of recording (dd.mm.yy)
        EDF_header(i).starttime  = char(hdr(177:184));  % 8 ascii : starttime of recording (hh.mm.ss)
        EDF_header(i).length = str2num(hdr(185:192));  % 8 ascii : number of bytes in EDF_header(i) record
        EDF_header(i).reserved = hdr(193:236); % [EDF+C       ] % 44 ascii : reserved
        EDF_header(i).records = str2num(hdr(237:244)); % 8 ascii : number of data records (-1 if unknown)
        EDF_header(i).duration = str2num(hdr(245:252)); % 8 ascii : duration of a data record, in seconds
        EDF_header(i).channels = str2num(hdr(253:256));% 4 ascii : number of signals (ns) in data record

        EDF_header(i).labels=cellstr(char(fread(fid,[16,EDF_header(i).channels],'char')')); % ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp)
        EDF_header(i).transducer =cellstr(char(fread(fid,[80,EDF_header(i).channels],'char')')); % ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode)
        EDF_header(i).units = cellstr(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC)
        EDF_header(i).physmin = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical minimum (e.g. -500 or 34)
        EDF_header(i).physmax = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * physical maximum (e.g. 500 or 40)
        EDF_header(i).digmin = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * digital minimum (e.g. -2048)
        EDF_header(i).digmax = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * digital maximum (e.g. 2047)
        EDF_header(i).prefilt =cellstr(char(fread(fid,[80,EDF_header(i).channels],'char')')); % ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
        EDF_header(i).samplerate = str2num(char(fread(fid,[8,EDF_header(i).channels],'char')')); % ns * 8 ascii : ns * nr of samples in each data record

        fclose(fid);
    end;

    toc;