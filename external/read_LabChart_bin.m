function LabChart_data=read_LabChart_bin(LabChart_file)
% LabChart_data=read_LabChart_bin(LabChart_file)
% read binary LabChart format *.adibin
% 
% This code grabed from http://forum.adinstruments.com/viewtopic.php?f=7&t=395#p960
% 
% Authors: 
% * maba76
% * Kit Adams Ph.D, Chief Architect Windows, ADInstruments, New Zealand
%
% See documentation:
% http://cdn.adinstruments.com/adi-web/manuals/translatebinary/LabChartBinaryFormat.pdf

LabChart_data={};

fid2 = fopen(LabChart_file);
LabChart_data.magic=fread(fid2, 4, '*char'); % description
LabChart_data.Version=fread(fid2, 1, 'long'); % version
LabChart_data.secPerTick=fread(fid2, 1, 'double'); %sample period
LabChart_data.Year=fread(fid2, 1 , 'long'); % year
LabChart_data.Month=fread(fid2, 1, 'long'); %month
LabChart_data.Day=fread(fid2, 1, 'long'); %day
LabChart_data.Hour=fread(fid2, 1, 'long'); %hour
LabChart_data.Minute=fread(fid2, 1, 'long'); %minute
LabChart_data.Seconds=fread(fid2, 1, 'double'); %seconds
LabChart_data.trigger=fread(fid2, 1, 'double'); %pre trigger
LabChart_data.NChannels=fread(fid2, 1, 'long'); %number of channels
LabChart_data.SamplesPerChannel=fread(fid2, 1, 'long'); %samples per channels
LabChart_data.TimeChannel=fread(fid2, 1, 'long'); %time channel included
LabChart_data.DataFormat=fread(fid2, 1, 'long'); %data format

% channel headers
LabChart_data.Title1=fread(fid2,32,'*char');
LabChart_data.Units1=fread(fid2,32,'*char');
LabChart_data.scale1=fread(fid2,1,'double');
LabChart_data.offset1=fread(fid2,1,'double');
LabChart_data.RangeHigh1=fread(fid2,1,'double');
LabChart_data.RangeLow1=fread(fid2,1,'double');

LabChart_data.Title2=fread(fid2,32,'*char');
LabChart_data.Units2=fread(fid2,32,'*char');
LabChart_data.scale2=fread(fid2,1,'double');
LabChart_data.offset2=fread(fid2,1,'double');
LabChart_data.RangeHigh2=fread(fid2,1,'double');
LabChart_data.RangeLow2=fread(fid2,1,'double');

LabChart_data.Title3=fread(fid2,32,'*char');
LabChart_data.Units3=fread(fid2,32,'*char');
LabChart_data.scale3=fread(fid2,1,'double');
LabChart_data.offset3=fread(fid2,1,'double');
LabChart_data.RangeHigh3=fread(fid2,1,'double');
LabChart_data.RangeLow3=fread(fid2,1,'double');

% read interleaved data
LabChart_data.nChan = LabChart_data.NChannels+LabChart_data.TimeChannel;
LabChart_data.Data = zeros(LabChart_data.nChan*LabChart_data.SamplesPerChannel,1);
LabChart_data.Data = fread(fid2,LabChart_data.nChan*LabChart_data.SamplesPerChannel,'float32');
fclose(fid2);

return;

%Deinterleave the channels and time column, if present
DataAsChans = reshape(LabChart_data.Data,LabChart_data.NChannels+LabChart_data.TimeChannel,LabChart_data.SamplesPerChannel).';
%plot the data
if LabChart_data.TimeChannel
plot(LabChart_data.DataAsChans(:,1),LabChart_data.DataAsChans(:,[2:LabChart_data.NChannels]))
else
plot(LabChart_data.DataAsChans(:,[1:LabChart_data.NChannels]))
end