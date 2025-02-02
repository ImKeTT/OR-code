% createBinTreeNode.m
% Construct a binary tree, each node corresponds to a solution
function BinTree = createBinTreeNode(binTreeNode)

global result;
global lowerBound;
global upperBound;
global count;

if isempty(binTreeNode)
    return;
else
    BinTree{1} = binTreeNode;
    BinTree{2} = [];
    BinTree{3} = [];
    
    [x, fval, exitflag] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, binTreeNode{7});
    if count == 1
%         upperBound = 0; % ??????
        lowerBound = fval;
        count = 2;
    end
    
    if ~IsInRange(fval)
        return;
    end

    if exitflag == 1
        flag = [];
        % Search for non-integer solution components
        for i = 1 : length(x)
            if round(x(i)) ~= x(i)
                flag = i;
                break;
            end
        end
        % branch
        if ~isempty(flag)
            lowerBound = max([lowerBound; fval]);
            OutputLowerAndUpperBounds();
            lbnd = binTreeNode{6};
            ubnd = binTreeNode{7};
            lbnd(flag, 1) = ceil(x(flag, 1)); % si she wu ru
            ubnd(flag, 1) = floor(x(flag, 1));
            
            % Compare and choose the branch with the larger target function
            [~, fval1] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd);
            [~, fval2] = linprog(binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
        binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7});
            if fval1 < fval2                
                % create left child tree        
                BinTree{2} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd});

                % right tree
                BinTree{3} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7}});
            else
                % right tree
                BinTree{3} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, lbnd, binTreeNode{7}});
                % left tree       
                BinTree{2} = createBinTreeNode({binTreeNode{1}, binTreeNode{2}, binTreeNode{3}, ...
            binTreeNode{4}, binTreeNode{5}, binTreeNode{6}, ubnd});
            end
        else
            upperBound = min([upperBound; fval]);
            OutputLowerAndUpperBounds();
            result = [result; [x', fval]];
            return;
        end
    else
        % cut branch
        return;
    end  
end

