from scipy.io import wavfile

start = int32(0.5*10^5)
end = len(m1out)

Fs, y1 = wavfile.read('./Recordings/stereo1.wav')
m1out = stereo_audio[:, 0]  # Left channel
m1out = m1out[start:end]

m2out = stereo_audio[:, 1]  # Right channel
m2out = m2out[start:end]

Fs, y2 = wavfile.read('./Recordings/stereo2.wav')
m3out = stereo_audio[:, 0]  # Left channel
m3out = m3out[start:end]
m4out = stereo_audio[:, 1]  # Right channel
m4out = m4out[start:end]

td12 = gcc_phat(m2out, m1out, Fs)
print("td 12 = " + td12)
td13 = gcc_phat(m3out, m1out, Fs)
print("td 13 = " + td13)
td14 = gcc_phat(m2out, m1out, Fs)
print("td 14 = " + td14)


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
