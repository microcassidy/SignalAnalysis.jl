export cw, chirp
export hanning, hamming, tukey, cosine, lanczos, triang, bartlett, gaussian, bartlett_hann, blackman, kaiser, dpss

"Generate a sinusoidal signal."
function cw(freq, duration; fs=deffs, phase=0.0, window=nothing, analytic=true)
    t = 0:1/freqQ(fs):timeQ(duration)
    x = exp.(2im*π*freqQ(freq).*t .+ phase)
    if window != nothing
        x .*= getwindow(window, length(t))
    end
    analytic ? x : real(x)
end

"Generate a frequency modulated chirp signal."
function chirp(freq1, freq2, duration; fs=deffs, shape=:linear, phase=0.0, window=nothing, analytic=true)
    f1 = freqQ(freq1)
    f2 = freqQ(freq2)
    T = timeQ(duration)
    t = 0:1/freqQ(fs):T
    if shape == :linear
        cby2 = (f2-f1)/T/2.0
        x = exp.(2im*π .* (cby2.*t.^2 .+ f1.*t) .+ phase)
    elseif shape == :hyperbolic
        s = f2*T/(f2-f1)
        x = exp.(-2im*π*s*f1 .* log.(abs.(1.0 .- t./s)))
    else
        @assert false "Unknown chirp shape"
    end
    if window != nothing
        x .*= getwindow(window, length(t))
    end
    analytic ? x : real(x)
end

### utility functions

function getwindow(window, n)
    window == nothing && return ones(n)
    window isa Tuple && return window[1](n, window[2])
    window(n)
end
