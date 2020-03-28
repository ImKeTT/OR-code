% Print out upper lower bound
function y = OutputLowerAndUpperBounds()

global lowerBound;
global upperBound;

disp('the lowerbound and the upperbound are:');
disp(lowerBound);
if isempty(upperBound)
    disp('No upperbound!')
else
    disp(upperBound);
end

end

