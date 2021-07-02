function [Z,f,c,lambda_fg,f_fg] = MakeImpedance(h,H)

%Inputs:
% h thickness of ice layer
% H thickness of water layer.

rhoi = 916;
rhow = 1028;
g = 9.8;
nu = 0.33; E = 8.7e9; Ep = E/(1-nu^2);
D = Ep/12 * h^3;

kmax = log10(1 / h );
k = logspace(-10,kmax,1000);
w =  sqrt( (D*k.^5/rhow + g*k) ./ (k*h*rhoi/rhow + coth(k*H)) );
c = w./k;
Z = -1j*Ep*h*k ./ c;
f = w/2/pi;

lambda_fg = 2*pi*(D/rhoi/g)^(1/4);
[~,ind] = min(abs(lambda_fg - 2*pi./k));
f_fg = f(ind);