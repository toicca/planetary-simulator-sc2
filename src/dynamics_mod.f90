!Module for calculating the acceleration and the Velocity Verlet for objects. See Theory section of the report for details about the
!calculations.

module dynamics_mod
        use file_mod
contains
        !Acceleration calculation subroutine. Calculates acceleration according to Theory in report. Takes object as argument and
        !returns objects acceleration.
        type(vector) function get_acc(obj)
                implicit none
                integer::i
                type(vector)::r,F
                type(object),target,intent(inout)::obj
                F=vector(0,0,0)

                !Go through and sum all the gravitational forces effecting the given object
                do i=1, size(system)
                       !If-condition to avoid calculating gravity caused by the given object (division by zero)
                       if(obj%description.ne.system(i)%description) then
                               r=system(i)%pos-obj%pos
                               F=F+r*(G*obj%mass*system(i)%mass/vectorlen(r)**3)
                       end if
                end do

                !Acceration
                get_acc=F/obj%mass
        end function get_acc
        !Subroutine for the Velocity Verlet
        subroutine update_sys()
                !Variables _temp are used to calculate and store temporary values.
                implicit none
                integer::i
                type(vector)::pos_temp,vel_temp,acc_temp
                real(rk)::dt

                !Time step from input instructions
                dt=instr(1)

                !Go through all the objects in the system and calculate the VV for them.
                do i=1, size(system)
                        pos_temp=system(i)%pos+system(i)%vel*dt+system(i)%acc*(dt*dt*0.5)
                        acc_temp=get_acc(system(i))
                        vel_temp=system(i)%vel+(system(i)%acc+acc_temp)*(dt*0.5)
                        system(i)%pos=pos_temp
                        system(i)%vel=vel_temp
                        system(i)%acc=acc_temp
                end do
        end subroutine update_sys
end module
