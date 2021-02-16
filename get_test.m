function [ net ] = get_test(varargin)

opts.idx_gpus =0; % 0: cpu
opts.matconvnet_path =  './matconvnet-1.0-beta25/matlab/vl_setupnn.m';
opts.net_path = './model/model.mat'; 
opts = vl_argparse(opts, varargin);
run(opts.matconvnet_path);


%% load network
net = load(opts.net_path);
net = net.net(1); 
net = dagnn.DagNN.loadobj(net);
net.mode = 'test';

if opts.idx_gpus >0
    net.move('gpu');
end
noise=importdata('noisy_data.mat');
chunjing=importdata('test.mat');
chunjing= single(chunjing);
input=chunjing+noise;

if opts.idx_gpus >0,   input = gpuArray(input);    end
net.eval({'input',input});
im_out = net.vars(net.getVarIndex('prediction1')).value;
quzao=im_out;
if opts.idx_gpus
    quzao = gather(quzao);
    input  = gather(input);
end

figure(1)
wiggle(chunjing);title('pure data');xlabel('Trace number');ylabel('Times(ms)');
figure(2)
wiggle(input);title('noisy data'); xlabel('Trace number');ylabel('Times(ms)');
figure(3)
wiggle(quzao);title('denosing data');xlabel('Trace number');ylabel('Times(ms)');
figure(4)
wiggle(noise);title('noise data');xlabel('Trace number');ylabel('Times(ms)');
figure(5)
wiggle(input-quzao);title('difference data');xlabel('Trace number');ylabel('Times(ms)');

dx=0.002;
[S1,f1,k1] = fk(chunjing,dx,5,9);                               
figure,imagesc(k1,f1,S1);axis([-0.1 0.1 0 200]);title('pure data');xlabel('k[c/m]');ylabel('f(Hz)');                          
[S2,f2,k2] = fk(input,dx,5,9);                               
figure,imagesc(k2,f2,S2);title('noisy data');axis([-0.1 0.1 0 200]);xlabel('k[c/m]');ylabel('f(Hz)');

[S3,f3,k3] = fk(quzao,dx,5,9);                                
figure,imagesc(k3,f3,S3);title('denosing data');axis([-0.1 0.1 0 200]);xlabel('k[c/m]');ylabel('f(Hz)');
   
[S4,f4,k4] = fk(input-quzao,dx,5,9);                               
figure,imagesc(k4,f4,S4);title('difference data');axis([-0.1 0.1 0 200]);xlabel('k[c/m]');ylabel('f(Hz)');
   
[S5,f5,k5] = fk(noise,dx,5,9);                                
figure,imagesc(k5,f5,S5);title('noise data');axis([-0.1 0.1 0 200]);xlabel('k[c/m]');ylabel('f(Hz)');


snr = SNR_singlech(chunjing,input);
disp(['SNR before denoising £º ',num2str(snr)]);
          
snrthen = SNR_singlech(chunjing,quzao);
disp(['SNR after denoising £º ',num2str(snrthen)]);
pure=single(chunjing);
 mse_yuanshi=immse(input,pure);
 disp(['MSE before denoising£º ',num2str(mse_yuanshi)]);
 mse=immse(quzao,pure);
 disp(['MSE after denoising£º ',num2str( mse)]);
