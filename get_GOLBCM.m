% GOLBCM is the group overlop behaviour connectivity matrix. 
% group size should be node x node x sunject_number;
% it is the the number of iterations;
% pos_GOLBCM is the edges exist in group2 but not in group 1;
% neg_GOLBCM is the edges exist in group1 but not in group 2;
% the code have been test in real data, we found this is a very strict
% method to select fearure.
 
function [pos_GOLBCM,neg_GOLBCM] = get_GOLBCM(group1,group2,it,threshold)
    node_size = size(group1,1);
    g1_subno = size(group1,3); g2_subno = size(group2,3);
    pos_GOLBCM = zeros(node_size,node_size,it);
    neg_GOLBCM = zeros(node_size,node_size,it);
    for i = 1:it
        pos_GOLBCM(:,:,i) = (group1(:,:,randi(g1_subno,1,1))<group2(:,:,randi(g2_subno,1,1)));
        neg_GOLBCM(:,:,i) = (group1(:,:,randi(g1_subno,1,1))>group2(:,:,randi(g2_subno,1,1)));
    end
    pos_GOLBCM = int16(pos_GOLBCM); neg_GOLBCM = int16(neg_GOLBCM);
    pos_GOLBCM = mean(pos_GOLBCM,3); pos_GOLBCM(pos_GOLBCM<=threshold)=0;
    neg_GOLBCM = mean(neg_GOLBCM,3); neg_GOLBCM(neg_GOLBCM<=threshold)=0;
end