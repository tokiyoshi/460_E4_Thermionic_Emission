data = DataImport();

% Initalizing some constants and arrays used later
filiment_radius = 1.3*10^(-4);
d_to3o2 = (filiment_radius*100) ^ (3/2);
e = exp(1);
K = physconst('Boltzmann');
e0 = 8.854187817 *10^(-12);

C_woT = sqrt(((e^3)/(4*pi*e0*filiment_radius)))/ K;


[Io, Io_rsq, Io_err, T] = deal(zeros(5,1));

handles = [];

% Plotting our Io data
for i = 1:length(data.Va)
    %figure
    x = data.Va_sqrt(:,i);
    y = data.Ia_log(:,i);
    
    [m, b, rsq, handle, m_err, b_err] = plot_linear(x,y, 0);
    
    precent_err =  0.01./data.Ia(:,i); %\pm .005 mA
    e = errorbar(x,y,y .* precent_err, 'o', 'MarkerEdgeColor', handle.Color *1.25);
    e.Color = handle.Color*1.25; 
    
    m_precent_error = abs(m_err/m);
    b_precent_error = abs(b_err/b);
    
    Io(i,1) = exp(b);
    Io_err(i,1) = exp(b)*b_precent_error;
    Io_rsq(i,1) = rsq;
    
    %T(i,1) = C_woT/exp(m);
    handles = [handles ;handle];
end

B = (data.If_init)./ d_to3o2;
T = 60.2 * sqrt( B .* (1+1+83*10^(-6) .* B));
data.('T') = T;

%data.('T') = T *10^-27;
data.('Io') = Io;
data.('Io_err') = Io_err;
data.('Io_rsq') = Io_rsq;

xlabel('$\sqrt{V_a}$','Interpreter','latex')
ylabel('$\ln(I_a)$','Interpreter','latex')
title('Relation Between $\ln (I_a)$ and $\sqrt{V_a}$ finding $I_o$','Interpreter','latex')
grid on

%%%%%%%%%% Getting fancy and setting a legend for no real reason %%%%%%
hleg = legend(handles, ...
    {[num2str(data.Io(1),'%.2f'),' \pm ', num2str(data.Io_err(1),'%0.2f'), 'mA'], ...
    [num2str(data.Io(2),'%.2f'),' \pm ', num2str(data.Io_err(2),'%0.2f'), ' mA'],...
    [num2str(data.Io(3),'%.2f'),' \pm ', num2str(data.Io_err(3),'%0.2f'), ' mA'],...
    [num2str(data.Io(4),'%.2f'),' \pm ', num2str(data.Io_err(4),'%0.2f'), ' mA'],...
    [num2str(data.Io(5),'%.2f'),' \pm ', num2str(data.Io_err(5),'%0.2f'), ' mA']...
    });


hlt = text(...
    'Parent', hleg.DecorationContainer, ...
    'String', '$I_o$ Values', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'Position', [0.5, 1.05, 0], ...
    'Units', 'normalized',...
    'Interpreter','latex');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Plotting Io and T to find work function
x = 1./data.T;
y = log(data.Io./((data.T .^ 2)));

figure
% [r, m,b] = regression(x,y);
% plotregression(x,y)

[m, b, rsq, handle, m_se, b_se] = plot_linear(x,y, 0);
y_precent_error = data.Io_err./data.Io;
e = errorbar(x,y,y .* y_precent_error,'o', 'MarkerEdgeColor', handle.Color*1.5);
e.Color = handle.Color*1.5; % This colour mapping is generally unstable but I just want it lighter and 50% works in this case

xlabel('$\frac{1}{T}$ ','Interpreter','latex')
ylabel('$\ln (\frac{I_o}{T^2})$','Interpreter','latex')

grid on

eVconv = 6.242*10^18;

wo = -(m * K) * eVconv;

wo_err = abs((m_se/m) * wo);

title(['Relation Between $\ln (\frac{I_o}{T^2})$ \& $\frac{1}{T}$ ',... 
    'where $w_o$: ', num2str(wo,3), '$\pm$', num2str(wo_err,'%0.2f'),' eV'],'Interpreter','latex')
A = exp(b);

% cleaning up workspace
clearvars -except wo A data T m 