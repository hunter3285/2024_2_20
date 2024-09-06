clc; clear all; close all;
Fs = 1e9;
T = 1/Fs;
% N = 8192;
% N = 256;
N = 1024;
t = (0:N-1)*T;
Freq_offset = 100e6;
Noise_Jamming_BW = 50e6;
Freq_slice = 4;
pseudo_noise = 1/sqrt(2)*(randn(N,1) + 1j*randn(N,1));
% % phase_noise = randn(N,1);
phase_noise = zeros(N,1);

% figure
% plot(randn(200,1));

fc = 3e9;
% t = 0:0.8e-9:2e-6;
for ii = 1:Freq_slice
    for nn = 1:N
        % iq(ii,:) = 1/sqrt(2)*(randn(1,1) + 1j*randn(1,1))*exp(1j*2*pi*fc*t).*exp(1j*2*pi*((0.5e9/freq_slice)*ii + freq_offset)*t);
        iq(ii,nn) = exp(1j*2*pi*fc*t(nn))*exp(1j*2*pi*((Noise_Jamming_BW/Freq_slice)*ii + Freq_offset)*t(nn) + 2*pi*phase_noise(nn));
        % iq(ii,nn) = exp(1j*2*pi*fc*t(nn))*exp(1j*2*pi*((0.5e9/freq_slice)*ii + freq_offset)*t(nn) + 2*pi*randn);
    end
end
% for nn = 1:N
%     iq_n(:, nn) = iq(:, nn).*pseudo_noise(nn);
% end
for nn = 1:N
    iq_n(:, nn) = iq(:, nn).*pseudo_noise(nn);
end
% for nn = 1:N
%     iq_n(:, nn) = iq(:, nn).*pseudo_noise(nn);
% end
% iq01 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*1e8*t);
% iq02 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*2e8*t);
% iq03 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*3e8*t);
% iq04 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*4e8*t);
% iq05 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*5e8*t);
% iq06 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*6e8*t);
% iq07 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*7e8*t);
% iq08 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*8e8*t);
% iq09 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*9e8*t);
% iq10 = exp(1j*2*pi*fc*t).*exp(1j*2*pi*10e8*t);
% x = iq01 + iq02 + iq03 + iq04 + iq05 + iq06 + iq07 + iq08 + iq09 + iq10;
x_s = sum(iq, 1);
% x_n = sum(iq_n, 1);
x_n = sum(iq, 1) + 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N));
figure
% plot(t, real(iq1));
% hold on;
% plot(t, real(iq2));
% hold on;
% plot(t, real(iq3));
% hold on;
plot(t, real(x_s));


figure
y = fft(x_s);
plot(Fs/N*(0:N-1), abs(y));
figure
y_n = fft(x_n);
plot(Fs/N*(0:N-1), abs(y_n));