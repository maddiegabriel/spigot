! *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
! file:   spigot.f95
! goal:   allows user to enter an output file name, then calculates pi
!         using the spigot algorithm and outputs the result to the file.
! *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

program main
    implicit none
    print *, ''
    print *, ' ------------------------------------'
    print *, '    WELCOME TO MY SPIGOT ALGORITHM!'
    print *, '          (fortran edition)'
    print *, '    Built with love for CIS*3190'
    print *, '    By: Maddie Gabriel (0927580)'
    print *, ' ------------------------------------'
    print *, ''
    
    ! call function to calculate pi
    call spigot()
end program main

! **************************************************************
! subroutine: spigot
! goal:       calculate pi and write result to user defined file
! **************************************************************
subroutine spigot ()
    implicit none

    ! declare and initialize variables
    integer :: i = 0, j = 0, k = 0, q = 0, x = 0
    integer :: nines = 0, predigit = 0, precis = 1000, length = 0
    integer :: arr(0:3333)
    character (len = 200) :: filename
    
    ! get user defined output file name
    print *, ' Enter output filename (with extension): '
    read *, filename
    open(1, file = filename)  

    print *, ''
    print *, ' ** Please wait while your result is calculating **'

    ! calculate array length and create array
    length = (10 * precis / 3) + 1
    
    ! initialize array to all 2's
    do i = 0,length
        arr(i) = 2
    end do
    
    ! repeat calculation loop 'precis' times - depends on desired precision
    do j = 0, precis
        q = 0

        ! calculate q
        do i = length,1,-1
           x = 10 * arr(i-1) + q*i
           arr(i-1) = modulo(x, 2*i-1)
           q = x / (2*i-1)
        end do

        arr(0) = modulo(q, 10)
        q = q / 10

        ! append different digits based on q value
        if (q == 9) then
            ! if q is 9, increment nines counter
            nines = nines + 1
        else if (q == 10) then
            ! if q is 10 (overflow case), write 9 then predigit + 1
            write(1,'(i0)', advance = 'no') predigit+1
        
            do k = 0,nines-1
                write(1,'(i0)', advance = 'no') 0
            end do

            predigit = 0
            nines = 0
        else
            ! if q is not 9 or 10, print predigit
            write(1,'(i0)', advance = 'no') predigit

            ! advance predigit to next q
            predigit = q

            ! handle nines which were tracked
            if (nines /= 0) then
                do k = 0, nines-1
                    write(1,'(i0)', advance = 'no') 9
                end do
                nines = 0
            end if
        end if
    end do
    
    ! add the final digit
    write(1,'(i0)', advance = 'no') predigit
    write(1,'(i0)', advance = 'no') 9
    
    ! close the file and tell user where to find their result
    close(1)
    print *, ''
    print *, ' Done! Please see your result in the file: ', filename

end subroutine
