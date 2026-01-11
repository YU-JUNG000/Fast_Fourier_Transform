clear;  clc;    close all;

% part_1
num = 8;
FB_VG = 11;
pow = -2*pi*i/num;


% initial
% the ifft of the sample_Y
times = log(num) / log(2);
sample = zeros(6+times, num);
sample(1, [1:4]) = [1+i, 1-i, -1+i, -1-i] * power(2,-0.5);
sample(1, [5:8]) = [1+i, 1-i, -1+i, -1-i] * power(2,-0.5);
% % num = 32
% sample(1, [ 9:16]) = sample(1, [1:8]);
% sample(1, [17:32]) = sample(1, [1:16]);
sample(3,:) = ifft(sample(1,:));


SMP_VG = double(floor(fi(sample,1,FB_VG+2,FB_VG) * power(2, FB_VG)));
twiddle_factor = zeros(times, num);
for t = 1 : times
    group(t) = power(2,t-1);
    for gp = 1 : group(t)
        num_1(t) = num / power(2,t);
        pw = 0;
        for num1 = 1 : num_1(t)
            % the add part
            sample(3+t, 2*(gp-1)*num_1(t)+num1) = sample(2+t, 2*(gp-1)*num_1(t)+num1) + sample(2+t, (2*gp-1)*num_1(t)+num1);
            % the minus part
            sample(3+t, (2*gp-1)*num_1(t)+num1) = (sample(2+t, 2*(gp-1)*num_1(t)+num1) - sample(2+t, (2*gp-1)*num_1(t)+num1)) * exp(pow*pw);
            twiddle_factor(t, 2*(gp-1)*num_1(t)+num1) = 1;
            twiddle_factor(t, (2*gp-1)*num_1(t)+num1) = exp(pow*pw);
            pw = pw+group(t);
        end
    end
end


% VERILOG_PART
TF_1 = fi(twiddle_factor,1,13,11);
TF_VG = double(TF_1 * power(2,11));
for t = 1 : times
    for gp = 1 : group(t)
        pw = 0;
        for num1 = 1 : num_1(t)
            SMP_VG(3+t, 2*(gp-1)*num_1(t)+num1) = SMP_VG(2+t, 2*(gp-1)*num_1(t)+num1) + SMP_VG(2+t, (2*gp-1)*num_1(t)+num1);
            SMP_VG(3+t, (2*gp-1)*num_1(t)+num1) = (SMP_VG(2+t, 2*(gp-1)*num_1(t)+num1) - SMP_VG(2+t, (2*gp-1)*num_1(t)+num1)) * TF_1(t, (2*gp-1)*num_1(t)+num1);
        end
    end
end
SMP_VG = floor(SMP_VG);
TF_REAL_VG = real(TF_VG);
TF_IMAG_VG = imag(TF_VG);



%  * exp(pow*pw)
% sorting by order
order = zeros(3, num);
dd = zeros(times, num);
for od = 1 : num
    order(1,od) = od-1;
    order(2,od) = str2double(dec2bin(order(1,od)));
    for tt = times : -1 : 1
        dd(times-tt+1,od) = floor(mod(order(2,od), power(10,tt)) /power(10,tt-1));
    end
    for tt = times : -1 : 1
       order(3,od) = order(3,od) + dd(tt,od)*power(2,tt-1); 
    end
end
order(4,:) = order(3,:)+1;

err = zeros(1,num);
err(:) = 1;
for num2 = 1 : num
    sample(5+times,num2) = sample(3+times, order(4,num2));
    sample(6+times,num2) = sample(1,num2) - sample(5+times,num2);
    SMP_VG(5+times,num2) = SMP_VG(3+times, order(4,num2));
    err(num2) = abs(sample(6+times,num2));
end
REAL_VG = real(SMP_VG);
IMAG_VG = imag(SMP_VG);
   


mt = zeros(9, num);
mt(1, :) = real(sample(1,:));
mt(2, :) = real(sample(5+times,:));
mt(3, :) = abs(mt(2,:) - mt(1,:));
mt(4, :) = imag(sample(1,:));
mt(5, :) = imag(sample(5+times,:));
mt(6, :) = abs(mt(5,:)-mt(4,:));
% part 4
mt(8, :) = real(sample(3+times,:));
mt(9, :) = imag(sample(3+times,:));

figure;
n = 1 : num
plot(n, mt(8,:));
xlabel('value');
ylabel('value');
title('the real part value in bit reversed order');
figure;
n = 1 : num
plot(n, mt(9,:));
xlabel('input set');
ylabel('value');
title('the imag part value in bit reversed order');

% % the error between the ideal value and the value after operation
% figure;
% n = 1 : num
% plot(n,mt(1,:));
% xlabel('set');
% ylabel('value');
% title('the real-part error between the ideal value and the value after operation');
% hold on;
% plot(n,mt(2,:));
% 
% figure;
% plot(n,mt(3,:));
% xlabel('set');
% ylabel('error');
% title('the error value of real-part');
% 
% figure;
% plot(n,mt(4,:));
% xlabel('set');
% ylabel('value');
% title('the imag-part error between the ideal value and the value after operation');
% hold on;
% plot(n,mt(5,:));
% 
% figure;
% plot(n,mt(6,:));
% xlabel('set');
% ylabel('error');
% title('the error value of imag-part');



% process
process = zeros(num+3, num/2+2);
process(1, [1:num/2]) = sample(4, [1:num/2]);
process(2, [1:num/2]) = sample(4, [1+num/2:num]);
for r = 0 : num/2-1 
    for n = 0 : num/2-1
        process(2*r+4, n+1) = process(1,n+1) * exp(pow*r*n*2);
        process(2*r+5, n+1) = process(2,n+1) * exp(pow*(2*r+1)*n);
    end
    process(2*r+4, num/2+1) = sum(process(2*r+4, :));
    process(2*r+5, num/2+1) = sum(process(2*r+5, :));
    process(2*r+4, num/2+2) = sample(1,2*r+1);
    process(2*r+5, num/2+2) = sample(1,2*r+2);
end

% % real-part && imaginary-part of sample_Y
% re_im = zeros(4, NUM);
% re_im(1,:) = real(sample(1,:));
% re_im(2,:) = imag(sample(1,:));
% re_im(3,:) = real(sample(2,:));
% re_im(4,:) = imag(sample(2,:));
% num = 1 : NUM
% figure;
% plot(re_im(1, :));
% title('real part of Y0-Y7');
% xlabel('input sets');
% ylabel('value');
% figure;
% plot(re_im(2, :));
% title('imag part of Y0-Y7');
% xlabel('input sets');
% ylabel('value');
% figure;
% plot(re_im(3, :));
% title('real part of x0-x7');
% xlabel('input sets');
% ylabel('value');
% figure;
% plot(re_im(1, :));
% title('imag part of x0-x7');
% xlabel('input sets');
% ylabel('value');

% % check 1
% check1 = zeros(4, num/2);
% cc1 = zeros(2,num/2);
% check1(1,:) = sample(3, [1:num/2]);
% check1(2,:) = sample(3, [num/2+1:num]);
% for trans = 1 : num/4
%     check1(3,trans) = check1(1,trans) + check1(2,trans);
%     check1(4,trans) = check1(1,trans) - check1(2,trans);
%     cc1(1,trans) = abs(check1(3,trans)-sample(4,trans));
%     cc1(2,trans) = abs(check1(4,trans)-sample(4,trans+num/2));
% end
% 
% % check 2
% check2 = zeros(9, num/4);
% cc2 = zeros(5,num/4);
% check2(1,:) = sample(4, [1:num/4]);
% check2(2,:) = sample(4, [num/4+1:num/2]);
% check2(6,:) = sample(4, [num/2+1 : (3/4)*num]);
% check2(7,:) = sample(4, [num*(3/4)+1 : num]);
% for trans = 1 : num/4
%     check2(3,trans) = check2(1,trans) + check2(2,trans);
%     check2(4,trans) = check2(1,trans) - check2(2,trans);
%     check2(8,trans) = check2(6,trans) + check2(7,trans);
%     check2(9,trans) = check2(6,trans) - check2(7,trans);
%     cc2(1,trans) = abs(check2(3,trans)-sample(5,trans));
%     cc2(2,trans) = abs(check2(4,trans)-sample(5,trans+num/4));
%     cc2(4,trans) = abs(check2(8,trans)-sample(5,trans+num/2));
%     cc2(5,trans) = abs(check2(9,trans)-sample(5,trans+num*(3/4)));
% end

% % check 3
% check3 = zeros(9, num/8);
% cc3 = zeros(5,num/8);
% check3( 1,:) = sample(5, [      1     : num*(1/8)]);
% check3( 2,:) = sample(5, [num*(1/8)+1 : num*(2/8)]);
% check3( 6,:) = sample(5, [num*(2/8)+1 : num*(3/8)]);
% check3( 7,:) = sample(5, [num*(3/8)+1 : num*(4/8)]);
% check3(11,:) = sample(5, [num*(4/8)+1 : num*(5/8)]);
% check3(12,:) = sample(5, [num*(5/8)+1 : num*(6/8)]);
% check3(16,:) = sample(5, [num*(6/8)+1 : num*(7/8)]);
% check3(17,:) = sample(5, [num*(7/8)+1 : num      ]);
% for trans = 1 : num/8
%     check3( 3,trans) = check3( 1,trans) + check3( 2,trans);
%     check3( 4,trans) = check3( 1,trans) - check3( 2,trans);
%     check3( 8,trans) = check3( 6,trans) + check3( 7,trans);
%     check3( 9,trans) = check3( 6,trans) - check3( 7,trans);
%     check3(13,trans) = check3(11,trans) + check3(12,trans);
%     check3(14,trans) = check3(11,trans) - check3(12,trans);
%     check3(18,trans) = check3(16,trans) + check3(17,trans);
%     check3(19,trans) = check3(16,trans) - check3(17,trans);
%     cc3( 1,trans) = abs(check3( 3,trans)-sample(6,trans));
%     cc3( 2,trans) = abs(check3( 4,trans)-sample(6,trans+num*(1/8)));
%     cc3( 4,trans) = abs(check3( 8,trans)-sample(6,trans+num*(2/8)));
%     cc3( 5,trans) = abs(check3( 9,trans)-sample(6,trans+num*(3/8)));
%     cc3( 7,trans) = abs(check3(13,trans)-sample(6,trans+num*(4/8)));
%     cc3( 8,trans) = abs(check3(14,trans)-sample(6,trans+num*(5/8)));
%     cc3(10,trans) = abs(check3(18,trans)-sample(6,trans+num*(6/8)));
%     cc3(11,trans) = abs(check3(19,trans)-sample(6,trans+num*(7/8)));
% end

% check 4
% part = 16;
% check4 = zeros(9, num/part);
% cc4 = zeros(5,num/part);
% check4( 1,:) = sample(6, [      1         : num*(1/part)]);
% check4( 2,:) = sample(6, [num*( 1/part)+1 : num*(2/part)]);
% check4( 6,:) = sample(6, [num*( 2/part)+1 : num*(3/part)]);
% check4( 7,:) = sample(6, [num*( 3/part)+1 : num*(4/part)]);
% check4(11,:) = sample(6, [num*( 4/part)+1 : num*(5/part)]);
% check4(12,:) = sample(6, [num*( 5/part)+1 : num*(6/part)]);
% check4(16,:) = sample(6, [num*( 6/part)+1 : num*(7/part)]);
% check4(17,:) = sample(6, [num*( 7/part)+1 : num*(8/part)]);
% check4(21,:) = sample(6, [num*( 8/part)+1 : num*(9/part)]);
% check4(22,:) = sample(6, [num*( 9/part)+1 : num*(10/part)]);
% check4(26,:) = sample(6, [num*(10/part)+1 : num*(11/part)]);
% check4(27,:) = sample(6, [num*(11/part)+1 : num*(12/part)]);
% check4(31,:) = sample(6, [num*(12/part)+1 : num*(13/part)]);
% check4(32,:) = sample(6, [num*(13/part)+1 : num*(14/part)]);
% check4(36,:) = sample(6, [num*(14/part)+1 : num*(15/part)]);
% check4(37,:) = sample(6, [num*(15/part)+1 : num      ]);
% for trans = 1 : num/part
%     check4( 3,trans) = check4( 1,trans) + check4( 2,trans);
%     check4( 4,trans) = check4( 1,trans) - check4( 2,trans);
%     check4( 8,trans) = check4( 6,trans) + check4( 7,trans);
%     check4( 9,trans) = check4( 6,trans) - check4( 7,trans);
%     check4(13,trans) = check4(11,trans) + check4(12,trans);
%     check4(14,trans) = check4(11,trans) - check4(12,trans);
%     check4(18,trans) = check4(16,trans) + check4(17,trans);
%     check4(19,trans) = check4(16,trans) - check4(17,trans);
%     check4(23,trans) = check4(21,trans) + check4(22,trans);
%     check4(24,trans) = check4(21,trans) - check4(22,trans);
%     check4(28,trans) = check4(26,trans) + check4(27,trans);
%     check4(29,trans) = check4(26,trans) - check4(27,trans);
%     check4(33,trans) = check4(31,trans) + check4(32,trans);
%     check4(34,trans) = check4(31,trans) - check4(32,trans);
%     check4(38,trans) = check4(36,trans) + check4(37,trans);
%     check4(39,trans) = check4(36,trans) - check4(37,trans);
%     cc4( 1,trans) = abs(check4( 3,trans)-sample(7,trans));
%     cc4( 2,trans) = abs(check4( 4,trans)-sample(7,trans+num*( 1/part)));
%     cc4( 4,trans) = abs(check4( 8,trans)-sample(7,trans+num*( 2/part)));
%     cc4( 5,trans) = abs(check4( 9,trans)-sample(7,trans+num*( 3/part)));
%     cc4( 7,trans) = abs(check4(13,trans)-sample(7,trans+num*( 4/part)));
%     cc4( 8,trans) = abs(check4(14,trans)-sample(7,trans+num*( 5/part)));
%     cc4(10,trans) = abs(check4(18,trans)-sample(7,trans+num*( 6/part)));
%     cc4(11,trans) = abs(check4(19,trans)-sample(7,trans+num*( 7/part)));
%     cc4(13,trans) = abs(check4(23,trans)-sample(7,trans+num*( 8/part)));
%     cc4(14,trans) = abs(check4(24,trans)-sample(7,trans+num*( 9/part)));
%     cc4(16,trans) = abs(check4(28,trans)-sample(7,trans+num*(10/part)));
%     cc4(17,trans) = abs(check4(29,trans)-sample(7,trans+num*(11/part)));
%     cc4(19,trans) = abs(check4(33,trans)-sample(7,trans+num*(12/part)));
%     cc4(20,trans) = abs(check4(34,trans)-sample(7,trans+num*(13/part)));
%     cc4(22,trans) = abs(check4(38,trans)-sample(7,trans+num*(14/part)));
%     cc4(23,trans) = abs(check4(39,trans)-sample(7,trans+num*(15/part)));
% end



