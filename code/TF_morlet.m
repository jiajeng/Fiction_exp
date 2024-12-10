function data = TF_morlet(eeg,fs, fmin, fmax, fstep,channels)
    data = [];
    for ch=1:channels
        TF = tfa_morlet(eeg(ch,:), fs, fmin, fmax, fstep);
        data = cat(3,data,TF);
    end
end