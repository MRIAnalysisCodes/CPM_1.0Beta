function [result] = CPM(behavior,network)

    threshold = input('the threshold\n');
    
    if nargin == 0
        behavior = load_behaviourdata;
        network = load_networkmatrix;
    end
    
    num_node = size(network,1);
    num_subj = size(network,3);
    pos_mask = zeros(num_node,num_node,num_subj);
    neg_mask = zeros(num_node,num_node,num_subj);
    left_pos_edge = zeros(num_node,num_node,num_subj-1,num_subj);
    left_neg_edge = zeros(num_node,num_node,num_subj-1,num_subj);
    sum_pos = zeros(num_subj-1,num_subj);
    sum_neg = zeros(num_subj-1,num_subj);
    fit_pos = zeros(num_subj,2);
    fit_neg = zeros(num_subj,2);
    behav_pred_pos = zeros(1,num_subj);
    behav_pred_neg = zeros(1,num_subj);
    
    [pos_mask_all,neg_mask_all] = get_BCM(network,behavior,threshold);
    
    for i = 1:size(network,3)
        fprintf('\n Leaving out subj # %6.3f',i);
        train_network = network; train_network(:,:,i) = [];
        train_behavior = behavior; train_behavior(i,:) = [];
        [pos_mask(:,:,i),neg_mask(:,:,i)] = get_BCM(train_network,train_behavior,threshold);
        left_pos_mask = repmat(pos_mask(:,:,i),1,1,size(network,3)-1);
        left_neg_mask = repmat(neg_mask(:,:,i),1,1,size(network,3)-1);
        left_pos_edge(:,:,:,i) = left_pos_mask .* train_network;
        left_neg_edge(:,:,:,i) = left_neg_mask .* train_network;
        sum_pos(:,i) = squeeze(sum(sum(left_pos_edge(:,:,:,i))));
        sum_neg(:,i) = squeeze(sum(sum(left_neg_edge(:,:,:,i))));
        fit_pos(i,:) = polyfit(sum_pos(:,i),train_behavior,1);
        fit_neg(i,:) = polyfit(sum_neg(:,i),train_behavior,1);
        test_network = network(:,:,i);
        test_sumpos = sum(sum(test_network.*pos_mask(:,:,i)));
        test_sumneg = sum(sum(test_network.*neg_mask(:,:,i)));
        behav_pred_pos(i) = fit_pos(i,1)*test_sumpos + fit_pos(i,2);
        behav_pred_neg(i) = fit_neg(i,1)*test_sumneg + fit_neg(i,2);        
    end
    [R_pos, P_pos] = corr(behav_pred_pos',behavior);
    [R_neg, P_neg] = corr(behav_pred_neg',behavior);
    result.R_pos = R_pos; result.P_pos = P_pos; result.R_neg = R_neg; result.P_neg = P_neg;
    result.pos_mask_all = pos_mask_all; result.neg_mask_all = neg_mask_all;
    
    set(0,'DefaultFigureVisible', 'off');
    figure(1); plot(behav_pred_pos,behavior,'r.'); xlabel('Prediction'); ylabel('Target');lsline; 
    saveas(gcf, 'leave_one_out_pos', 'png')
    figure(2); plot(behav_pred_neg,behavior,'b.'); xlabel('Prediction'); ylabel('Target');lsline; 
    saveas(gcf, 'leave_one_out_neg', 'png')
    save pos_mask.edge -ascii pos_mask_all
    save neg_mask.edge -ascii neg_mask_all
    save('Result_summary','result')
end