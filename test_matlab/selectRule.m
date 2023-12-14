function ind=selectRule(s,fs,energyDecreasingBand)

n_t=length(s);
n_f=floor(n_t/2);
f=fs*(1:n_f)/(2*n_f);

[~,r_fMin_temp]=min(abs(f-energyDecreasingBand(1,1)));
[~,r_fMax_temp]=min(abs(f-energyDecreasingBand(1,2)));
r_fMin=r_fMin_temp(1,1);
r_fMax=r_fMax_temp(1,1);
r_fMedian=floor((r_fMin+r_fMax)/2);

S_temp=fft(s,n_t)/n_t;
S=S_temp(1:n_f);

S_left=sum(abs(S(r_fMin:r_fMedian)));
S_right=sum(abs(S(r_fMedian+1:r_fMax)));

if S_left>S_right
    ind=1;
else
    ind=0;
end
end