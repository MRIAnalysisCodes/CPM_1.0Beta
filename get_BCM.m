%BCM = behaviour connection matrix

function [pos_BCM,neg_BCM] = get_BCM(networkmatrix,behaviour,threshold)
    no_node = size(networkmatrix,1);
    no_sample = size(networkmatrix,3);
    
    networkmatrix_vcts = reshape(networkmatrix,[],no_sample);    
    [r_mat,p_mat] = corr(networkmatrix_vcts',behaviour);
    
    r_mat = reshape(r_mat,no_node,no_node);
    p_mat = reshape(p_mat,no_node,no_node);

    pos_mask = zeros(no_node,no_node);
    neg_mask = zeros(no_node,no_node);
    pos_edges = find(r_mat > 0 & p_mat < threshold);
    neg_edges = find(r_mat < 0 & p_mat < threshold);
    
    pos_mask(pos_edges) = 1;
    neg_mask(neg_edges) = 1;
    
    pos_BCM = pos_mask;
    neg_BCM = neg_mask;
end