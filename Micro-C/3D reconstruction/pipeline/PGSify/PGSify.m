clear all;

files = ["0hr";"24hrs";"72hrs";"WTCI";"KOCI";"WTCIR";"KOCIR"];

for filenum = 1:size(files,1)
    file = files(filenum,1);


    load("variables.mat");

    mat = [];

    boundary = readmatrix(strcat(file,".boundaries.1Mb.bed"),'FileType','text','OutputType','string','Delimiter','\t');
    for chr = 1:size(genome,1)

        chrname = genome(chr,1);

        chrboundary = sort(round(mean(str2double(boundary(strcmp(boundary(:,1),chrname), 2:3)),2)));
        chrcentromere = str2double(centromere(strcmp(centromere(:,1),chrname), 2:3));
        chrgenome = str2double(genome(strcmp(genome(:,1),chrname), 2));

        chrelement = sort([0;chrboundary;chrcentromere.';chrgenome]);
        iscentromere = ismember(chrelement,chrcentromere);
        idxcentromere = find(iscentromere);
        
        for i = 1:size(chrelement,1)-1
            if ~ismember(i,idxcentromere) && ~ismember(i+1,idxcentromere)
                mat = [mat; chrname, chrelement(i,1), chrelement(i+1,1), "domain"];
            end
        end
        
        mat = [mat; chrname, chrelement(idxcentromere(1,1)-1,1), chrelement(idxcentromere(1,1),1), "gap"];
        mat = [mat; chrname, chrelement(idxcentromere(1,1),1), chrelement(idxcentromere(2,1),1), "CEN"];
        mat = [mat; chrname, chrelement(idxcentromere(2,1),1), chrelement(idxcentromere(2,1)+1,1), "gap"];

    end

    writematrix(sortrows(mat,[1,2]), strcat(file,".1Mb.TADs.PGS.bed"), 'Delimiter', '\t', 'FileType', 'text');
    disp(file);
end