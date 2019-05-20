function [T,f_xfer,Z] = CalculateStress(v,t,h,H)

Fs = 1/mean(diff(t));
N=numel(v);
N2 = 2^nextpow2(N);
% f = ifftshift(Fs*((1/2-N2/2):(N2/2-1/2))/N2);
f = ifftshift((-N2/2:N2/2-1)*Fs/(N2));
f_onesided = f(1:end/2);
Y=fft(v,N2);

% fft has output with frequencies arranged as
%   [df, ..., Nyquist-df, Nyquist, -(Nyquist-df), ..., -df]

% Plot one-sided spectrum of real-valued signal.
% semilogx(f_onesided,2*abs(Y(1:end/2+1))/N2) 

[Z,f_xfer] = MakeImpedance(h,H);
Zi = interp1(f_xfer,Z,f_onesided)';	% Interpolate transfer function
Zi(1) = 0;
Zi(f_onesided > f_xfer(end)) = 0;    % keep only long wavelength limit

% Make a transfer function Tf arranged in fft-output order noted above
Tf = zeros(size(Y));
mid = N2/2;
Tf(1:mid ) = Zi;                                % + frequencies
Tf( (mid+1) :end) = -flipud( Zi );          % - frequencies

SigHat = Y .* Tf;
T = ifft(SigHat,'symmetric');
T = T(1:N);

% plot(f,abs(Y)); hold on;
% plot(f,abs(Tf)/1e7)
% plot(f,abs(SigHat)/1e7);
