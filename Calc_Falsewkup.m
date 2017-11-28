function r=Calc_Falsewkup(code_length,ones,bandwidth,pfp,err_tol_mode,err_tol,err_tol_fp,err_tol_fn)
%err_tol_mode = 1 is the mode doesn't differentiate fn and fp,
%err_tol_mode = 0 is the mode defines fn and fp separately
%False wkup prob is the sum of all conditions, 
r=0;
if (err_tol_mode == 1) %error tolerance mode 1
    if (err_tol >= ones) %always wkup
        r=3600*bandwidth;
    else
        for tol_fn=0:err_tol % Bruteforce tolerating false negative from 0 to err_tol
            for tol_fp=0:(err_tol-tol_fn) % Bruteforce tolerating false positive from 0 to err_tol-tol_fn
                if (tol_fp <= code_length-ones) %Not possible if the number of '0's is smaller than tol fp number
                    %In the case of tolerating tol_fn false negatives and
                    %tol_fp false positives, there are (ones-tol_fn+tol_fp)
                    %1s, and (code_length-ones+tol_Fn-tol_fp) 0s
                    r=r+(pfp).^(ones-tol_fn+tol_fp)*nchoosek(ones,tol_fn)*nchoosek(code_length-ones,tol_fp)...
                        .*(1.-pfp).^(code_length-ones+tol_fn-tol_fp)*3600*bandwidth;
                end
            end
            
        end
    end
else
    %error tolerance mode 0
    if (err_tol_fn >= ones) %always wkup
        r=3600*bandwidth;
    else
        for tol_fn=0:err_tol_fn % Bruteforce tolerating false negative from 0 to err_tol_fn
            for tol_fp=0:err_tol_fp % Bruteforce tolerating false positive from 0 to err_tol_fp
                if (tol_fp <= code_length-ones) %Not possible if the number of '0's is smaller than tol fp number
                    %In the case of tolerating tol_fn false negatives and
                    %tol_fp false positives, there are (ones-tol_fn+tol_fp)
                    %1s, and (code_length-ones+tol_Fn-tol_fp) 0s
                    r=r+(pfp).^(ones-tol_fn+tol_fp)*nchoosek(ones,tol_fn)*nchoosek(code_length-ones,tol_fp)...
                        .*(1.-pfp).^(code_length-ones+tol_fn-tol_fp)*3600*bandwidth;
                end
            end
            
        end
    end
end

end
