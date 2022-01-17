!Module for parameters. For this particular program only two parameters are required, but a separate module is created for
!clarity and possible future additions.

module param_mod
      integer,parameter::rk=selected_real_kind(24,1000)
      real(rk),parameter::G=6.674E-11
end module param_mod
