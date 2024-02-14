clear all;

cases = ["EE"; "EP"; "PP"];

opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"];
opts.SelectedVariableNames = ["VarName1", "VarName2"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["VarName1", "VarName2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "VarName2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "EmptyFieldRule", "auto");

EE = readmatrix(strcat("Merged.loops.Q0.01.",cases(1,1),".count"),opts);
EP = readmatrix(strcat("Merged.loops.Q0.01.",cases(2,1),".count"),opts);
PP = readmatrix(strcat("Merged.loops.Q0.01.",cases(3,1),".count"),opts);

loops = readmatrix(strcat("Merged.loops.Q0.01.list"),'Delimiter','\t','FileType','text','OutputType','string');

mat = strings(size(loops,1),5);
mat(:,1) = loops;

for i = 1:size(loops,1)
    for j = 1:size(cases,1)
        if j == 1
            det = EE(strcmp(EE(:,2),loops(i,1)),:);
        elseif j == 2
            det = EP(strcmp(EP(:,2),loops(i,1)),:);
        elseif j == 3
            det = PP(strcmp(PP(:,2),loops(i,1)),:);
        end

        if size(det,1) > 0
            mat(i,j+2) = det(1,1);
        else
            mat(i,j+2) = "0";
        end
    end

    tuple = str2double(mat(i,3:5).');
    if sum(tuple) == 0
        mat(i,2) = "NA";
    else
        [~,idx] = max(tuple);
        mat(i,2) = cases(idx,1);
    end
end

for j = 1:size(cases,1)
    submat = mat(strcmp(mat(:,2),cases(j,1)),1);
    writematrix(submat,strcat("Merged.loops.Q0.01.",cases(j,1),".bedpe"),'FileType','text','Delimiter','\t');
end