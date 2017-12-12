%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q4: The effect of digital power (Varying code length with fixed code weight)
%on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code weight is fixed for the same RFFE power

function [r1,r2]=Q4(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight)

err_tol_mode = 1;
shift_min=ones(code_length_max,code_length_max);
Vtrip_shift_min=ones(code_length_max,code_length_max);
for shift = shift_range
    for code_length = code_length_min:code_length_max
        % Number of ones is decided by the code weight and code length
        ones_count = floor(code_length*code_weight); 
        % Sweep error_tol_Q2 from 0 to ones_count-2 because
        % false wkup prob is 1 when ones <= err_tol+1 and an occasional
        % false 1

        for err_tol = (0):(ones_count-2)
            code_bandwidth_rf = ones_count/RF_ontime;
            code_bandwidth_dig = code_bandwidth_rf*over_samp;
            code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
            code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
            code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
            %Start from the highest Vtrip, and find the range of (Vtrip_i,Vtrip_max) that
            %meets the false wkup target in an hour
            Satisfy_falsewkup = false;
            Vtrip_lowerb = Vtrip_num;
            for Vtrip_i = linspace(Vtrip_num,1,Vtrip_num)
                if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) > target_falsewkup)
                    break
                else
                    Satisfy_falsewkup = true;
                    Vtrip_lowerb = Vtrip_i;
                end
            end
            % Calculate the miss wkup prob if only satisfying the false wkup
            % probability
            if (Satisfy_falsewkup == true)
                %Check the miss wkup probability in range of
                %(Vtrip_lowerb,Vtrip_max), and find the minimum
                Vtrip_i = linspace(Vtrip_lowerb,Vtrip_num,Vtrip_num-Vtrip_lowerb+1);
                %Find the min missing wkup prob and the index
                [curr_misswkup,Vtrip_min] = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn));
                if curr_misswkup < target_misswkup       
                    shift_min(err_tol+1,code_length) = shift;
                    Vtrip_shift_min(err_tol+1,code_length) = Vtrip(Vtrip_min+Vtrip_lowerb-1);
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
surf(X,Y,shift_min);
colormap hot
title({['Minimal shift value with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code weight = ' num2str(code_weight)]});
xlabel('Code length');
ylabel('Error tolerance bit(s)');
xlim([code_length_min,code_length_max]);
ylim([0,floor(code_length_max*code_weight)]);
view(2);
caxis([min(shift_range) max(shift_range)]);
colorbar;
r1 = shift_min;
r2 = Vtrip_shift_min;
end