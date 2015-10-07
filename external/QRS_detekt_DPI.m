function qrs=QRS_detekt_DPI(y,fs,sw,p)
%% This is the MATLAB code for extracting QRS from ECG signal.
% The details of the method is presented in  the paper entitled 
% "Threshold-Independent QRS Detection Using the Dynamic Plosion Index " 
% which has been accepted  for publication to IEEE SPL.
%
%
% The inputs for the code are:
% the ECG signal (y), 
% the samplimg frequency (fs), 
% the computation window in millisecond (sw)
% and the parameter (p).
%
% The typical values for sw and p are 1800 and 5 respectively.
%
% It outputs the R-peak locations in samples.
%
%  author = " A. G. Ramakrishnan and A. P. Prathosh and T. V. Ananthapadmanabhaha",
%  title = "Threshold-Independent {QRS} Detection Using the Dynamic Plosion Index",
%  journal = "IEEE {S}ignal {P}rocessing {L}etters, accepted for publication",
%  year = "2014" 
%
%  ramkiag@ee.iisc.ernet.in 
%
% Apache Licence 2.0
%
% original filename: dpi_qrs.m
% downloaded from:
% http://mile.ee.iisc.ernet.in/QRS/
%
% Modifications by Mindaugas Baranauskas 2015:
% Avoid crash in epoch_lpr_ec, if gcim1+ms20 exceeds size of y and sig.

if size(y,1) == 1
    
    y=y';
    
end

if mod(length(y),2) ~= 0
    
    y=y(1:end-1);
    
end

sig=y;

freq_res= fs/length(y);
nn1= floor(8/freq_res);
h1= 0.5-0.5*cos(pi.*(1:nn1)/(nn1));
h2= ones( 1, floor(length(y)/2)-length(h1));
h3= [ h1 h2];
if exist('wrev.m','file');
    h4= wrev(h3);
else
    h4= wrev_octave(h3);
end;
h5= [ h3 h4];
h5=h5.^4;
g3= fft(y);
sig_hp1= h5' .* g3;
sig_hp1 = ifft (sig_hp1);
y= real(sig_hp1);
qrs=dpi_ecg(y,sig,fs,sw,p);

function [gci]= dpi_ecg(y,sig,fs,sw,f)

global ms ff_op ms20 ms15 ms2

ms=(0.001*fs);
ms2 =floor(285*ms);
ms20=floor((sw+320)*ms);
ms15=floor(sw*ms);
ff_op= ff_mat(ms15,f);
[gci]=epoch_lpr_ec(y,sig,fs);

return;

function [ffm]= ff_mat(siz1,f)


l1=(length(1:1+siz1));
ff_op=tril(ones(l1,l1));

w=(1:l1).^(1/f);

div=(ones(l1,l1)*(diag(w)))';

ffm=ff_op./div;

return;

function [gci]= epoch_lpr_ec(y,sig,fs)

clear gci

global ms ms2 ms20


start_point =ms2+3;
gci(1) = start_point;
gcic(1)=gci(1);
i=0;
m=2;
while i< length(y)-2000
    gcim1= gci(m-1);
    idx=[max(1,gcim1-ms2):min(length(sig),gcim1+ms20)];
    yh= y(idx);
    y2= sig(idx);
    y2=hpf(y2,4,fs);
    pos= yh>=0;
    yh1=((1*yh.*pos))';
    yh1(length(yh1)-2:length(yh1))= [-.001 0 0.001];
    [gcix,fff1]= gci_next_fast1(yh1,y2);
    gci(m)= floor(gcix+gcim1-ms2);
    gci(m) = (abs(gci(m)-gcim1)<ms2)*200+ gci(m);
    i=gci(m);
    m=m+1;
    
end

return;

function [gci_n,fff1] = gci_next_fast1(yh,yh1)


global ms ff_op fs pre ms2 ms20 ms15 ms1


[~, plc1]= max(yh(10:ms2));


le=10+plc1-2;

fff= 1./(ff_op * (yh(le:le+ms15))');


l=length(fff);

if ~isempty(which('smooth'));
    fff1=smooth(fff);
else
    fff1=smooth2(fff);
end;

fff(1:length(fff)-2)= fff1(3:length(fff));

fff(l:l+8)=fff(l-1);

der=-1*(fff(5:length(fff))-fff(1:length(fff)-4))';
der=[der zeros(1,length(fff)-length(der))];

der(l:l+8)= [ -0.001, 0.001, 0.001, 0 , 0,0,0,0,0];


[indn indp]= zcfast(der(ms2:length(der)-5),0);



indp=indp+ms2;

indn=indn+ms2;

if indp(1) < indn(1)
    
    indp=indp(2:length(indp));
    
end;
for q=1:min(length(indp),length(indn))
    
    [val1 indm]= max(fff(indn(q)-4:indn(q)+4)) ;
    
    indm= indn(q)-4+indm-1;
    
    
    [val2 indmi]= min(fff(indp(q)-4:indp(q)+4)) ;
    
    indmi= indp(q)-4+indmi-1;
    
    swing(q) = val1-val2;
    
    loca(q) = indm;
    
    locb(q)=indmi;
    
end;


[s, uu]= max(swing);
gci_n= locb(uu) +le-2;


[d loc] = max(abs((yh1(gci_n-ms2:gci_n+ms2))));
%
gci_n= gci_n-ms2+loc-1;

return;

function [indn,indp]=zcfast(der,th)
l=length(der);

pos= (1:length(der)-1);
d=der(1:l-1).*der(2:l)<=0 ;
p=der>th;
n=der<-th;
p=p(1:l-1);
n=n(1:l-1);
indp=d.*p.*pos;
indn=d.*n.*pos;

pp= indp>0;
pn=indn>0;

indp1= (sort(indp,'descend'));

indn1= (sort(indn,'descend'));

if exist('wrev.m','file');
    indp = wrev(indp1((1:sum(pp))));
    indn = wrev(indn1((1:sum(pn))));
else
    indp = wrev_octave(indp1((1:sum(pp))));
    indn = wrev_octave(indn1((1:sum(pn))));
end;

return;

function [locs vals]= nonzero(a)

loca=1:length(a);
ff_loc1= loca.* (a>0);

pp=sort(ff_loc1);

locs= pp(length(pp)-(sum(pp>0))+1:length(pp));


vals= a(locs);

return;

function yh = hpf(y,cf,fs)

if mod(length(y),2) ~= 0
    
    y=y(1:end-1);
    
end

freq_res= fs/length(y);

    nn1= floor(cf/freq_res);
    
    
    %nn2= floor(50/freq_res);
    
    h1= 0.5-0.5*cos(pi.*(1:nn1)/(nn1));
    
%     h11=0.5+0.5*cos(pi.*(1:nn2)/(nn2));
%     
%     h1=[h1 h11];

    h2= ones( 1, floor(length(y)/2)-length(h1));
    h3= [ h1 h2];
    if exist('wrev.m','file');
        h4= wrev(h3);
    else
        h4= wrev_octave(h3);
    end;
    h5= [ h3 h4];
    
   h5=h5.^4;

    g3= fft(y);
    
    
    sig_hp1= h5' .* g3;
    sig_hp1 = ifft (sig_hp1);
    yh= real(sig_hp1);
return;

