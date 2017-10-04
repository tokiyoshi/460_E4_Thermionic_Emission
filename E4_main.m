data = DataImport();
[Io, Io_rsq] = deal(zeros(5,1));
for i = 1:length(data.Va)
    %figure
    x = data.Vact_sqrt(:,i);
    y = data.Ia_log(:,i);
    
    [m, b, rsq] = plot_linear(x,y);
    Io(i,1) = b;
    Io_rsq(i,1) = rsq;
end
data.('Io') = Io;
data.('Io_rsq') = Io_rsq;
hold on