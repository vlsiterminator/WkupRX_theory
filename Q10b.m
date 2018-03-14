%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q10b: With given Vtrip, the effect of err tolerance (err_mode = 0) with fixed
%code length on minimal sensitivity (shift). Loop between the number of
%err_tol_fn and err_tol_fn in a certain err_tol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r1,r2]=Q10b(Vtrip,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,target_Vtrip_i,code_length)
err_tol_mode = 0;
err_tol = 0;
shift_min_fn=ones(code_length,code_length);
shift_min_fp=ones(code_length,code_length);

for shift = shift_range
    for ones_count = 2:(code_length-1)

        code_bandwidth_rf = ones_count/RF_ontime;
        code_bandwidth_dig = code_bandwidth_rf*over_samp;
        code_sigma = sqrt(code_bandwidth_rf/200)*sigma;
        code_pfp = 1 - Calc_CDF(Vtrip, code_sigma, 0);
        code_pfn = Calc_CDF(Vtrip, code_sigma, shift);
        % Sweep error_tol_fn from 0 to ones_count-2 because
        % false wkup prob is 1 when ones <= err_tol_fn + 1 and an occasional
        % false 1
        for err_tol_fn = (0):(ones_count-2)
        % Sweep error_tol_fp from 0 to code_length-ones_count-1 because
        % false wkup prob is 1 when code_length-ones <= err_tol_fp + 1 and 
        % a enveloped interference
            err_tol_fn = 0;
            for err_tol_fp = 0:(code_length-ones_count-1)
         
                %See if the Vtrip meets the target false wake up and miss wakeup target
                if(Calc_Falsewkup(code_length,ones_count,code_bandwidth_dig,code_pfp(target_Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_falsewkup ...
                        && Calc_Misswkup(code_length,ones_count,code_pfp(target_Vtrip_i),code_pfn(target_Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn) < target_misswkup)
                    shift_min_fn(err_tol_fn+1,ones_count) = shift;
                    shift_min_fp(err_tol_fp+1,ones_count) = shift;
                    
                end
            end

        end
    end
end
%%Plot the color map figure by sweeping the number of 1s
x = linspace(1,code_length,code_length);
y = linspace(0,code_length-1,code_length); %y from 0 to code_length_Q5-1 because err_tol starts at 0
[X,Y] = meshgrid(x,y);
%Figure 1 with err_tol_fn as y axis
figure
surf(X,Y,shift_min_fn);
colormap hot
title({['Minimal shift value with Vtrip = ' num2str(Vtrip(target_Vtrip_i))];...
    ['false wakeup <' num2str(target_falsewkup) ' {} in an hour,' 'Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code length = ' num2str(code_length) ', err tol mode = ' num2str(err_tol_mode)]});
xlabel('Number of ''1''s ');
ylabel('Error tolerance Fn bit(s)');
xlim([1,code_length]);
ylim([0,code_length-1]);
view(2);
caxis([min(shift_range) max(shift_range)]);
colorbar;
%Figure 2 with err_tol_fp as y axis
figure
surf(X,Y,shift_min_fp);
colormap hot
title({['Minimal shift value with Vtrip = ' num2str(Vtrip(target_Vtrip_i))];...
    ['false wakeup <' num2str(target_falsewkup) ' {} in an hour,' 'Missing detection rate <' num2str(target_misswkup)];...
    ['RF on time = ' num2str(RF_ontime) '(s), Code length = ' num2str(code_length) ', err tol mode = ' num2str(err_tol_mode)]});
xlabel('Number of ''1''s ');
ylabel('Error tolerance Fp bit(s)');
xlim([1,code_length]);
ylim([0,code_length-1]);
view(2);
caxis([min(shift_range) max(shift_range)]);
colorbar;
r1 = shift_min_fn;
r2 = shift_min_fp;
end
