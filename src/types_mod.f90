!This module contains two types that are required for the simulation:
!Vectors for calculating and storing objects' positions, velocities and accelerations
!Objects (planets, stars, moons etc.), that are made up of mass and forementioned vectors. Objects are essentially used for
!storing values.

module types_mod
      use param_mod
      !Creation of types
      type:: vector
              real(rk)::x,y,z
      end type vector
      type:: object
              character(len=50)::description
              real(rk)::mass
              type(vector)::pos
              type(vector)::vel
              type(vector)::acc
       end type object

       !Operators and routine assignment for vector calculations
       interface operator(+)
               module procedure vadd
       end interface operator(+)
       interface operator(-)
               module procedure vsub
       end interface operator(-)
       interface operator(*)
               module procedure vmul
       end interface operator(*)
       interface operator(/)
               module procedure vdiv
       end interface operator(/)
contains
       !Simple vector subroutines and also a subroutine for calculating the length of a vector
       
       !Addition
       type(vector) function vadd(v,u)
               implicit none
               type(vector),intent(in)::v,u
               vadd%x=v%x+u%x
               vadd%y=v%y+u%y
               vadd%z=v%z+u%z
       end function vadd

       !Subtraction
       type(vector) function vsub(v,u)
               implicit none
               type(vector),intent(in)::v,u
               vsub%x=v%x-u%x
               vsub%y=v%y-u%y
               vsub%z=v%z-u%z
       end function vsub

       !Multiplication
       type(vector) function vmul(v,k)
               implicit none
               real(rk),intent(in)::k
               type(vector),intent(in)::v
               vmul%x=k*v%x
               vmul%y=k*v%y
               vmul%z=k*v%z
       end function

       !Division
       type(vector) function vdiv(v,k)
               implicit none
               real(rk),intent(in)::k
               type(vector),intent(in)::v
               vdiv%x=v%x/k
               vdiv%y=v%y/k
               vdiv%z=v%z/k
       end function

       !Vector length
       real(rk) function vectorlen(v)
               implicit none
               type(vector),intent(in)::v
               vectorlen=sqrt((v%x)**2+(v%y)**2+(v%z)**2)
       end function vectorlen
end module types_mod

