%Version: V0.6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       V0.1: a) Change the the relation between RF_ontime and BW to
%       BW=ones/RF_ontime. b) Differentiate the RF BW and digital BW,only  the
%       latter is related to oversampling
%       V0.2: a) Updated Calc_Falsewkup with considering tolerating false
%       negatives(Effect is small). b) Add err_tol_mode to differentiate
%       false postive and false negative error tolerance
%       V0.3: Change to log scale figures
%       V0.4: Add two surf figures with shift represents the color
%       V0.5: Reconfigured the code
%       V0.6: Add fix code length analysis and sweep the err_tol
%       gives the min shift.
%       V0.7: a) Update bruteforce sweeping on code_length, ones_count, err_tol, err_tol_fn, err_tol_fp in
%       V0.8: a) Fix a bug in Q3 to Q7 for sweeping the Vtrip when all the
%       Vtrips satisfy the false wake-up rate criterial.
%       V0.9: a) Added Q8 a, b ,c, which are the minimal shift value with
%       fixed false postive rate.
%The time domain equation at the output of RFFE is V(t)=Vrf(t)+Vn(t). The
%motivation of wkup rx is to reduce the RF input power (Increase sensitivity).
shift=0.0018; %The shift value is the central of gaussian distribution with RF signal, which is decided by the RF power and amplifier gain
% shift=0.0036; %-77dbm
% shift_range=10.^linspace(-2,-3,100);
shift_range=linspace(0.009,0.0009,100);
sigma=0.00042; %Sigma at 200hz, sigma is proportional to the sqrt of bandwidth, Vn=sqrt(4kT*Bw*R)
over_samp = 2;
%Assume the RF on time is 1 second, then the code length decides the clock frequency
RF_ontime = 0.02;
target_falsewkup = 0.5; %Number of false wkup in an hour
target_misswkup = 0.02; 
target_pfp = 0.01;
target_Vtrip_i = 32;
%err_tol_mode = 1 is the mode doesn't differentiate fn and fp,
%err_tol_mode = 0 is the mode defines fn and fp separately
err_tol_mode = 1;
err_tol = 0;
err_tol_fn = 0;
err_tol_fp = err_tol - err_tol_fn;
code_length_min = 4;
code_length_max = 33;
code_weight = 0.7;
%Vtrip
Vtrip_num = 64;
Vtrip = linspace(-0.001,0.003,Vtrip_num);

close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q0: Plot the 1)Vtrip vs CDF, 2)Vtrip vs Pfn,Pfp, 3)Vtrip vs false wkup rate
%4) Vtrip vs miss detection rate with given code_length, ones, err_tol_mode, err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code_length_Q0 = 31;
ones_count_Q0 = 8;
err_tol_Q0 = 4;
[FWU_31_8_4_conv,MD_31_8_4_conv]=Q0(Vtrip,Vtrip_num,sigma,shift,over_samp,RF_ontime,code_length_Q0,ones_count_Q0,err_tol_mode,err_tol_Q0,err_tol_fp,err_tol_fn);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q0: Plot the 1)Vtrip vs CDF, 2)Vtrip vs Pfn,Pfp, 3)Vtrip vs false wkup rate
%4) Vtrip vs miss detection rate with given code_length, ones, err_tol_mode, err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q1: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q1(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Q1b(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
% Q2(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
% Q2b(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3: The Minimal shift that satisfies the target false wkup per hour and
%missing detection rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shift_min_Q3=Q3(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q3: The Minimal shift that satisfies the target false wkup per hour and
%missing detection rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3b: Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shift_min_Q3b=Q3b(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q3b: Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3c: Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shift_min_Q3c=Q3c(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q3c: Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power

% [shift_min_Q4,Vtrip_shift_min_Q4] = Q4(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q5: The effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
code_length_Q5 = 15;
shift_min_Q5_15 = Q5(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_Q5);

code_length_Q5 = 8;
shift_min_Q5_8 = Q5(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_Q5);

code_length_Q5 = 31;
shift_min_Q5_31 = Q5(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_Q5);

shift_range_xband=linspace(10^-4,1*10^-5,20);
Vtrip_xband = linspace(-0.0001,0.0003,Vtrip_num);
sigma_xband = 2*10^(-5);
RF_ontime_xband = 0.08;
target_falsewkup_xband = 1;
target_misswkup_xband = linspace(0.05,0.85,5);
code_pfp = 1 - Calc_CDF(Vtrip_xband, sigma_xband, 0);
false_wkup = code_pfp * 100 * 3600*over_samp;
Vtrip_i = Vtrip_num - sum(false_wkup < target_falsewkup_xband)+1;
code_pfn = Calc_CDF(Vtrip_xband(Vtrip_i), sigma_xband, shift_range_xband);
for i = (1:5)
% code_length_Q5 = 15;
% shift_min_Q5_15_xband(i,1) = 1-target_misswkup_xband(i);
% shift_min_Q5_15_xband(i,2) = min(min(Q5(Vtrip_xband,Vtrip_num,shift_range_xband,sigma_xband,over_samp,RF_ontime_xband,target_falsewkup_xband,target_misswkup_xband(i),err_tol_fn,err_tol_fp,code_length_Q5)));
% 
% code_length_Q5 = 8;
% shift_min_Q5_8_xband(i,1) = 1-target_misswkup_xband(i);
% shift_min_Q5_8_xband(i,2) = min(min(Q5(Vtrip_xband,Vtrip_num,shift_range_xband,sigma_xband,over_samp,RF_ontime_xband,target_falsewkup_xband,target_misswkup_xband(i),err_tol_fn,err_tol_fp,code_length_Q5)));
% 
% code_length_Q5 = 31;
% shift_min_Q5_31_xband(i,1) = 1-target_misswkup_xband(i);
% shift_min_Q5_31_xband(i,2) = min(min(Q5(Vtrip_xband,Vtrip_num,shift_range_xband,sigma_xband,over_samp,RF_ontime_xband,target_falsewkup_xband,target_misswkup_xband(i),err_tol_fn,err_tol_fp,code_length_Q5)));


% shift_min_Q5_1_xband_i = sum((1 - code_pfn) > (1 - target_misswkup_xband(i)));
% shift_min_Q5_1_xband(i,1) = 1-target_misswkup_xband(i);
% shift_min_Q5_1_xband(i,2) = shift_range_xband(shift_min_Q5_1_xband_i);

code_length_Q5 = 63;
shift_min_Q5_63_xband(i,1) = 1-target_misswkup_xband(i);
shift_min_Q5_63_xband(i,2) = min(min(Q5(Vtrip_xband,Vtrip_num,shift_range_xband,sigma_xband,over_samp,RF_ontime_xband,target_falsewkup_xband,target_misswkup_xband(i),err_tol_fn,err_tol_fp,code_length_Q5)));

end

figure
plot(20*log10(shift_min_Q5_1_xband(:,2)/sigma_xband),shift_min_Q5_1_xband(:,1),'-o','LineWidth',2,'MarkerSize',10);
hold on
plot(20*log10(shift_min_Q5_8_xband(:,2)/sigma_xband),shift_min_Q5_8_xband(:,1),'-s','LineWidth',2,'MarkerSize',10);
hold on
plot(20*log10(shift_min_Q5_15_xband(:,2)/sigma_xband),shift_min_Q5_15_xband(:,1),'-d','LineWidth',2,'MarkerSize',10);
hold on
plot(20*log10(shift_min_Q5_31_xband(:,2)/sigma_xband),shift_min_Q5_31_xband(:,1),'-^','LineWidth',2,'MarkerSize',10);
hold on
plot(20*log10(shift_min_Q5_63_xband(:,2)/sigma_xband),shift_min_Q5_63_xband(:,1),'-^','LineWidth',2,'MarkerSize',10);
xlabel('SNR(dB)','fontsize',20,'FontWeight','bold');
ylabel({'Probability of detection'},'fontsize',20,'FontWeight','bold');
legend({'1 bit code','8 bit code','15 bit code','31 bit code','63 bit code'},'fontsize',16,'FontWeight','bold');
set(gca,'FontWeight','bold','fontsize',16');
grid on
title({['Probability of detection as a function of'];...
    ['SNR(dB) at false alarm rate < 1 per hour'];...
    ['for different wake-up code length ']});



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q5: The effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q5b: The effect of err tolerance (err_mode = 0) with fixed
%code length on minimal sensitivity (shift). Loop between the number of
%err_tol_fn and err_tol_fn in a certain err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code_length_Q5b = 8;
shift_min_Q5b_8 = Q5b(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_Q5b);

code_length_Q5b = 15;
shift_min_Q5b_15 = Q5b(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_Q5b);

code_length_Q5b = 31;
shift_min_Q5b_31 = Q5b(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_Q5b);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q5b: The effect of err tolerance (err_mode = 0) with fixed
%code length on minimal sensitivity (shift). Loop between the number of
%err_tol_fn and err_tol_fn in a certain err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q6: For each code bit, use a statistical method of N sub-bits to justify
%if it's a 0 or 1, then use the regular analysis to calcualte
%the effect of err tolerance (err_mode = 1) with fixed code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code_length_Q6 = 15;
% div_factor=3;
% Q6(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_Q6,div_factor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q6: For each code bit, use a statistical method of N sub-bits to justify
%if it's a 0 or 1, then use the regular analysis to calcualte
%the effect of err tolerance (err_mode = 1) with fixed code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q7: Divide the RF_ontinme to N repetition of wkup codes, and the missing detection 
%rate is the prob of missing all N repetition. The effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code_length_Q7 = 15;
% rep_factor=1;
% Q7(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length,rep_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q8: The Minimal shift with the targeted false postive rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[shift_min_Q8,Vtrip_shift_min_Q8]=Q8(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_pfp,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q8: The Minimal shift with the targeted false postive rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q8b: With targeted false postive rate, Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[shift_min_Q8b,Vtrip_shift_min_Q8b]=Q8b(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_pfp,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q8b: With targeted false postive rate, Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q8c:  With targeted false postive rate, Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[shift_min_Q8c,Vtrip_shift_min_Q8c]=Q8c(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_pfp,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q8c:  With targeted false postive rate, Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q9: The Minimal shift with the targeted Vtrip voltage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[shift_min_Q9,Vtrip_shift_min_Q9]=Q9(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q9: The Minimal shift with the targeted Vtrip voltage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q9b: With targeted Vtrip voltage, Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[shift_min_Q9b,Vtrip_shift_min_Q9b]=Q9b(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q9b: With targeted Vtrip voltage, Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q9c:  With targeted trip voltage, Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[shift_min_Q9c,Vtrip_shift_min_Q9c]=Q9c(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,code_length_min,code_length_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q9c:  With targeted trip voltage, Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q10: With given Vtrip, the effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code_length_Q10 = 8;
shift_min_Q10=Q10(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,err_tol_fn,err_tol_fp,code_length_Q10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q10: With given Vtrip, the effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q10b: With given Vtrip, the effect of err tolerance (err_mode = 0) with fixed
%code length on minimal sensitivity (shift). Loop between the number of
%err_tol_fn and err_tol_fn in a certain err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code_length_Q10b = 8;
[shift_min_Q10b_fn,shift_min_Q10b_fp]=Q10b(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,code_length_Q10b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q10b: With given Vtrip, the effect of err tolerance (err_mode = 0) with fixed
%code length on minimal sensitivity (shift). Loop between the number of
%err_tol_fn and err_tol_fn in a certain err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
