function [ output_args ] = storeROC( threshold, TPR, FPR, Accuracy, PPV, NPV)
%STOREROC Summary of this function goes here
%   Detailed explanation goes here

data = [threshold; TPR; FPR; Accuracy; PPV; NPV];

fileID = fopen('rocResults.txt','a');
fprintf(fileID, '%f %f %f %f %f %f\r\n', data); 
fclose(fileID);
end

