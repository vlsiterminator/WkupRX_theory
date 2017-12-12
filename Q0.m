%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q0: Plot the 1)Vtrip vs CDF, 2)Vtrip vs Pfn,Pfp, 3)Vtrip vs false wkup rate
%4) Vtrip vs miss detection rate with given code_length, ones, err_tol_mode, err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r=Q0(Vtrip,Vtrip_num,sigma,shift,over_samp,RF_ontime,code_length,ones_count,err_tol_mode,err_tol,err_tol_fp,err_tol_fn)


%[length, number of '1's, bandwidth, variance]
% code_8_4 = [8,4,8*2/RF_ontime,sqrt(8*2/RF_ontime/200)*sigma]; % 8 bit code with 4 '1's, assume baseband have 2x oversampling
% code = [code_length,4,4/RF_ontime,sqrt(4/RF_ontime/200)*sigma];
code_bandwidth_rf = ones_count/RF_ontime;
code_bandwidth_dig = code_bandwidth_rf*over_samp;
code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
code_pfn = Calc_CDF(Vtrip, code_sigma, shift);

figure
%Vtrip vs CDF
subplot(1,2,1);
plot(Vtrip, 1 - code_pfp);
hold on;
subplot(1,2,1);
plot(Vtrip,code_pfn);
if err_tol_mode == 1
    title({['CDF of RF front-end output voltage of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and ' num2str(err_tol) 'bits of error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
else
    title({['CDF of RF front-end output voltage of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and (' num2str(err_tol_fp) num2str(err_tol_fn) ') bits of (fp,fn) error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
end
legend('wo RF input signal','w RF inpout signal');
xlabel('RF front-end output (V)');
ylabel('CDF');
%Vtrip vs Pfn,Pfp
subplot(1,2,2);
plot(Vtrip,code_pfp);
hold on;
subplot(1,2,2);
plot(Vtrip,code_pfn);
if err_tol_mode == 1
    title({['Probability of false postive and negative of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and ' num2str(err_tol) 'bits of error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
else
    title({['Probability of false postive and negative of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and (' num2str(err_tol_fp) ',' num2str(err_tol_fn) ') bits of (fp,fn) error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
end
legend('False positvie prob','False negative prob');
xlabel('Vtrip(V)');
ylabel('Probability');

code_falsewkup=zeros(Vtrip_num);
code_misswkup=zeros(Vtrip_num);
for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
    code_falsewkup(Vtrip_i) = Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn);
    code_misswkup(Vtrip_i) = Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn);
end
figure
subplot(1,2,1);
semilogy(Vtrip,code_falsewkup);
if err_tol_mode == 1
    title({['Probability of false wake-up of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and ' num2str(err_tol) 'bits of error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
else
    title({['Probability of false wake-up of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and (' num2str(err_tol_fp) ',' num2str(err_tol_fn) ') bits of (fp,fn) error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
end
xlabel('Vtrip(V)');
ylabel('False wkup in an hour');
subplot(1,2,2);
semilogy(Vtrip,code_misswkup);
if err_tol_mode == 1
    title({['Probability of missing detection of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and ' num2str(err_tol) 'bits of error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
else
    title({['Probability of missing detection of ' num2str(code_length) 'bits code with ' num2str(ones_count) '''1''s' ]; ...
           ['with Error tolerance mode= ' num2str(err_tol_mode) ' and (' num2str(err_tol_fp) ','  num2str(err_tol_fn) ') bits of (fp,fn) error tolerance']; ...
           ['at RF on time = ' num2str(RF_ontime) '(s)']});
end
xlabel('Vtrip(V)');
ylabel('Probability of missing detection');

end