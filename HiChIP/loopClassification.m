clear all;

loop = readmatrix("../bed/Merged.loops.Q0.01.bedpe", 'Delimiter', '\t', 'FileType', 'text', 'OutputType', 'string');
promoter = readmatrix("../bed/H3K27ac.Promoter.bed", 'Delimiter', '\t', 'FileType', 'text', 'OutputType', 'string');
enhancer = readmatrix("../bed/H3K27ac.Enhancer.bed", 'Delimiter', '\t', 'FileType', 'text', 'OutputType', 'string');

PP = [];
EP = [];
EE = [];

for idx = 1:size(loop,1)
    chr = loop(idx,1);
    pos1 = str2double(loop(idx,2:3));
    pos2 = str2double(loop(idx,5:6));

    promoter_pos = str2double(promoter(strcmpi(promoter(:,1),chr), 2:3));
    enhancer_pos = str2double(enhancer(strcmpi(enhancer(:,1),chr), 2:3));
    
    promoter_mid = mean(promoter_pos, 2);
    enhancer_mid = mean(enhancer_pos, 2);
    
    promoter1 = promoter((promoter_mid - pos1(1,1)).*(promoter_mid - pos1(1,2)) < 0, 1:3);
    promoter2 = promoter((promoter_mid - pos2(1,1)).*(promoter_mid - pos2(1,2)) < 0, 1:3);
    enhancer1 = enhancer((enhancer_mid - pos1(1,1)).*(enhancer_mid - pos1(1,2)) < 0, 1:3);
    enhancer2 = enhancer((enhancer_mid - pos2(1,1)).*(enhancer_mid - pos2(1,2)) < 0, 1:3);
    
    N_PP = size(promoter1,1) * size(promoter2,1);
    N_EP = size(promoter1,1) * size(enhancer2,1) + size(enhancer1,1) * size(promoter2,1);
    N_EE = size(enhancer1,1) * size(enhancer2,1);
    
    N_max = max([N_PP;N_EP;N_EE]);

    if N_PP == N_max
        PP = [PP; loop(idx,:)];
    end
    if N_EP == N_max
        EP = [EP; loop(idx,:)];
    end
    if N_EE == N_max
        EE = [EE; loop(idx,:)];
    end

    % for i = 1:size(promoter1,1)
    %     for j = 1:size(promoter2,1)
    %         PP = [PP; promoter1(i,:), promoter2(j,:)];
    %     end
    % end
    % 
    % for i = 1:size(promoter1,1)
    %     for j = 1:size(enhancer2,1)
    %         EP = [EP; enhancer2(j,:), promoter1(i,:)];
    %     end
    % end
    % for i = 1:size(promoter2,1)
    %     for j = 1:size(enhancer1,1)
    %         EP = [EP; enhancer1(j,:), promoter2(i,:)];
    %     end
    % end
    % 
    % for i = 1:size(enhancer1,1)
    %     for j = 1:size(enhancer2,1)
    %         EE = [EE; enhancer1(i,:), enhancer2(j,:)];
    %     end
    % end

    disp(idx/size(loop,1))
end

writematrix(PP, "../bed/Merged.loops.Q0.01.PP.bedpe", 'Delimiter', '\t', 'FileType', 'text');
writematrix(EP, "../bed/Merged.loops.Q0.01.EP.bedpe", 'Delimiter', '\t', 'FileType', 'text');
writematrix(EE, "../bed/Merged.loops.Q0.01.EE.bedpe", 'Delimiter', '\t', 'FileType', 'text');
