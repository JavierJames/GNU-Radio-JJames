% ----------------------------------------------------------------------- %
%                           R O C    C U R V E                            %
% ----------------------------------------------------------------------- %
% Function "roc_curve" calculates the Receiver Operating Characteristic   %
% curve, which represents the 1-specificity and sensitivity, of two classes
% of data, called class_1 and class_2.                                    %
%                                                                         %
%   Input parameters                                                      %
%       · data:     Two-column matrix which stores the data of both classes
%                   with the following structure:                         % 
%                     data = [class_1, class_2]                           %
%                   where class_1 and class_2 are column vectors.         %
%       · dispp:    (Optional) If dispp is 1, the ROC Curve will be disp- %
%                   ayed inside the active figure. If dispp is 0, no figure
%                   will be displayed.                                    %
%       · dispt:    (Optional) If dispt is 1, the optimum threshold para- %
%                   meters obtained will be displayed on the MATLAB log.  %
%                   Otherwise, if dispt is 0, no parameters will be disp- %
%                   ayed there.                                           %
%                                                                         %
%   Output variables                                                      %
%       · ROC_data: Struct that contains all the curve parameters.        %
%           - param:    Structu that contains the cuantitative parameters %
%                       of the obtained curve, which are:                 %
%               + Threshold:Optimum threshold calculated in order to maxi-%
%                           mice the sensitivity and specificity values,  %
%                           which is colocated in the nearest point to    %
%                           (0,1).                                        %
%               + AROC:     Area Under ROC Curve.                         %
%               + Accuracy: Maximum accuracy obtained.                    %
%               + Sensi:    Optimum threshold sensitivity.                %
%               + Speci:    Optimum threshold specificity.                %
%               + PPV:      Positive predicted value.                     %
%               + NPV:      Negative predicted value.                     %
%           - curve:    Matrix which contains the specificity and specifi-%
%                       city of each threshold point in columns.          %
% ----------------------------------------------------------------------- %
%   Example of use:                                                       %
%       class_1 = 0.5*randn(100,1);                                       %
%       class_2 = 0.5+0.5*randn(100,1);                                   %
%       data = [class_1, class_2];                                        %
%       ROC_Curve(data);                                                  %
% ----------------------------------------------------------------------- %
%   Author:  Víctor Martínez Cagigal                                      %
%   Date:    02/09/2015                                                   %
%   E-mail:  vicmarcag (dot) gmail (dot) com                              %
% ----------------------------------------------------------------------- %
% edited by: Javier James (4170253)
function ROC_data = roc_curve_editedJJ(data, dispp, dispt)

    % Setting default parameters and detecting errors
    if(nargin<2), dispp = 1;    end
    if(nargin<3), dispt = 1;    end
    if(size(data,2)~=2), error('Data vector must have only 2 classes.'); end
    L = size(data,1);                   % Data classes length
 
    % Calculating the threshold values between the data points
    s_data = unique(sort(data(:)));     % Sorted data points
    d_data = diff(s_data);              % Difference between consecutive points
    if(isempty(d_data)), error('Both class data are the same!'); end
    d_data(length(d_data)+1,1) = d_data(length(d_data));% Last point
    thres(1,1) = s_data(1) - d_data(1);               % First point
    thres(2:length(s_data)+1,1) = s_data + d_data./2; % Threshold values
    
    % Sorting each class
    if(mean(data(:,1))>mean(data(:,2))), data = [data(:,2),data(:,1)]; end
        
    % Calculating the sensibility and specificity of each threshold
    curve = zeros(size(thres,1),2);
    distance = zeros(size(thres,1),1);
    for id_t = 1:1:length(thres)
        TP = length(find(data(:,2) >= thres(id_t)));    % True positives
        FP = length(find(data(:,1) >= thres(id_t)));    % False positives
        FN = L - TP;                                    % False negatives
        TN = L - FP;                                    % True negatives
        
           
        curve(id_t,1) = TP/(TP + FN);   % Sensitivity
        curve(id_t,2) = TN/(TN + FP);	% Specificity
        
        %display '-------------------- ' 
        %id_t
        threshold = thres(id_t);
        TPR1= TP/(TP + FN);
        FPR1= FP/(TN + FP);
        Accuracy1 = (TP+TN)/(TP+TN+FP+FN);
        PPV1 = TP/(TP+FP); 
        NPV1=  TN/(TN+FN);
        %display '-------------------- ' 
        
        % Distance between each point and the optimum point (0,1)
        distance(id_t)= sqrt((1-curve(id_t,1))^2+(curve(id_t,2)-1)^2);
        storeROC(threshold,TPR1,FPR1,Accuracy1,PPV1,NPV1);
    end
    
    
    % Optimum threshold and parameters
    [~, opt] = min(distance);
    TP = length(find(data(:,2) >= thres(opt)));   
    FP = length(find(data(:,1) >= thres(opt)));    
    FN = L - TP;                                    
    TN = L - FP;                                    
        
    param.Threshold = thres(opt);       % Optimum threshold position
    param.Sensi = curve(opt,1);         % Optimum threshold's sensitivity
    param.Speci = curve(opt,2);         % Optimum threshold's specificity
    param.AROC  = abs(trapz(1-curve(:,2), curve(:,1))); % Area under curve
    param.Accuracy = (TP+TN)/(TP+TN+FP+FN);             % Maximum accuracy
    param.PPV   = TP/(TP+FP);           % Positive predictive value
    param.NPV   = TN/(TN+FN);           % Negative predictive value

    % Plotting if required
    if(dispp == 1)
        fill_color = [11/255, 208/255, 217/255];
        fill([1-curve(:,2); 1], [curve(:,1); 0], fill_color,'FaceAlpha',0.5);
        hold on; plot(1-curve(:,2), curve(:,1), '-b', 'LineWidth', 2);
        hold on; plot(1-curve(opt,2), curve(opt,1), 'or', 'MarkerSize', 10);
        hold on; plot(1-curve(opt,2), curve(opt,1), 'xr', 'MarkerSize', 12);
        hold off; axis square; grid on; xlabel('1 - specificity'); ylabel('sensibility');
        title(['AROC = ' num2str(param.AROC)]);
    end
    
    % Log screen parameters if required
    if(dispt == 1)
        display(' ------------------------------');
        display('|     ROC CURVE PARAMETERS     |');
        display(' ------------------------------');
        display(['  - Distance:     ' num2str(distance(opt))]);
        display(['  - Threshold:    ' num2str(param.Threshold)]);
        display(['  - Sensitivity:  ' num2str(param.Sensi)]);
        display(['  - Specificity:  ' num2str(param.Speci)]);
        display(['  - AROC:         ' num2str(param.AROC)]);
        display(['  - Accuracy:     ' num2str(param.Accuracy*100) '%']);
        display(['  - PPV:          ' num2str(param.PPV*100) '%']);
        display(['  - NPV:          ' num2str(param.NPV*100) '%']);
        display(' ');
    end
    
    % Assinging parameters and curve data
    ROC_data.param = param;
    ROC_data.curve = curve;
end