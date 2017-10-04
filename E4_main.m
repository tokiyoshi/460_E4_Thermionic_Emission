data = DataImport();

% Initalizing some constants and arrays used later
filiment_radius = 1.3*10^(-4);
d_to3o2 = (filiment_radius*100) ^ (3/2);
e = exp(1);
K = physconst('Boltzmann');
e0 = 8.854187817 *10^(-12);

C_woT = sqrt(((e^3)/(4*pi*e0*filiment_radius)))/ K;


[Io, Io_rsq, T] = deal(zeros(5,1));

handles = [];

% Plotting our Io data
for i = 1:length(data.Va)
    %figure
    x = data.Vact_sqrt(:,i);
    y = data.Ia_log(:,i);
    
    [m, b, rsq, handle] = plot_linear(x,y, 1);
    Io(i,1) = exp(b);
    Io_rsq(i,1) = rsq;
    
    T(i,1) = C_woT/exp(m);
    handles = [handles ;handle];
end

% B = (data.If_init)./ d_to3o2;
% data.('T') = 60.2 * sqrt( B .* (1+1+83*10^(-6) .* B));

data.('T') = T *10^-27;
data.('Io') = Io;
data.('Io_rsq') = Io_rsq;

xlabel('$\sqrt{V_a}$','Interpreter','latex')
ylabel('$\ln(I_a)$','Interpreter','latex')
title('Relation Between $\ln (I_a)$ and $\sqrt{V_a}$ finding $I_o$','Interpreter','latex')
grid on

%%%%%%%%%% Getting fancy and setting a legend for no real reason %%%%%%
hleg = legend(handles, ...
    {[num2str(data.Io(1)/1000,3), ' mA'], ...
    [num2str(data.Io(2)/1000,3), ' mA'],...
    [num2str(data.Io(3)/1000,3), ' mA'],...
    [num2str(data.Io(4)/1000,3), ' mA'],...
    [num2str(data.Io(5)/1000,3), ' mA']...
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
y = data.Io./(data.T .^ 2);

figure
% [r, m,b] = regression(x,y);
% plotregression(x,y)

[m, b, rsq] = plot_linear(x,y, 0);
xlabel('$\frac{1}{T}$ ','Interpreter','latex')
ylabel('$\frac{I_o}{T^2}$','Interpreter','latex')

grid on

eVconv = 6.242*10^18;

wo = (m * K) * eVconv;

title(['Relation Between $\frac{I_o}{T^2}$ \& $\frac{1}{T}$ where $w_o$: ', num2str(wo,3), 'eV'],'Interpreter','latex')
A = exp(b);

% cleaning up workspace
clearvars -except wo A data T