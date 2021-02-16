function [S,f,k] = fk(d,dt,dx,L);
%FK: compute FK spectrum of a seismic gather.
%
%  [S,f,k] = fk(d,dt,dx,L);
%
%  IN   d:      data (traces in columns) 
%       dt:     time interval
%       dx:     spatial increment between traces 
%       L:      apply spectral smoothing using a separable
%               2D Hamming window of LxL samples
%
%  OUT  S:      FK spectrum
%       f:      freq axis in Hz
%       k:      wave-number spectrum in cylces/m (if dx is in meters)
%
%  Note: when plotting spectra (S)  use log(S) or S.^alpha (alpha=0.1-0.3) to
%  increase the visibility of small events or background 
%
%  Example:
%
%         [d,t,h] = linear_events;   
%         [S,f,k] = fk(d,0.004,5,9); subplot(221);wigb(d,1,h,t);
%                                    xlabel('offset [m]'); ylabel('t [s]');
%                                    subplot(222);imagesc(k,f,S);
%                                    xlabel('k [c/m]'); ylabel('f [Hz]');
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%



[nt,nx]=size(d);

 nk = 4*(2^nextpow2(nx));
 nf = 4*(2^nextpow2(nt));

 S = fftshift( abs(fft2(d,nf,nk)) );
 H = hamming(L)*hamming(L)';
 S = conv2(S,H,'same');
 S = S(nf/2:nf,:);
 

 f = (0:1:nf/2)/nf/dt;
 k = (-nk/2+1:1:nk/2)/nk/dx;
