function sqnr = SQNR(xd, x)
    err = x - xd; %error = sample - quantize
    sqnr = 10 * log10(var(xd)/var(err));
end