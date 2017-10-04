function [ m,b, Rsq ] = plot_linear( x,y )
% basic linear fitting taken from 
% https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
scatter(x,y)
hold on
X = [ones(length(x),1) x];
points = X\y;
m = points(2);
b = points(1);
y_calc = m*x;

plot(x,y_calc+b)
xlabel('Voltage sqrt')
ylabel('ln(Ia)')
title('Linear Regression Relation Between ln(Ia) and sqrt(Vact) to find Io')
grid on

yCalc = X*points;
Rsq = 1 - sum((y - yCalc).^2)/sum((y - mean(y)).^2);
end

