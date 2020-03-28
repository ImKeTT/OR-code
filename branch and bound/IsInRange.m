% IsInRange.m
% Determine whether the solution to the branching problem is in the range of the upper and lower bounds. If not, cut it out
function y = IsInRange(fval)
    global lowerBound;
    global upperBound;

    if isempty(upperBound) & fval >= lowerBound
        y = 1;
    else if  (fval >= lowerBound & fval <= upperBound)
        y = 1;
    else
        y = 0;
    end
end

