function [behaviour_data] = load_behaviourdata
    [filename, pathname] = uigetfile('.txt');
    behaviour_data = load([pathname,filesep,filename]);
end