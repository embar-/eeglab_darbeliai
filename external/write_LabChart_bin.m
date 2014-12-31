function write_LabChart_bin(LabChart_file, LabChart_data)
% write_LabChart_bin(LabChart_file, LabChart_data)
% write binary file in LabChart format *.adibin
% 
% This code grabed from http://forum.adinstruments.com/viewtopic.php?f=7&t=395#p960
% 
% Authors: 
% * maba76
% * Kit Adams Ph.D, Chief Architect Windows, ADInstruments, New Zealand
%
% See documentation:
% http://cdn.adinstruments.com/adi-web/manuals/translatebinary/LabChartBinaryFormat.pdf

fid3 = fopen(LabChart_file,'w');
fwrite(fid3, LabChart_data.magic, '*char')
fwrite(fid3, LabChart_data.Version, 'long')
fwrite(fid3, LabChart_data.secPerTick, 'double')
fwrite(fid3, LabChart_data.Year, 'long')
fwrite(fid3, LabChart_data.Month, 'long')
fwrite(fid3, LabChart_data.Day, 'long')
fwrite(fid3, LabChart_data.Hour, 'long')
fwrite(fid3, LabChart_data.Minute, 'long')
fwrite(fid3, LabChart_data.Seconds, 'double')
fwrite(fid3, LabChart_data.trigger, 'double')
fwrite(fid3, LabChart_data.NChannels, 'long')
fwrite(fid3, LabChart_data.SamplesPerChannel, 'long')
fwrite(fid3, LabChart_data.TimeChannel, 'long')
fwrite(fid3, LabChart_data.DataFormat, 'long')

% channel headers
fwrite(fid3,LabChart_data.Title1,'*char');
fwrite(fid2,LabChart_data.Units1,'*char');
fwrite(fid3,LabChart_data.scale1,'double');
fwrite(fid3,LabChart_data.offset1,'double');
fwrite(fid3,LabChart_data.RangeHigh1,'double');
fwrite(fid3,LabChart_data.RangeLow1,'double');
fwrite(fid3,LabChart_data.Title2,'*char');
fwrite(fid2,LabChart_data.Units2,'*char');
fwrite(fid3,LabChart_data.scale2,'double');
fwrite(fid3,LabChart_data.offset2,'double');
fwrite(fid3,LabChart_data.RangeHigh2,'double');
fwrite(fid3,LabChart_data.RangeLow2,'double');
fwrite(fid3,LabChart_data.Title3,'*char');
fwrite(fid2,LabChart_data.Units3,'*char');
fwrite(fid3,LabChart_data.scale3,'double');
fwrite(fid3,LabChart_data.offset3,'double');
fwrite(fid3,LabChart_data.RangeHigh3,'double');
fwrite(fid3,LabChart_data.RangeLow3,'double');
% interleaved data
fwrite(fid3,LabChart_data.Data,'float32');
fclose(fid3);


return;

%Deinterleave the channels and time column, if present
DataAsChans = reshape(LabChart_data.Data,LabChart_data.NChannels+LabChart_data.TimeChannel,LabChart_data.SamplesPerChannel).';
%plot the data
if LabChart_data.TimeChannel
plot(LabChart_data.DataAsChans(:,1),LabChart_data.DataAsChans(:,[2:LabChart_data.NChannels]))
else
plot(LabChart_data.DataAsChans(:,[1:LabChart_data.NChannels]))
end