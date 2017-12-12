%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q8c:  With targeted false postive rate, Sweep err_tol_fn from 0 to ones-2, sweep err_tol_fp from 0 to code_length-ones-1
%and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r1,r2]=Q8c(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_pfp,code_length_min,code_length_max)

err_tol_mode = 0;
err_tol = 0;
shift_min=ones(code_length_max,code_length_max);
Vtrip_shift_min=ones(code_length_max,code_length_max);
for shift = shift_range
    shift
    for code_length = code_length_min:code_length_max
        % Sweep ones_count from 2 to code_length-1 
        for ones_count = (2):(code_length-1) 
            code_bandwidth_rf = ones_count/RF_ontime;
            code_bandwidth_dig = code_bandwidth_rf*over_samp;
            code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
            code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
            code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
            %Sweep err_tol from 0 to ones-2 because wkup prob is 1 when ones <= err_tol+1,
            %when there is enveloped interference
            for err_tol_fn = (0):(ones_count-2)
                % Sweep error_tol_fp from 0 to code_length-ones_count-1 because
                % false wkup prob is 1 when code_length-ones <= err_tol_fp + 1 and 
                % a enveloped interference
                for err_tol_fp = 0:(code_length-ones_count-1)
                    %Find the vtrip with false postive rate closest to the target
                    [code_pfp_min,Vtrip_i] = min(abs(code_pfp - target_pfp));
                    %See if the Vtrip meets the target false wake up and miss wakeup target
                    if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_falsewkup ...
                            && Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_misswkup)
                        shift_min(ones_count,code_length) = shift;
                        Vtrip_shift_min(ones_count,code_length) = Vtrip(Vtrip_i);
                    end
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
surf(X,Y,shift_min);
colormap hot
title({['Minimal shift value with false positive rate = ' num2str(target_pfp)];...
    ['false wakeup <' num2str(target_falsewkup) ' {} in an hour,' 'Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s)'  ', err tol mode = ' num2str(err_tol_mode)]});
xlabel('Code length');
ylabel('Number of 1s in code');
xlim([code_length_min,code_length_max]);
ylim([1,code_length_max]);
view(2)
caxis([min(shift_range) max(shift_range)])
colorbar
r1=shift_min;
r2=Vtrip_shift_min;
end