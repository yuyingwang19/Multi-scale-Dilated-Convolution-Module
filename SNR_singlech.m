function snr=SNR_singlech(x,x_denoise)
% 计算信噪比函数
% x :original signal
% x_denoise:noisy signal(ie. original signal + noise signal)
snr=0;
Ps=sum(sum((x-mean(mean(x))).^2));%signal power
Pn=sum(sum((x-x_denoise).^2));           %noise power
snr=10*log10(Ps/Pn);

