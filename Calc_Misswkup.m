function r=Calc_Misswkup(code_length,ones,pfp,pfn,err_tol_mode,err_tol,err_tol_fp,err_tol_fn)
%     r=1-(1-pfp)^7*(1-pfn)^8 ...
%                    -(1-pfp)^6*pfp*7*(1-pfn)^8-(1-pfp)^7*(1-pfn)^7*pfn*8 ...% prob of 1 error happens
%                    -(1-pfp)^5*pfp^2*nchoosek(7,2)*(1-pfn)^8-(1-pfp)^7*(1-pfn)^6*pfn^2*nchoosek(8,2)...%prob of 2 fp or 2fn
%                    -(1-pfp)^6*pfp^1*nchoosek(7,1)*(1-pfn)^7*pfn^1*nchoosek(8,1)... %prob of 1 fp and 1fn
%                    -(1-pfp)^4*pfp^3*nchoosek(7,3)*(1-pfn)^8-(1-pfp)^7*(1-pfn)^5*pfn^3*nchoosek(8,3)...%prob of 3 fp or 3fn
%                    -(1-pfp)^5*pfp^2*nchoosek(7,2)*(1-pfn)^7*pfn^1*nchoosek(8,1)... %prob of 2 fp and 1fn
%                    -(1-pfp)^6*pfp^1*nchoosek(7,1)*(1-pfn)^6*pfn^2*nchoosek(8,2)... %prob of 1 fp and 2fn
%                    ;
r=1+10^-12;
if (err_tol_mode == 1) %error tolerance mode 1
    if (err_tol >= ones)
        r=0;
    else
        for tol_fn=0:err_tol
            for tol_fp=(0:err_tol-tol_fn) 
                %prob of missing wake up is 1 - (sum of prob of success wake up)
                if(code_length-ones-tol_fp>=0 && ones-tol_fn>=0)%Not possible if the number of '0's is smaller than tol fp number
                    r = r - (1-pfp).^(code_length-ones-tol_fp).*pfp.^tol_fp*nchoosek(code_length-ones,tol_fp) ...
                        .*(1-pfn).^(ones-tol_fn).*pfn.^(tol_fn)*nchoosek(ones,tol_fn);
                end
            end
        end
    end
%     if(err_tol == 0)
%         r=1-(1-pfp).^(code_length-ones).*(1-pfn).^(ones);
% 
%     else
%         r=1-(1-pfp).^(code_length-ones).*(1-pfn).^(ones);
%         for i=1:err_tol
%             for j=0:i %j is the number of tolerating false postive, so i-j is false negative tolerance
%                 %prob of missing wake up is 1 - (sum of prob of success wake up)
%                 if(code_length-ones-j>=0 && ones-i+j>=0)
%                     r = r - (1-pfp).^(code_length-ones-j).*pfp.^j*nchoosek(code_length-ones,j).*(1-pfn).^(ones-i+j).*pfn.^(i-j)*nchoosek(ones,i-j);
%                 end
%             end
%         end
%     end
    
else
    %error tolerance mode 0   
    if (err_tol_fn >= ones)
        r=0;
    else

        for tol_fn=0:err_tol_fn
            for tol_fp=0:err_tol_fp 
                %prob of missing wake up is 1 - (sum of prob of success wake up)
                if(code_length-ones-tol_fp>=0 && ones-tol_fn>=0)%Not possible if the number of '0's is smaller than tol fp number
                    r = r - (1-pfp).^(code_length-ones-tol_fp).*pfp.^tol_fp*nchoosek(code_length-ones,tol_fp) ...
                        .*(1-pfn).^(ones-tol_fn).*pfn.^(tol_fn)*nchoosek(ones,tol_fn);
                end
            end
        end
    
    end
end

end