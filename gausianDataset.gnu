# set terminal png transparent truecolor nocrop enhanced size 512,280 font "arial,8" 
# set output 'transparent.2.png'
set clip two
set style fill  transparent solid 0.50 noborder
set key title "Gaussian Distribution"
set key inside left top vertical Left reverse enhanced autotitle nobox
set key noinvert samplen 1 spacing 1 width 0 height 0 
set style data lines
set style function filledcurves y1=0
set title "Transparent filled curves" 
set xrange [ -90.00000 : -30.00000 ] noreverse nowriteback
set yrange [ 0.00000 : 0.3 ] noreverse nowriteback
unset colorbox
Gauss(x,mu,sigma) = 1./(sigma*sqrt(2*pi)) * exp( -(x-mu)**2 / (2*sigma**2) )
d1(x) = Gauss(x, -65.5, 6.132789831)
d2(x) = Gauss(x, -74.6363636364, 2.1213203436 )
#d3(x) = Gauss(x, -1.,  2.)
save_encoding = "utf8"
GPFUN_Gauss = "Gauss(x,mu,sigma) = 1./(sigma*sqrt(2*pi)) * exp( -(x-mu)**2 / (2*sigma**2) )"
GPFUN_d1 = "d1(x) = Gauss(x, -65.5, 6.132789831)"
GPFUN_d2 = "d2(x) = Gauss(x, -74.6363636364, 2.1213203436 )"
#GPFUN_d3 = "d3(x) = Gauss(x, -1.,  2.)"
plot d1(x) fs solid 1.0 lc rgb "forest-green" title "μ =  -65.5 σ = 6.132789831",      d2(x) lc rgb "gold" title "μ =  -74.6363636364 σ = 2.1213203436 "
#plot d1(x) fs solid 1.0 lc rgb "forest-green" title "μ =  -65.5 σ = 6.132789831",      d2(x) lc rgb "gold" title "μ =  -74.6363636364 σ = 2.1213203436 ",      d3(x) lc rgb "dark-violet" title "μ = -1.0 σ = 2.0"
