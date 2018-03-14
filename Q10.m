%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q10: With given Vtrip, the effect of err tolerance (err_mode = 1) with fixed
%code length on minimal sensitivity (shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r=Q10(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,err_tol_fn,err_tol_fp,code_length)

err_tol_mode = 1;
shift_min=ones(code_length,code_length);

for shift = shift_range
    for ones_count = 2:(code_length-1)
        % Sweep error_tol_Q2 from 0 to ones_count-1 because
        % false wkup prob is 1 when ones <= err_tol +1 and an occasional
        % false 1

        for err_tol = (0):(ones_count-2)
            code_bandwidth_rf = ones_count/RF_ontime;
            code_bandwidth_dig = code_bandwidth_rf*over_samp;
            code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
            code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
            code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
            %See if the Vtrip meets the target false wake up and miss wakeup target
            if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(target_Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_falsewkup ...
                    && Calc_Misswkup(code_length,ones_count,code_pfp(target_Vtrip_i),code_pfn(target_Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_misswkup)
                shift_min(err_tol+1,ones_count) = shift;
                
            end

        end
    end
end
%%Plot the color map figure by sweeping the number of 1s
x = linspace(1,code_length,code_length);
y = linspace(0,code_length-1,code_length); %y from 0 to code_length_Q5-1 because err_tol starts at 0
[X,Y] = meshgrid(x,y);
figure
surf(X,Y,shift_min);
colormap hot
title({['Minimal shift value with Vtrip = ' num2str(Vtrip(target_Vtrip_i))];...
    ['false wakeup <' num2str(target_falsewkup) ' {} in an hour,' 'Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code length = ' num2str(code_length) ', err tol mode = ' num2str(err_tol_mode)]});
xlabel('Number of ''1''s ');
ylabel('Error tolerance bit(s)');
xlim([1,code_length]);
ylim([0,code_length-1]);
view(2);
caxis([min(shift_range) max(shift_range)]);
colorbar;
r = shift_min;
end