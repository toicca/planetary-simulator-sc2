!Module used for reading and writing values to the input and output files respectively. Also contains a function for clearing
!previous results.

!Note: This module contains the variables for all the objects in the system (system) and also all the instructions for running the
!simulation (instr).

!Instr contains simulation instructions in the same order as they are in the input file.
module file_mod
      use types_mod
      real(rk)::instr(5)
      type(object),allocatable,target::system(:)
      character(len=30),allocatable::obj_name(:)
      integer::ios

contains
      !Subroutine for reading input file.
      subroutine read_input()
              implicit none
              integer::i, N
              real(rk):: mass,x,y,z,vx,vy,vz
              character(len=30)::desc
              type(object)::obj
              real(rk)::val
              instr=0

              !Opening file
              open(unit=1,file="../run/input.dat",status="old")
              if(ios/=0) then
                      print '(a)',"Error opening input file"
                      stop
              end if

              !Systems object count
              read(1,*,iostat=ios) N
              allocate(system(N),obj_name(N))
          
              !System values 
              do i=1, N
                read(1,*,iostat=ios) desc,mass,x,y,z,vx,vy,vz
                if(ios/=0) then
                        print '(a)',"Error reading object values"
                        stop
                end if
                desc=trim(desc)

                !Add the object to the system
                system(i)=object(desc,mass,vector(x,y,z),vector(vx,vy,vz),vector(0,0,0)) 
              end do

              !Instruction values
              do i=1,3
                read(1,*,iostat=ios) instr(i)
                if(ios<0) exit
              end do

              !Since days are easier to understand than possibly millions of seconds, length is given in days
              !Length from days to seconds:
              instr(2)=instr(2)*24*60*60

              !Fill possible empty values
              if(instr(1)==0) then
                      instr(1)=instr(2)/instr(3)
              else if(instr(2)==0) then
                      instr(2)=instr(1)*instr(3)

              !Instead of using the given number of steps, we calculate it ourselves
              !to reduce possible mistakes
              else
                      instr(3)=instr(2)/instr(1)
              end if
              
              !Lastly we read m and k
              !m=>interval of info in main
              !k=>interval of writing data to file
              read(1,*,iostat=ios) instr(4)
              read(1,*,iostat=ios) instr(5)

              !Check for invalid inputs
              if (any(instr<0)) then
                      print '(a)', "Simulation instructions shouldn't contain negative values"
                      stop
              end if
              close(1)
      end subroutine read_input
      
      !Subroutine for adding data to the output file
      subroutine write_data(time)
              implicit none
              integer::posi,i
              real(rk),intent(in)::time
              type(object),pointer::p

              !Opening and writing. Pointer isn't really required, but it's used to reduce text in the writing part.
              open(unit=1,file="../run/output.dat",iostat=ios,status="old",position="append")
              do i=1,size(system)
                p=>system(i)
                write(1,"(a,a,es14.4,a,es14.4,a,es14.4,a,f20.0)") trim(p%description),",",p%pos%x,",",p%pos%y,",",p%pos%z,",",time
              end do
              close(1)
      end subroutine write_data
      
      !Subroutine for clearing previous output
      subroutine clear_output()
              implicit none
              integer::i

              !Delete old output
              open(unit=1,file="../run/output.dat",iostat=ios,status="replace")
              if (ios==0) close(1, status="delete")

              !Create and initiliaze new output
              open(unit=1,file="../run/output.dat",iostat=ios,status="new")
              write(1,"(a)") "Object,X,Y,Z,Time"
              close(1)
      end subroutine clear_output
end module file_mod
