function [Network] = load_networkmatrix(Dapth)
    Dapth = uigetdir(pwd,'Select the folder of subjects');
    Subjects = struct2cell(dir(Dapth))';
    Subjects = Subjects(3:size(Subjects))';
    
    for i = 1:size(Subjects)
        Network(:,:,i) = load([Dapth,filesep,Subjects{i,1}]);
        i
    end
    clc
end
