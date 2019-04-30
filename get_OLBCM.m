% OLBCM = overlapped behaviour connection matrix;
% the default mode is leave-one-out method. leave mode empty will carry the mode. 
% mode = 'extraction', it and ob should be input. it is the number of
% iterations, ob is the number of subjects extract from the whole sample.

function [pos_OLBCM,neg_OLBCM] = get_OLBCM(matrix,behaviour,threshold,mode,it,ob)
    no_node = size(matrix,1);
    no_sample = size(matrix,3);
    
    if nargin <= 3 || isempty(mode)
    	pos_BCM = zeros(no_node,no_node,no_sample);
        neg_BCM = zeros(no_node,no_node,no_sample);
        for leftout = 1:no_sample
            disp(leftout)
            ob_behaviour = behaviour;
            ob_matrix = matrix;
            ob_behaviour(leftout,:) = [];
            ob_matrix(:,:,leftout) = [];
            [pos_BCM(:,:,leftout),neg_BCM(:,:,leftout)] = get_BCM(ob_matrix,ob_behaviour,threshold);
        end
    elseif strcmp(mode,'folder')
        pos_BCM = zeros(no_node,no_node,it);
        neg_BCM = zeros(no_node,no_node,it);
        for i = 1:it
            disp(i)
            ob_no = randperm(no_sample); ob_no=ob_no(1:ob);
            ob_matrix = matrix(:,:,ob_no);
            ob_behaviour = behaviour(ob_no,:);
            [pos_BCM(:,:,i),neg_BCM(:,:,i)] = get_BCM(ob_matrix,ob_behaviour,threshold);
        end 
    end
    
    pos_OLBCM = mean(pos_BCM,3); pos_OLBCM(pos_OLBCM~=1)=0;
    neg_OLBCM = mean(neg_BCM,3); neg_OLBCM(neg_OLBCM~=1)=0;
    
    clc
end