
function ComputeROC(fc, nfc)
    
    c = [fc; nfc];
    
    theta = min(c):(max(c) - min(c))/200:max(c);
    ROC = zeros(length(theta), 3);
    for i = 1:length(theta)
        [tpr, fpr] = ApplyThreshold(fc, nfc, theta(i));
        ROC(i, 1) = tpr;
        ROC(i, 2) = fpr;
        ROC(i, 3) = theta(i);
    end
    
    plot(ROC(:, 2), ROC(:, 1));
    
function [tpr, fpr] = ApplyThreshold(fc, nfc, theta)
    
    n_tp = sum(fc < theta);
    n_fn = sum(fc >= theta);
    n_fp = sum(nfc < theta);
    n_tn = sum(nfc >= theta);
    
    tpr = n_tp / (n_tp + n_fn);
    fpr = n_fp / (n_tn + n_fp);
