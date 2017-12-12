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
shift_range=linspace(0.003,0.0009,10);
sigma=0.00042; %Sigma at 200hz, sigma is proportional to the sqrt of bandwidth, Vn=sqrt(4kT*Bw*R)
over_samp = 2;
%Assume the RF on time is 1 second, then the code length decides the clock frequency
RF_ontime = 0.04;
target_falsewkup = 0.5; %Number of false wkup in an hour
target_misswkup = 0.02; 
target_pfp = 0.01;
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
ones_count_Q0 = 21;
Q0(Vtrip,Vtrip_num,sigma,shift,over_samp,RF_ontime,code_length_Q0,ones_count_Q0,err_tol_mode,err_tol,err_tol_fp,err_tol_fn);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q0: Plot the 1)Vtrip vs CDF, 2)Vtrip vs Pfn,Pfp, 3)Vtrip vs false wkup rate
%4) Vtrip vs miss detection rate with given code_length, ones, err_tol_mode, err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q1: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q1(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Q1b(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
Q2(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
Q2b(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3: The Minimal shift that satisfies the target false wkup per hour and
%missing detection rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Q3(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);


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

[shift_min_Q4,Vtrip_shift_min_Q4] = Q4(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

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
