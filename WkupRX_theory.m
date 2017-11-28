%Version: V0.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       V0.1: a) Change the the relation between RF_ontime and BW to
%       BW=ones/RF_ontime. b) Differentiate the RF BW and digital BW,only  the
%       latter is related to oversampling
%       V0.2: a) Updated Calc_Falsewkup with considering tolerating false
%       negatives(Effect is small). b) Add err_tol_mode to differentiate
%       false postive and false negative error tolerance
%       V0.3: Change to log scale figures
%       V0.4: Add two surf figures with shift represents the color
%The time domain equation at the output of RFFE is V(t)=Vrf(t)+Vn(t). The
%motivation of wkup rx is to reduce the RF input power (Increase sensitivity).
shift=0.0018; %The shift value is the central of gaussian distribution with RF signal, which is decided by the RF power and amplifier gain
% shift=0.0036; %-77dbm
shift_range=linspace(0.002,0.0009,10);
sigma=0.00042; %Sigma at 200hz, sigma is proportional to the sqrt of bandwidth, Vn=sqrt(4kT*Bw*R)
over_samp = 2;
%Assume the RF on time is 1 second, then the code length decides the clock frequency
RF_ontime = 0.12;
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
err_tol_mode = 1;
code_misswkup_min_Q1=ones(code_length_max,code_length_max);
code_Vtrip_opt_Q1=ones(code_length_max,code_length_max);
for code_length = code_length_min:code_length_max
    % Sweep ones_count from err_tol+1 to code_length-err_tol-1 because
    % false wkup prob is 1 when ones <= err_tol, miss wkup prob is 1 when
    % there is enveloped interference
    for ones_count = (2+err_tol):(code_length-err_tol-1) 
        code_bandwidth_rf = ones_count/RF_ontime;
        code_bandwidth_dig = code_bandwidth_rf*over_samp;
        code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
        code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
        code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
        %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
        %meets the false wkup target in an hour
        for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
            Vtrip_lowerb = Vtrip_num;
            Satisfy_falsewkup = false;
            if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) > target_falsewkup)
                Satisfy_falsewkup = true;
                if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                    Vtrip_lowerb = Vtrip_num;
                else
                    Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                end
                break
            end
        end
        % Calculate the miss wkup prob if only satisfying the false wkup
        % probability
        if (Satisfy_falsewkup == true)
            %Check the miss wkup probability in range of
            %(Vtrip_lowerb,Vtrip_max), and find the minimum
            Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
            %Find the min missing wkup prob and the index
            [code_misswkup_min_Q1(ones_count,code_length),Vtrip_opt_ind]...
                = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn));
            code_Vtrip_opt_Q1(ones_count,code_length) = Vtrip(Vtrip_lowerb+Vtrip_opt_ind-1);
        end
                
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(1,code_length_max,code_length_max);
[X,Y] = meshgrid(x,y);
c = [10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 1];
figure
surf(X,Y,log10(code_misswkup_min_Q1));
colormap hot
title({['Missing detection rate with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['RF on time = ' num2str(RF_ontime) '(s), Error tolerance = ' num2str(err_tol)]});
xlabel('Code length');
ylabel('Number of 1s in code');
xlim([code_length_min,code_length_max]);
ylim([1,code_length_max]);
view(2)
% caxis([0 0.02])
caxis(log10([c(1) c(length(c))]));
colorbar('FontSize',11,'YTick',log10(c),'YTickLabel',c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err_tol_mode = 0;
code_misswkup_min_Q1b=ones(code_length_max,code_length_max);
code_Vtrip_opt_Q1b=ones(code_length_max,code_length_max);
for code_length = code_length_min:code_length_max
    % Sweep ones_count from err_tol_fn+1 to code_length-err_tol_fp-1 because
    % false wkup prob is 1 when ones <= err_tol_fn, miss wkup prob is 1 when
    % there is enveloped interference
    for ones_count = (2+err_tol_fn):(code_length-err_tol_fp-1) 
        code_bandwidth_rf = ones_count/RF_ontime;
        code_bandwidth_dig = code_bandwidth_rf*over_samp;
        code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
        code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
        code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
        %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
        %meets the false wkup target in an hour
        for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
            Vtrip_lowerb = Vtrip_num;
            Satisfy_falsewkup = false;
            if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) > target_falsewkup)
                Satisfy_falsewkup = true;
                if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                    Vtrip_lowerb = Vtrip_num;
                else
                    Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                end
                break
            end
        end
        % Calculate the miss wkup prob if only satisfying the false wkup
        % probability
        if (Satisfy_falsewkup == true)
            %Check the miss wkup probability in range of
            %(Vtrip_lowerb,Vtrip_max), and find the minimum
            Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
            %Find the min missing wkup prob and the index
            [code_misswkup_min_Q1b(ones_count,code_length),Vtrip_opt_ind]...
                = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn));
            code_Vtrip_opt_Q1b(ones_count,code_length) = Vtrip(Vtrip_lowerb+Vtrip_opt_ind-1);
        end
                
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(1,code_length_max,code_length_max);
[X,Y] = meshgrid(x,y);
figure
surf(X,Y,log10(code_misswkup_min_Q1b));
colormap hot
title({['Missing detection rate with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['RF on time = ' num2str(RF_ontime) '(s), Error tolerance (Fp,Fn) = (' num2str(err_tol_fp) ',' num2str(err_tol_fn) ')']});
xlabel('Code length');
ylabel('Number of 1s in code');
xlim([code_length_min,code_length_max]);
ylim([1,code_length_max]);
view(2)
caxis(log10([c(1) c(length(c))]));
colorbar('FontSize',11,'YTick',log10(c),'YTickLabel',c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q1b: The effect of RF power (Code weight) on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
err_tol_mode = 1;
code_weight_Q2 = code_weight;
code_misswkup_min_Q2=ones(code_length_max,code_length_max);
code_Vtrip_opt_Q2=ones(code_length_max,code_length_max);
for code_length = code_length_min:code_length_max
    % Number of ones is decided by the code weight and code length
    ones_count = floor(code_length*code_weight_Q2); 
    % Sweep error_tol_Q2 from 0 to ones_count-1 because
    % false wkup prob is 1 when ones <= err_tol
    
    for err_tol_Q2 = (0):(ones_count-1)
        code_bandwidth_rf = ones_count/RF_ontime;
        code_bandwidth_dig = code_bandwidth_rf*over_samp;
        code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
        code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
        code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
        %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
        %meets the false wkup target in an hour
        for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
            Vtrip_lowerb = Vtrip_num;
            Satisfy_falsewkup = false;
            if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol_Q2,err_tol_fp,err_tol_fn) > target_falsewkup)
                Satisfy_falsewkup = true;
                if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                    Vtrip_lowerb = Vtrip_num;
                else
                    Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                end
                break
            end
        end
        % Calculate the miss wkup prob if only satisfying the false wkup
        % probability
        if (Satisfy_falsewkup == true)
            %Check the miss wkup probability in range of
            %(Vtrip_lowerb,Vtrip_max), and find the minimum
            Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
            %Find the min missing wkup prob and the index
            [code_misswkup_min_Q2(err_tol_Q2+1,code_length),Vtrip_opt_ind]...
                = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol_Q2,err_tol_fp,err_tol_fn));
            code_Vtrip_opt_Q2(err_tol_Q2+1,code_length) = Vtrip(Vtrip_lowerb+Vtrip_opt_ind-1);
        end
                
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(0,code_length_max-1,code_length_max); %y from 0 to code_length_max-1 because err_tol starts at 0
[X,Y] = meshgrid(x,y);
figure
surf(X,Y,log10(code_misswkup_min_Q2));
colormap hot
title({['Missing detection rate with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code weight = ' num2str(code_weight_Q2)]});
xlabel('Code length');
ylabel('Error tolerance bit(s)');
xlim([code_length_min,code_length_max]);
ylim([0,floor(code_length_max*code_weight_Q2)]);
view(2)
caxis(log10([c(1) c(length(c))]));
colorbar('FontSize',11,'YTick',log10(c),'YTickLabel',c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
err_tol_mode = 0;
err_tol_fp_Q2b = 3;
code_misswkup_min_Q2b=ones(code_length_max,code_length_max);
code_Vtrip_opt_Q2b=ones(code_length_max,code_length_max);
for code_length = code_length_min:code_length_max
    % Number of ones is decided by the code weight and code length
    ones_count = floor(code_length*code_weight_Q2); 
    % Sweep error_tol_Q2 from 0 to ones_count-1 because
    % false wkup prob is 1 when ones <= err_tol
    
    for err_tol_fn_Q2b = (0):(ones_count-1)
        code_bandwidth_rf = ones_count/RF_ontime;
        code_bandwidth_dig = code_bandwidth_rf*over_samp;
        code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
        code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
        code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
        %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
        %meets the false wkup target in an hour
        for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
            Vtrip_lowerb = Vtrip_num;
            Satisfy_falsewkup = false;
            if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol_Q2,err_tol_fp_Q2b,err_tol_fn_Q2b) > target_falsewkup)
                Satisfy_falsewkup = true;
                if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                    Vtrip_lowerb = Vtrip_num;
                else
                    Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                end
                break
            end
        end
        % Calculate the miss wkup prob if only satisfying the false wkup
        % probability
        if (Satisfy_falsewkup == true)
            %Check the miss wkup probability in range of
            %(Vtrip_lowerb,Vtrip_max), and find the minimum
            Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
            %Find the min missing wkup prob and the index
            [code_misswkup_min_Q2b(err_tol_fn_Q2b+1,code_length),Vtrip_opt_ind]...
                = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol_Q2,err_tol_fp_Q2b,err_tol_fn_Q2b));
            code_Vtrip_opt_Q2b(err_tol_fn_Q2b+1,code_length) = Vtrip(Vtrip_lowerb+Vtrip_opt_ind-1);
        end
                
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(0,code_length_max-1,code_length_max); %y from 0 to code_length_max-1 because err_tol starts at 0
[X,Y] = meshgrid(x,y);
figure
surf(X,Y,log10(code_misswkup_min_Q2b));
colormap hot
title({['Missing detection rate with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code weight = ' num2str(code_weight_Q2) ', Error tolerance Fp=' num2str(err_tol_fp_Q2b)]});
xlabel('Code length');
ylabel('Error tolerance Fn bit(s)');
xlim([code_length_min,code_length_max]);
ylim([0,floor(code_length_max*code_weight_Q2)]);
view(2)
caxis(log10([c(1) c(length(c))]));
colorbar('FontSize',11,'YTick',log10(c),'YTickLabel',c);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3: The Minimal shift that satisfies the target false wkup per hour and
%missing detection rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err_tol_mode = 1;
shift_min_Q3=ones(code_length_max,code_length_max);
for shift_Q3 = shift_range
    for code_length = code_length_min:code_length_max
        % Sweep ones_count from err_tol+1 to code_length-err_tol-1 because
        % false wkup prob is 1 when ones <= err_tol, miss wkup prob is 1 when
        % there is enveloped interference
        for ones_count = (2+err_tol):(code_length-err_tol-1) 
            code_bandwidth_rf = ones_count/RF_ontime;
            code_bandwidth_dig = code_bandwidth_rf*over_samp;
            code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
            code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
            code_pfn = Calc_CDF(Vtrip, code_sigma, shift_Q3);
            %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
            %meets the false wkup target in an hour
            for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
                Vtrip_lowerb = Vtrip_num;
                Satisfy_falsewkup = false;
                if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) > target_falsewkup)
                    Satisfy_falsewkup = true;
                    if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                        Vtrip_lowerb = Vtrip_num;
                    else
                        Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                    end
                    break
                end
            end
            % Calculate the miss wkup prob if only satisfying the false wkup
            % probability
            if (Satisfy_falsewkup == true)
                %Check the miss wkup probability in range of
                %(Vtrip_lowerb,Vtrip_max), and find the minimum
                Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
                %Find the min missing wkup prob and the index
                curr_misswkup = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn));
                if curr_misswkup < target_misswkup       
                    shift_min_Q3(ones_count,code_length) = shift_Q3;
                end
            end

        end
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(1,code_length_max,code_length_max);
[X,Y] = meshgrid(x,y);
c = shift_range;
figure
surf(X,Y,shift_min_Q3);
colormap hot
title({['Minimal shift value with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Error tolerance = ' num2str(err_tol)]});
xlabel('Code length');
ylabel('Number of 1s in code');
xlim([code_length_min,code_length_max]);
ylim([1,code_length_max]);
view(2)
caxis([min(shift_range) max(shift_range)])
colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q3: The Minimal shift that satisfies the target false wkup per hour and
%missing detection rate (Fix error tolerance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power
err_tol_mode = 1;
code_weight_Q4 = code_weight_Q2;
shift_min_Q4=ones(code_length_max,code_length_max);
for shift_Q4 = shift_range
    for code_length = code_length_min:code_length_max
        % Number of ones is decided by the code weight and code length
        ones_count = floor(code_length*code_weight_Q4); 
        % Sweep error_tol_Q2 from 0 to ones_count-1 because
        % false wkup prob is 1 when ones <= err_tol

        for err_tol_Q4 = (0):(ones_count-1)
            code_bandwidth_rf = ones_count/RF_ontime;
            code_bandwidth_dig = code_bandwidth_rf*over_samp;
            code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
            code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
            code_pfn = Calc_CDF(Vtrip, code_sigma, shift_Q4);
            %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
            %meets the false wkup target in an hour
            for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
                Vtrip_lowerb = Vtrip_num;
                Satisfy_falsewkup = false;
                if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol_Q4,err_tol_fp,err_tol_fn) > target_falsewkup)
                    Satisfy_falsewkup = true;
                    if (Vtrip_i == Vtrip_num) %Vtrip_lowerb is the right most Vtrip_i that satifies <= target_falsewkup
                        Vtrip_lowerb = Vtrip_num;
                    else
                        Vtrip_lowerb = Vtrip_i + 1; %Vtrip_i fails target falsewkup, so use Vtrip_i + 1
                    end
                    break
                end
            end
            % Calculate the miss wkup prob if only satisfying the false wkup
            % probability
            if (Satisfy_falsewkup == true)
                %Check the miss wkup probability in range of
                %(Vtrip_lowerb,Vtrip_max), and find the minimum
                Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
                %Find the min missing wkup prob and the index
                curr_misswkup = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol_Q4,err_tol_fp,err_tol_fn));
                if curr_misswkup < target_misswkup       
                    shift_min_Q4(err_tol_Q4+1,code_length) = shift_Q4;
                end
            end

        end
    end
end
%%Plot the color map figure by sweeping the code length
x = linspace(1,code_length_max,code_length_max);
y = linspace(0,code_length_max-1,code_length_max); %y from 0 to code_length_max-1 because err_tol starts at 0
[X,Y] = meshgrid(x,y);
figure
surf(X,Y,shift_min_Q4);
colormap hot
title({['Minimal shift value with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code weight = ' num2str(code_weight_Q4)]});
xlabel('Code length');
ylabel('Error tolerance bit(s)');
xlim([code_length_min,code_length_max]);
ylim([0,floor(code_length_max*code_weight_Q4)]);
view(2);
caxis([min(shift_range) max(shift_range)]);
colorbar;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%