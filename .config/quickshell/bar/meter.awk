# 5-band level meter: cascaded one-pole lowpass filters split the signal into bands, RMS per 50ms chunk
BEGIN { fs = 8000; split("150 400 1000 2500", fc, " "); for (i = 1; i <= 4; i++) a[i] = 1 - exp(-2 * 3.14159265 * fc[i] / fs); n = 0 }
{
    x = $1 / 32768
    prev = x
    for (i = 1; i <= 4; i++) { lp[i] += a[i] * (x - lp[i]); d = prev - lp[i]; s[i] += d * d; prev = lp[i] }
    s[5] += prev * prev
    if (++n == 400) { printf "%.4f %.4f %.4f %.4f %.4f\n", sqrt(s[1]/n), sqrt(s[2]/n), sqrt(s[3]/n), sqrt(s[4]/n), sqrt(s[5]/n); for (i = 1; i <= 5; i++) s[i] = 0; n = 0; fflush() }
}
