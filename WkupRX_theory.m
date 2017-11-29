%Version: V0.5
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
%       gives the min shift.
%       To do: 1) fix the code length and explore the other knobs that
%       gives the min shift. 2) For each code bit, use a statistical method
%       of N sub-bits to justify if it's a 0 or 1, and then use the current
%       analysis. 3) Compare the prob of miss dectection between double the
%       RF ontime for two detections and double the time for each bit
%The time domain equation at the output of RFFE is V(t)=Vrf(t)+Vn(t). The
%motivation of wkup rx is to reduce the RF input power (Increase sensitivity).
shift=0.0018; %The shift value is the central of gaussian distribution with RF signal, which is decided by the RF power and amplifier gain
% shift=0.0036; %-77dbm
shift_range=linspace(0.002,0.0009,10);
sigma=0.00042; %Sigma at 200hz, sigma is proportional to the sqrt of bandwidth, Vn=sqrt(4kT*Bw*R)
over_samp = 2;
%Assume the RF on time is 1 second, then the code length decides the clock frequency
RF_ontime = 0.04;
target_falsewkup = 0.5; %Number of false wkup in an hour
target_misswkup = 0.02; 
%err_tol_mode = 1 is the mode doesn't differentiate fn and fp,
%err_tol_mode = 0 is the mode defines fn and fp separately
err_tol_mode = 1;
err_tol = 0;
err_tol_fn = 0;
err_tol_fp = err_tol - err_tol_fn;
code_length_min = 4;
code_length_max = 33;
code_weight = 0.7;
close all
%[length, number of '1's, bandwidth, variance]
% code_8_4 = [8,4,8*2/RF_ontime,sqrt(8*2/RF_ontime/200)*sigma]; % 8 bit code with 4 '1's, assume baseband have 2x oversampling
code_8_4 = [8,4,4/RF_ontime,sqrt(4/RF_ontime/200)*sigma];
%Vtrip
Vtrip_num = 64;
Vtrip = linspace(-0.001,0.003,Vtrip_num);
code_8_4_pfp = 1 - Calc_CDF(Vtrip, code_8_4(4), 0);
code_8_4_pfn = Calc_CDF(Vtrip, code_8_4(4), shift);
figure
plot(Vtrip,code_8_4_pfp);
hold on;
plot(Vtrip,code_8_4_pfn);
legend('False positvie prob','False negative prob');
xlabel('Vtrip(V)');
ylabel('Probability');
code_8_4_falsewkup = Calc_Falsewkup(code_8_4(1),code_8_4(2),code_8_4(3)*over_samp,code_8_4_pfp,err_tol_mode,err_tol,err_tol_fp,err_tol_fn);
figure
semilogy(Vtrip,code_8_4_falsewkup);
code_8_4_misswkup = Calc_Misswkup(code_8_4(1),code_8_4(2),code_8_4_pfp,code_8_4_pfn,err_tol_mode,err_tol,err_tol_fp,err_tol_fn);
xlabel('Vtrip(V)');
ylabel('False wkup in an hour');
figure
semilogy(Vtrip,code_8_4_misswkup);
xlabel('Vtrip(V)');
ylabel('Probability of missing detection');

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
%Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power

Q4(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q5: The effect of err tolerance (err_mode = 1 and err_mode = 0) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
code_length_Q5 = 15;
shift_min_Q5_15 = Q5(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_Q5);

code_length_Q5 = 8;
shift_min_Q5_8 = Q5(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_Q5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q5: The effect of err tolerance (err_mode = 1 and err_mode = 0) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%