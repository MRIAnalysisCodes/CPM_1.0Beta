function [permutation_result,permutation_model] = permutation_CPM(model_result,behavior,network)
    iter = input('the iter times\n');
    threshold = input('the threshold\n');
    
    if nargin == 1
        behavior = load_behaviourdata;
        network = load_networkmatrix;
    end
    
    for i = 1:iter
        fprintf('\n iter time is  # %6.3f',i);
        permutation_model(i) = permutation_core(threshold,behavior,network);
        result_per = squeeze(cell2mat(struct2cell(permutation_model)))';
        per_r_pos = result_per(:,1); p_r_pos = size(find(per_r_pos>model_result.R_pos),1)/iter;
        per_p_pos = result_per(:,2); p_p_pos = size(find(per_p_pos<model_result.P_pos),1)/iter;
        per_r_neg = result_per(:,3); p_r_neg = size(find(per_r_neg>model_result.R_neg),1)/iter;
        per_p_neg = result_per(:,4); p_p_neg = size(find(per_p_neg<model_result.P_neg),1)/iter;
        permutation_result.p_r_pos = p_r_pos; permutation_result.p_p_pos = p_p_pos;
        permutation_result.p_r_neg = p_r_neg; permutation_result.p_p_neg = p_p_neg;
    end 
    
end