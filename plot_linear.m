function [ m,b, Rsq, handle, m_se, b_se ] = plot_linear( x,y, show_zero )
% basic linear fitting taken from 
% https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html

% Allowing us to assign NaN's if we dont wish to plot a point
nan_bool = isnan(x) | isnan(y);

x(nan_bool) = [];
y(nan_bool) = [];

h = scatter(x,y);
hold on
X = [ones(length(x),1) x];

[p,stats] = robustfit(x,y);

b_se = stats.se(1);
m_se = stats.se(2);

m = p(2);
b = p(1);

% Do we want to include orgin in our plots?
if show_zero
    x_with_zero = [x;0];
    y_calc = m*x_with_zero;
    handle = plot(x_with_zero,y_calc+b);
else
    y_calc = m*x;
    handle = plot(x,y_calc+b);
end

handle.Color = (h.CData)*0.75;

yCalc = X*[p(2);p(1)];
Rsq = 1 - sum((y - yCalc).^2)/sum((y - mean(y)).^2);

end

