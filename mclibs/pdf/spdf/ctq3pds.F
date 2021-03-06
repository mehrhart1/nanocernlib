*
* $Id: ctq3pds.F,v 1.1.1.2 1996/10/30 08:27:50 cernlib Exp $
*
* $Log: ctq3pds.F,v $
* Revision 1.1.1.2  1996/10/30 08:27:50  cernlib
* Version 7.04
*
* Revision 1.1.1.1  1996/04/12 15:29:10  plothow
* Version 7.01
*
*
#include "pdf/pilot.h"
C
C
      SUBROUTINE Ctq3Pds(Iset, Pdf, X, Q, Irt)

C   This function returns the CTEQ parton distributions xf^Iset_Iprtn/proton
C   --- the Momentum density in array form
c
C    (Iset, X, Q): explained in header comment lines;

C     Irt : return error code -- cumulated over flavors:
C           see module Ctq3Pd for explanation on individual flavors.
C     Pdf (Iparton);
C         Iparton = -6, -5, ...0, 1, 2 ... 6
C               has the same meaning as explained in the header comment lines.

C     Implicit Double Precision (A-H, O-Z)
C+SEQ, IMPDP.
      Dimension Pdf (-6:6)

      Irt=0
      do 10 I=-6,2
         if(I.le.0) then
            Pdf(I) = Ctq3Pd(Iset,I,X,Q,Irt1)
            Pdf(-I)= Pdf(I)
         else
            Pdf(I) = Ctq3Pd(Iset,I,X,Q,Irt1) + Pdf(-I)
         endif
         Irt=Irt+Irt1
  10  Continue

      Return
C                         *************************
      End
