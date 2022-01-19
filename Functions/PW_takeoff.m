function [PW] = PW_takeoff(AR, WS, CL_to, CD_to, S, Sg, h,MTOW)

g = 32.17;
rho = density(h);
rho_SL = density(0);
V = sqrt(MTOW/(.5*rho*S));
q = .5*rho*(V)^2;
sigma = rho/rho_SL;
mu =.08;
ROC = 75/(.5*Sg/(60*V));
alpha = alpha0(V,h);
for i = 1:length(AR)
    e = 1.78*(1-0.045*AR(i)^0.68)-0.64;
    k = 1/(pi*AR(i)*e);
    for j = 1:length(WS)
        TW1 = (V^2)/(2*g*Sg) + q*CD_to/WS(j) + mu*(1-q*CL_to/WS(j));
        TW2 = ROC/(60*V) + (q/(WS(j)))*CD_to + (k/q)*(WS(j));
        TW = max([TW1,TW2]);
        %PW(i,j) = BHP_SL(TW,h)*V/550;
        PW(i,j) = (TW/alpha)*V/550;
    end
end
end

