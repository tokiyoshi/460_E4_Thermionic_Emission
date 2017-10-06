function [ data ] = DataImport()
%DataImport Just a basic script to scrape the data and return it as a table
% Pretty lazy scrape but it'll take less time then generalizing it
addpath('data')
data_list = dir('data\*.xlsx');

entry_names = deal(cell(5,1));
[Va_init, Ia_init, Vf_init, If_init] = deal(zeros(5,1));
[Vset, Va, Ia , Vact, Va_corr, Vact_corr] = deal(zeros(5,5));
for i = 1:length(data_list)
    entry_name = data_list(i).name;
    [num_entry,~,~] = xlsread(entry_name);
    entry_name = char(['entry',num2str(i)]);
    entry_names(i,1) = cellstr(entry_name);
    
    Vset(:,i) = num_entry(1:end,1);
    Va(:,i) = num_entry(1:end,2);
    Ia(:,i) = num_entry(1:end,3);
    Vact(:,i) = num_entry(1:end,4);
    
    Va_init(i,1) = num_entry(1,6);
    Ia_init(i,1) = num_entry(1,7);
    Vf_init(i,1) = num_entry(1,8);
    If_init(i,1) = num_entry(1,9);
    
    Va_corr(:,i) = Va(:,i) - Vf_init(i,1)/2;
    Vact_corr(:,i) = Vact(:,i) - Vf_init(i,1)/2;
end
%Ia(5,1) = NaN(); % Choosing an outlier point
Va_sqrt = sqrt(Va_corr);
Vact_sqrt = sqrt(Vact_corr);
Ia_log = log(Ia);

data = table(Ia_init, Va_init, Vf_init,If_init, Vset, Va, Ia, Vact,...
    Va_sqrt, Vact_sqrt, Ia_log);
data.Properties.RowNames = entry_names;
data.Properties.VariableUnits{'Ia_init'} = 'mA';
data.Properties.VariableUnits{'Ia'} = 'mA';
data.Properties.VariableUnits{'Va_init'} = 'V';
data.Properties.VariableUnits{'Vf_init'} = 'V';
data.Properties.VariableUnits{'Vset'} = 'V';
data.Properties.VariableUnits{'Va'} = 'V';
data.Properties.VariableUnits{'Vact'} = 'V';


end

