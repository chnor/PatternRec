
function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)
    err = inf;
    theta = [1, 0];
    p = 1;
    [~, d] = size(fs);
    
    epsilon =@(f, p, w, y, theta) sum(w * abs((p*f < p*theta) - y));
    
	for j = 1:d
		
        f = fs(:, j);
        
        mu_p = sum(ws' .* f .* ys) / sum (ws' .* ys);
        mu_n = sum(ws' .* f .* (1 - ys)) / sum (ws' .* (1 - ys));
        
        theta_j = (mu_p + mu_n)/2;
        
        epsilon_neg_p = epsilon(f, -1, ws, ys, theta_j);
        epsilon_pos_p = epsilon(f, 1, ws, ys, theta_j);
        
        if epsilon_neg_p < epsilon_pos_p
            p_j = -1;
            err_j = epsilon_neg_p;
        else
            p_j = 1;
            err_j = epsilon_pos_p;
        end
        
        if err_j < err
            disp(['Improvement: ', num2str(err_j)]);
            err = err_j;
            p = p_j;
            theta = [j, theta_j];
        end
        
	end
end
