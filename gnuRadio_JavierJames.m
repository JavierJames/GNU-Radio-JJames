close all;
clc; 
clear all; 

%read and save H1 data from file, class 1 
fileID= fopen('H1_dataset.txt','r');
formatSpec= '%d';
H1_dataset=fscanf(fileID,formatSpec);
fclose(fileID);

%read and save H0 data from file, class 2
fileID= fopen('H0_dataset.txt','r');
formatSpec= '%d';
H0_dataset=fscanf(fileID,formatSpec);
fclose(fileID);


%plot the data distribution from both classes
mu_1= mean(H1_dataset);
sigma_1=std(H1_dataset);

mu_0= mean(H0_dataset);
sigma_0=std(H0_dataset);

%display the mean and the standard deviation from both classes 
display 'mu_1'
mu_1
display 'sigma_1'
sigma_1
display 'mu_0'
mu_0
display 'sigma_0'
sigma_0




x1= linspace (mu_1-4*sigma_1, mu_1+4*sigma_1)
x0= linspace (mu_0-4*sigma_0, mu_0+4*sigma_0)
figure;
plot(x1,normpdf(x1,mu_1,sigma_1))
xlabel('dB')
ylabel('Probability')
hold on;
plot(x0,normpdf(x0,mu_0,sigma_0))
xlabel('dB')
ylabel('Probability')
title('Dataset Probability Density Function threshold comparison')
yL = get(gca, 'YLim'); 
line([-58 -58],yL,'Color','m','LineStyle','--');
line([-68.5 -68.5],yL,'Color','g','LineStyle','--');
hold off ;
legend({'H1 = d(t)+n(t)', 'H0 = n(t)', 'initial threshold = -58 dB', 'optimized threshold = -68.5 dB' }, 'FontSize',12,'FontWeight','bold')


figure;
plot(x1,normpdf(x1,mu_1,sigma_1))
xlabel('dB')
ylabel('Probability')
hold on;
plot(x0,normpdf(x0,mu_0,sigma_0))
xlabel('dB')
ylabel('Probability')
title('Dataset Probability Density Function with initial threshold')
yL = get(gca, 'YLim'); 
line([-58 -58],yL,'Color','m','LineStyle','--');
hold off ;
legend({'H1 = d(t)+n(t)', 'H0 = n(t)', 'initial threshold = -58 dB'}, 'FontSize',12,'FontWeight','bold')



Y1= normpdf(x1,mu_1,sigma_1);
Y0= normpdf(x1,mu_0,sigma_0);

solve('Y1 ==Y0','x1')

syms x
Y11=(1/(sigma_1*sqrt(2*pi)))*exp( (- ((x-mu_1)^2)) / (2*pow2(sigma_1) ));
Y22=(1/(sigma_0*sqrt(2*pi)))*exp( (- ((x-mu_0)^2)) / (2*pow2(sigma_0) ));

Y111=(1/(sigma_1*sqrt(2*pi)))*exp( (- ((x1-mu_1).^2)) / (2*pow2(sigma_1) ));
Y222=(1/(sigma_0*sqrt(2*pi)))*exp( (- ((x1-mu_0).^2)) / (2*pow2(sigma_0) ));

eqn= Y11==Y22;
solx = solve(eqn,x)

figure;
plot(x1,Y111)
xlabel('dB')
ylabel('Probability')
hold on;
plot(x1,Y222)
xlabel('dB')
ylabel('Probability')
title('Dataset Probability Density Function of dataset H0 and H1')
hold off;
legend({'H1 = d(t)+n(t)', 'H0 = n(t)'}, 'FontSize',12,'FontWeight','bold')

%plot the ROC 
% class_1 = 0.5*randn(100,1); 
% class_2 = 0.5+0.5*randn(100,1); 
class_1 = H1_dataset; 
class_2 = H0_dataset;
data = [class_1, class_2]; 

fileID = fopen('rocResults.txt','a');
fprintf(fileID, '%s %7s %7s %12s %7s %7s\r\n', 'theshold', ' TPR', 'FPR', 'Accuracy', 'PPV', 'NPV'  ); 
fclose(fileID);

figure;
ROC_CURVE=roc_curve_editedJJ(data,1,1);


