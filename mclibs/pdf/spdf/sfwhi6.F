*
* $Id: sfwhi6.F,v 1.1.1.2 1996/10/30 08:30:46 cernlib Exp $
*
* $Log: sfwhi6.F,v $
* Revision 1.1.1.2  1996/10/30 08:30:46  cernlib
* Version 7.04
*
* Revision 1.1.1.1  1996/04/12 15:29:46  plothow
* Version 7.01
*
*
#include "pdf/pilot.h"
c-------------------------------------------------------
      subroutine SFWHI6(ZX,ZQ,ZUV,ZDV,ZUB,ZDB,ZSB,ZCB,ZGL)
c-------------------------------------------------------
c     WHIT6 parton distribution in the photon
c
c     INPUT:  integer ic  : if ic=0 then qc=0
c                           else qc is calculated
c             DOUBLE PRECISION  Q2  : energy scale Q^2 (GeV^2)
c             DOUBLE PRECISION  x   : energy fraction
c
c     OUTPUT: DOUBLE PRECISION  qu  : up-quark dist.
c             DOUBLE PRECISION  qd  : down- or strange-quark dist.
c             DOUBLE PRECISION  qc  : charm-quark dist.
c             DOUBLE PRECISION  g   : gluon dist.
c-------------------------------------------------------
c     Modified by M.Tanaka on July 22, 1994.
c     The bug pointed out by M.Drees is fixed.
c-------------------------------------------------------
c     Modified by I.Watanabe on July 22, 1994.
c-------------------------------------------------------
      implicit none
      external WHIT6G
#include "pdf/expdp.inc"
     +       ZX,ZQ,ZUV,ZDV,ZUB,ZDB,ZSB,ZCB,ZGL
c arg
      integer ic
      DOUBLE PRECISION Q2,x
      DOUBLE PRECISION qu,qd,qc,g
c const
      DOUBLE PRECISION q42it,q52it,lam42,lam52
      DOUBLE PRECISION alinv,mc,PI
c local
      DOUBLE PRECISION qv,qsea,cv,cs,dcv,dcs
      DOUBLE PRECISION A0val,A1val,A2val,Bval,Cval,
     $       A0sea,B0sea,BB0sea,C0sea
      DOUBLE PRECISION A0dcv,A1dcv,A2dcv,A3dcv,Bdcv,Cdcv
      DOUBLE PRECISION Adcs, B0dcs, B1dcs, Cdcs
      DOUBLE PRECISION x1,x2,mc2q2
      DOUBLE PRECISION s,s2,s3,s4,prsccf,alstpi
      DOUBLE PRECISION WHIT6G
c parameters
      parameter(lam42=0.16d0, lam52=0.091411319d0)
      parameter(Q42IT=4.0d0, Q52IT=100.0d0)
      parameter(alinv=137.036d0, mc=1.5d0)
      parameter(pi=3.14159265358979323846d0)
      common /scale/ s,s2,s3,s4,prsccf
c
c begin
      x=ZX
      Q2=ZQ*ZQ
      ic=1
c
      x1=1.0d0-x
      x2=x**2
      mc2q2=mc**2/Q2
c
      if(Q2.lt.100.0d0) then
c  under 100 GeV^2
c
c  set  scale s
         if(Q2.lt.4.0d0) then
cccc  for under 4GeV^2 prescription
            s=  0.0d0
            prsccf =  log(Q2/LAM42)/ log(Q42IT/LAM42)
            alstpi = 6.0d0/25.0d0/ log(Q42IT/LAM42)
         else
            s=   log(  log(Q2/LAM42)/ log(Q42IT/LAM42))
            prsccf = 1.0d0
            alstpi = 6.0d0/25.0d0/ log(Q2/LAM42)
         endif
            s2=s**2
            s3=s2*s
            s4=s2**2
c
cccccc   WHIT6 quark (U100)
c
      A0val= 2.540000d+00+s*( 2.000000d+00)+s2*( 7.180000d-01)
      A1val= 6.230000d-02+s*(-7.010000d+00)+s2*( 1.251000d-01)
      A2val=-1.642000d-01+s*(-4.360000d-01)+s2*( 1.048000d+01)
     $           +s3*(-5.200000d+00)
      Bval = 6.990000d-01+s*(-2.796000d-02)+s2*(-3.650000d-03)
      Cval = 4.420000d-01+s*(-1.255000d+00)+s2*( 1.941000d+00)
     $           +s3*(-9.950000d-01)
      A0sea= 3.180000d+00+s*( 8.690000d+00)+s2*(-2.287000d+01)
     $           +s3*( 1.896000d+01)+s4*(-5.140000d+00)
      B0sea=-1.003000d-01+s*( 1.603000d-01)+s2*(-1.037000d+00)
     $           +s3*( 9.440000d-01)+s4*(-2.915000d-01)
      BB0sea=5.690000d+00+s*( 1.867000d+01)+s2*(-4.670000d+01)
     $           +s3*( 5.050000d+01)+s4*(-1.835000d+01)
      C0sea= 2.149000d+01+s*(-5.650000d+01)+s2*( 1.293000d+02)
     $           +s3*(-1.459000d+02)+s4*( 5.750000d+01)
c
         qv  = prsccf/alinv/x*
     $         (A0val+A1val*x+A2val*x2) * x**Bval * x1**Cval
         qsea= prsccf/alinv/x*
     $         A0sea * x**(B0sea+BB0sea*x) * x1**C0sea
c
         qu  = qv/3.0d0  + qsea/6.0d0
         qu  = qu*x
         ZUV=qu
         ZUB=qu
         qd  = qv/12.0d0 + qsea/6.0d0
         qd  = qd*x
         ZDV=qd
         ZDB=qd
         ZSB=qd
c
         if((ic.ne.0) .and. (x*(1.0d0+4.0d0*mc2q2).lt.1.0d0)) then
            call WHIT6Q(x,mc2q2,cv,cs)
            qc = cv/alinv/2.0d0/PI + cs*alstpi
            qc  = qc*x
            ZCB=qc
         else
            qc = 0.0d0
            ZCB=qc
         endif
c
         g   = WHIT6G(x,Q2)
         g   = g*x
         ZGL=g
c
      else
c over 100 GeV^2
c
c set scale s
         s=   log(  log(Q2/LAM52)/ log(Q52IT/LAM52))
         prsccf = 1.0d0
         alstpi = 6.0d0/23.0d0/ log(Q2/LAM52)
            s2=s**2
            s3=s2*s
            s4=s2**2
c
cccccc   WHIT6 quark (O100)
c
      A0val= 4.270000d+00+s*( 3.096000d+00)+s2*( 1.621000d+00)
      A1val=-4.740000d+00+s*(-6.900000d+00)+s2*(-2.439000d+00)
      A2val= 2.837000d+00+s*( 6.460000d+00)+s2*( 4.100000d+00)
      Bval = 6.780000d-01+s*(-3.940000d-02)+s2*( 1.758000d-02)
      Cval = 1.728000d-01+s*(-2.493000d-02)+s2*( 1.451000d-01)
      A0sea= 3.340000d+00+s*(-5.610000d+00)+s2*( 5.000000d+01)
     $           +s3*(-2.207000d+02)+s4*( 3.028000d+02)
      B0sea=-2.402000d-01+s*(-4.090000d-01)+s2*( 2.263000d+00)
     $           +s3*(-1.050000d+01)+s4*( 1.487000d+01)
      BB0sea=8.790000d+00+s*(-8.860000d+00)+s2*( 1.640000d+02)
     $           +s3*(-7.120000d+02)+s4*( 9.730000d+02)
      C0sea= 9.160000d+00+s*( 9.290000d+00)+s2*(-2.784000d+02)
     $           +s3*( 1.175000d+03)+s4*(-1.592000d+03)
c
         qv  = 1.0d0/alinv/x*
     $         (A0val+A1val*x+A2val*x2) * x**Bval * x1**Cval
         qsea= 1.0d0/alinv/x*
     $         A0sea * x**(B0sea+BB0sea*x) * x1**C0sea
c
         qu  = qv/3.0d0  + qsea/6.0d0
         qu  = qu*x
         ZUV=qu
         ZUB=qu
         qd  = qv/12.0d0 + qsea/6.0d0
         qd  = qd*x
         ZDV=qd
         ZDB=qd
         ZSB=qd
         g   = WHIT6G(x,Q2)
         g   = g*x
         ZGL=g
c
         if((ic.ne.0) .and. (x*(1.0d0+4.0d0*mc2q2).lt.1.0d0)) then
      A0dcv=              s*( 1.219000d-01)+s2*( 6.200000d+00)
     $           +s3*(-2.504000d+01)+s4*( 3.098000d+01)
      A1dcv=              s*( 1.913000d+00)+s2*(-7.690000d+01)
     $           +s3*( 3.180000d+02)+s4*(-3.920000d+02)
      A2dcv=              s*(-7.160000d+00)+s2*( 2.503000d+02)
     $           +s3*(-1.062000d+03)+s4*( 1.308000d+03)
      A3dcv=              s*( 3.190000d+00)+s2*(-2.301000d+02)
     $           +s3*( 1.012000d+03)+s4*(-1.250000d+03)
      Bdcv = 4.990000d-01+s*( 3.470000d+00)+s2*(-1.526000d+01)
     $           +s3*( 1.967000d+01)
      Cdcv = 3.290000d-01+s*( 8.240000d+00)+s2*(-3.800000d+01)
     $           +s3*( 4.630000d+01)
      Adcs =              s*(-4.990000d-02)+s2*( 1.026000d-01)
     $           +s3*(-7.870000d-02)
      B0dcs=-3.610000d-01+s*(-5.760000d-01)+s2*( 2.257000d-01)
      B1dcs= 7.680000d+00+s*(-8.830000d+00)+s2*( 3.880000d+00)
      Cdcs = 2.548000d+00+s*( 6.910000d-01)+s2*(-8.700000d+00)
     $           +s3*( 1.065000d+01)
c
         dcv = 1.0d0/alinv/x*
     $         (A0dcv+x*A1dcv+x2*A2dcv+x2*x*A3dcv) * x**Bdcv * x1**Cdcv
         dcs = 1.0d0/alinv/x*
     $         Adcs * x**(B0dcs+B1dcs*x) * x1**Cdcs
c
           call WHIT6Q(x,mc*mc/Q2,cv,cs)
           qc = cv/alinv/2.0d0/PI + cs*alstpi + dcs + dcv
           qc  = qc*x
           ZCB=qc
         else
           qc = 0.0d0
           ZCB=qc
         endif
      endif
c
      return
      end
