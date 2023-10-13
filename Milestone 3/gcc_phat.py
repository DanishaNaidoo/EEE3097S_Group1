from scipy.io import wavfile
Fs, y1 = wavfile.read('./Recordings/stereo1.wav')
m1out =
m2out = 

def gcc_phat(sig, refsig, fs=1, max_tau=0.1, interp=16):

    sig = np.array(sig)
    refsig = np.array(refsig)
    #print(type(sig))
    #print(type(refsig))
    # make sure the length for the FFT is larger or equal than len(sig) + len(refsig)
    n = sig.shape[0] + refsig.shape[0]

    # Generalized Cross Correlation Phase Transform
    SIG = np.fft.rfft(sig, n=n)
    REFSIG = np.fft.rfft(refsig, n=n)
    R = SIG * np.conj(REFSIG)

    cc = np.fft.irfft(R / np.abs(R), n=(interp * n))

    max_shift = int(interp * n / 2)
    if max_tau:
        max_shift = np.minimum(int(interp * fs * max_tau), max_shift)
        
    cc = np.concatenate((cc[-max_shift:], cc[:max_shift+1]))

    # find max cross correlation index
    shift = np.argmax(np.abs(cc)) - max_shift

    tau = shift / float(interp * fs)
    return tau
