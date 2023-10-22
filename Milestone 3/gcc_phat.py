from scipy.io import wavfile
import numpy as np

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


start = int(0.5*10**5)

# read in wave files from pis
Fs, y1 = wavfile.read('./Recordings/stereo1.wav')

# separate into 2 channels
m1out = y1[:, 0]  # Left channel

# trim to exclude mic pop
end = len(m1out)
m1out = m1out[start:end]

m2out = y1[:, 1]  # Right channel
m2out = m2out[start:end]

Fs, y2 = wavfile.read('./Recordings/stereo2.wav')
m3out = y2[:, 0]  # Left channel
m3out = m3out[start:end]
m4out = y2[:, 1]  # Right channel
m4out = m4out[start:end]

# plug wave files into TDoA function
td12 = gcc_phat(m2out, m1out, Fs)
#print("TDoA12 = " + str(td12) + ";")
print(str(td12))

td13 = gcc_phat(m3out, m1out, Fs)
#print("TDoA13 = " + str(td13) +";")
print(str(td13))

td14 = gcc_phat(m2out, m1out, Fs)
#print("TDoA14 = " + str(td14) + ";")
print(str(td14))

with open("tdoa_values.txt", "w") as file:
    file. truncate(0)
    file.write(f"{td12}\n{td13}\n{td14}")


