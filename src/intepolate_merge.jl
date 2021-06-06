struct interpolated{T,V,F1,F2}
    channel::T
    cutoff::F1
    cutoffratio::F2
    itr::V
end
function interpolated(channel::AbstractxDD, cutoff::Real; estep=0.05)
    eth = m2e(sum(channel.ms))
    ev = eth:estep:(cutoff+2*estep)
    calv = ρ_thr.(Ref(channel),ev)
    itr = interpolate((ev,), real.(calv), Gridded(Linear()))
    cutoffratio = real(ρ_thr(channel,cutoff))/ρ_tb(channel,cutoff)
    interpolated(channel,cutoff,cutoffratio,itr)
end
function ρ_thr(d::interpolated, e::Real)
e < d.cutoff ?
    d.itr(e) :
    ρ_tb( d.channel, e) * d.cutoffratio
end
ρ_thr(d::interpolated, e::Complex) = ρ_thr(d.channel,e)
