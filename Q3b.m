%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3b: Sweep err_tol from 0 to ones-2, and get the Minimal shift that satisfies 
%the target false wkup per hour and missing detection rate (err_tol_mode =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r=Q3b(Vtrip,Vtrip_num,shift_range,sigma,over_samp,RF_ontime,target_falsewkup,target_misswkup,code_length_min,code_length_max)

err_tol_mode = 1;
err_tol_fn = 0;
err_tol_fp = 0;
shift_min=ones(code_length_max,code_length_max);
for shift = shift_range
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
            for err_tol = (0):(ones_count-2)
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
                    curr_misswkup = min(Calc_Misswkup(code_length,ones_count,code_pfp(Vtrip_i),code_pfn(Vtrip_i),err_tol_mode,err_tol,err_tol_fp,err_tol_fn));
                    if curr_misswkup < target_misswkup       
                        shift_min(ones_count,code_length) = shift;
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
title({['Minimal shift value with false wakeup <' num2str(target_falsewkup) ' {} in an hour,'];...
    ['Missing detection rate <' num2str(target_misswkup) ', err tol mode = ' num2str(err_tol_mode)];...
    ['RF on time = ' num2str(RF_ontime) '(s)']});
xlabel('Code length');
ylabel('Number of 1s in code');
xlim([code_length_min,code_length_max]);
ylim([1,code_length_max]);
view(2)
caxis([min(shift_range) max(shift_range)])
colorbar
r=shift_min;
end