clear all;

load("EPI_variables_nonRB_nonE2F1.mat");

% the threshold for the distance between Promoter and Enhancer
thres = 60e3;

PE = [];
PE_mid = [];
PE_signal = [];
PE_TPM = [];

% for each promoter
for i = 1:size(promoter,1)
    enhancer_chr = enhancer(strcmpi(enhancer(:,1), promoter(i,1)),:);
    enhancer_mid_chr = enhancer_mid(strcmpi(enhancer(:,1), promoter(i,1)),:);
    insulator_chr = insulator(strcmpi(insulator(:,1), promoter(i,1)),:);
    insulator_mid_chr = insulator_mid(strcmpi(insulator(:,1), promoter(i,1)),:);
    insulator_signal_chr = insulator_signal(strcmpi(insulator(:,1), promoter(i,1)),:);
    
    % find neareast enhancer
    [d,idx] = min(abs(enhancer_mid_chr-promoter_mid(i,1)));

    % check if it is below the threshold
    if d < thres
        PE = [PE; promoter(i,:), enhancer_chr(idx,:)];
        PE_mid_slice = [promoter_mid(i,1), enhancer_mid_chr(idx,1)];
        PE_mid = [PE_mid; PE_mid_slice];
        PE_TPM = [PE_TPM; TPM(i,:)];

        % find insulators that are in between promoter and enhancer
        det = (insulator_mid_chr < max(PE_mid_slice.')) & (insulator_mid_chr > min(PE_mid_slice.'));
        if sum(det) == 0
            % no insulator in the middle
            PE_signal = [PE_signal; repmat([0],1,size(insulator_signal,2))];
        else
            signal_slice = sum(insulator_signal_chr(det,:),1);
            PE_signal = [PE_signal; signal_slice];
        end
    end

    disp(i/size(promoter,1));
end