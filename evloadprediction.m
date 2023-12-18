% Load functions
addpath('C:\Users\kanis\OneDrive\Desktop\ev load forecasting\ev2\');

% Load variables
load('dates.mat');
load('evload.mat');

% Convert the table variable to a numeric array
x = table2array(dates);
y = table2array(evload);

% Convert dates to datenum format
datesNumeric = datenum(x);

% Create a new figure window
figure;

% Subplot 1: Actual Load vs Date
subplot(4, 1, 1);
plot(x, y);
hold on;
title('Actual Load vs Date');
xlabel('Date');
ylabel('Load');
datetick('x', 'yyyy-mm-dd');

% Fit a linear regression model
mdl = fitlm(datesNumeric, y);

% Get user input for the prediction date
userInputDate = input('Enter the date (yyyy-mm-dd): ', 's');
userInputDate = datetime(userInputDate);

% Convert user input date to datenum format
userInputDateNumeric = datenum(userInputDate);

% Predict load consumption for the user-input date
predictedLoad = predict(mdl, userInputDateNumeric);

% Display the prediction
fprintf('Predicted Load Consumption on %s: %.2f\n', datestr(userInputDate), predictedLoad);

% Subplot 2: Load Prediction vs Date
subplot(4, 1, 2);
plot(x, y, 'b', 'DisplayName', 'Actual Load');
hold on;
plot(x, predict(mdl, datesNumeric), 'r', 'DisplayName', 'Predicted Load');
scatter(userInputDate, predictedLoad, 100, 'g', 'filled', 'DisplayName', 'User Input Date');
title('Load Prediction vs Date');
xlabel('Date');
ylabel('Load');
legend('show');
datetick('x', 'yyyy-mm-dd');

% Subplot 3: Residuals vs Date
subplot(4, 1, 3);
residuals = y - predict(mdl, datesNumeric);
plot(x, residuals);
title('Residuals vs Date');
xlabel('Date');
ylabel('Residuals');
datetick('x', 'yyyy-mm-dd');

% Subplot 4: Predicted Load vs Actual Load
subplot(4, 1, 4);
scatter(y, predict(mdl, datesNumeric), 'filled');
hold on;
plot([min(y), max(y)], [min(y), max(y)], 'r--');  % Diagonal line for perfect predictions
title('Predicted Load vs Actual Load');
xlabel('Actual Load');
ylabel('Predicted Load');
grid on;

% Display correlation coefficient and regression line equation
correlationCoefficient = corr(y, predict(mdl, datesNumeric));
regressionLine = polyfit(y, predict(mdl, datesNumeric), 1);
equation = sprintf('y = %.4fx + %.4f', regressionLine(1), regressionLine(2));
annotation('textbox', [0.15, 0.7, 0.2, 0.2], 'String', ...
    {['Correlation Coefficient: ', num2str(correlationCoefficient)], equation}, 'FitBoxToText', 'on');

% Adjust the spacing between subplots
spacing = 0.05;
subplotSpacing = spacing / (4 * (1 - spacing));
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf, 'Units', 'normalized');
set(gcf, 'OuterPosition', [0 0 1 1]);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperSize', [1 - subplotSpacing, 1 - subplotSpacing]);


% Print the prediction result
fprintf('\nPrediction Result:\n');
fprintf('------------------\n');
fprintf('User Input Date: %s\n', datestr(userInputDate));
fprintf('Predicted Load(kWH): %.2f\n', predictedLoad);
