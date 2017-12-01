%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q2b: The effect of digital power (Varying code length with fixed code weight)
%on sensitivity (Prob of missing wkup) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r=Q2b(Vtrip,Vtrip_num,shift,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,err_tol,err_tol_fn,err_tol_fp,code_length_min,code_length_max,code_weight)

err_tol_mode = 0;
err_tol_fp_Q2b = 3;
code_weight_Q2 = code_weight;
err_tol_Q2 = err_tol;
code_misswkup_min_Q2b=ones(code_length_max,code_length_max);
code_Vtrip_opt_Q2b=ones(code_length_max,code_length_max);
c = [10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 1];
for code_length = code_length_min:code_length_max
    % Number of ones is decided by the code weight and code length
    ones_count = floor(code_length*code_weight_Q2); 
    % Sweep error_tol_Q2 from 0 to ones_count-1 because
    % false wkup prob is 1 when ones <= err_tol+1 and an occasional
        % false 1
    
    for err_tol_fn_Q2b = (0):(ones_count-2)
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
end