!Main part of the program. Contains: loop for simulation and two subroutines for printing information during simulation.

program project5_main
      use dynamics_mod
      integer::i
      real(rk)::sim_time

      !Initialization of simulation information and files
      call read_input()
      call clear_output()

      !Starting information, sim_time is used to keep track of time.
      print "(a)","Initial positions:"
      call pos_info()
      sim_time=0.0

      !Simulation loop
      do i=1, int(instr(3))
        call update_sys()
        sim_time=sim_time+instr(1)

        !Check for info or write
        if(mod(i,int(instr(5)))==0) then
                call write_data(sim_time)
        end if
        if(mod(i,int(instr(4)))==0) then
                call info(i)
        end if
      end do
      print "(a)", "-----"
      
      !Final information
      print "(a)","Final positions:"
      call pos_info()
      
contains
        !Subroutine for printing the required information
        subroutine info(step)
                implicit none
                integer,intent(in)::step
                integer::j
                print "(a)", "-----"
                print "(a,i0)", "Number of objects: ",size(system)
                print "(a,f7.1,a)", "Time from the beginning of simulation: ",step*instr(1)/60/60/24," days"
                print "(a,i0)", "Number of steps from the beginning of simulation: ", step
                print "(a,i0)", "Number of steps written to file: ", int(step/instr(5))
                print "(a)", "Positions of objects (meters from origin):"
                call pos_info()
         end subroutine info

         !Subroutine for getting the positions of the objects
         subroutine pos_info()
                 implicit none
                 integer::k
                 do k=1, size(system)
                        print "(a,3ES18.5)", trim(system(k)%description), system(k)%pos
                end do
         end subroutine pos_info
end program


