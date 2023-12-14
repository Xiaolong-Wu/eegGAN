name_file='sub-12-4';
%%

path_data_temp=[path_data name_file '.mat'];
if exist(path_data_temp,'file')
    disp([path_data_temp ' exist, skip.']);
else
    save([path_data name_file '.mat'],'EEG');
    disp([path_data_temp ' have been done.']);
end