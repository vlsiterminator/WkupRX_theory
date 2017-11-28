function r=Calc_CDF(x,sigma, u)

    r=0.5+0.5*erf((x-u)/(sigma*sqrt(2)));
end