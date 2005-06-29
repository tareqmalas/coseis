!------------------------------------------------------------------------------!
! DFCN - difference operator, cell to node

subroutine dfcn( op, df, f, x, h, i, a, i1, i2 )
implicit none
character op
real df(:,:,:,:), f(:,:,:,:), x(:,:,:,:), h
integer i, j, k, l, a, b, c, i1(3), i2(3)

selectcase(op)

! constant grid, flops: 1* 7+
case('h')
h = 0.25 * h * h
selectcase(a)
case(1)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = h * &
  ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
  - f(j-1,k,l,i) + f(j,k-1,l-1,i) &
  + f(j,k-1,l,i) - f(j-1,k,l-1,i) &
  + f(j,k,l-1,i) - f(j-1,k-1,l,i) )
case(2)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = h * &
  ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
  + f(j-1,k,l,i) - f(j,k-1,l-1,i) &
  - f(j,k-1,l,i) + f(j-1,k,l-1,i) &
  + f(j,k,l-1,i) - f(j-1,k-1,l,i) )
case(3)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = h * &
  ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
  + f(j-1,k,l,i) - f(j,k-1,l-1,i) &
  + f(j,k-1,l,i) - f(j-1,k,l-1,i) &
  - f(j,k,l-1,i) + f(j-1,k-1,l,i) )
end select

! rectangular grid, flops: 7* 11+
case('r')
selectcase(a)
case(1)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = 0.25 * &
  ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * &
  ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * ( f(j,k,l,i) - f(j-1,k,l,i) ) + &
    ( x(j,k,l,2) - x(j,k-1,l,2) ) * ( f(j,k-1,l,i) - f(j-1,k-1,l,i) ) ) &
  + ( x(j,k,l,3) - x(j,k,l-1,3) ) * &
  ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * ( f(j,k,l-1,i) - f(j-1,k,l-1,i) ) + &
    ( x(j,k,l,2) - x(j,k-1,l,2) ) * ( f(j,k-1,l-1,i) - f(j-1,k-1,l-1,i) ) ) )
case(2)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = 0.25 * &
  ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * &
  ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * ( f(j,k,l,i) - f(j,k-1,l,i) ) + &
    ( x(j,k,l,3) - x(j,k,l-1,3) ) * ( f(j,k,l-1,i) - f(j,k-1,l-1,i) ) ) &
  + ( x(j,k,l,1) - x(j-1,k,l,1) ) * &
  ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * ( f(j-1,k,l,i) - f(j-1,k-1,l,i) ) + &
    ( x(j,k,l,3) - x(j,k,l-1,3) ) * ( f(j-1,k,l-1,i) - f(j-1,k-1,l-1,i) ) ) )
case(3)
  forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = 0.25 * &
  ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * &
  ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * ( f(j,k,l,i) - f(j,k,l-1,i) ) + &
    ( x(j,k,l,1) - x(j-1,k,l,1) ) * ( f(j-1,k,l,i) - f(j-1,k,l-1,i) ) ) &
  + ( x(j,k,l,2) - x(j,k-1,l,2) ) * &
  ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * ( f(j,k-1,l,i) - f(j,k-1,l-1,i) ) + &
    ( x(j,k,l,1) - x(j-1,k,l,1) ) * ( f(j-1,k-1,l,i) - f(j-1,k-1,l-1,i) ) ) )
end select

! general grid, flops: 55* 90+
case('g')
b = mod( a, 3 ) + 1
c = mod( a + 1, 3 ) + 1
forall( j=i1(1):i2(1), k=i1(2):i2(2), l=i1(3):i2(3) ) df(j,k,l) = 1 / 12 * &
(x(j+1,k,l,c)*((x(j,k+1,l,b)+x(j+1,k+1,l,b))*(f(j,k,l-1,i)-f(j,k,l,i)) &
              +(x(j,k-1,l,b)+x(j+1,k-1,l,b))*(f(j,k-1,l,i)-f(j,k-1,l-1,i)) &
              +(x(j,k,l+1,b)+x(j+1,k,l+1,b))*(f(j,k,l,i)-f(j,k-1,l,i)) &
              +(x(j,k,l-1,b)+x(j+1,k,l-1,b))*(f(j,k-1,l-1,i)-f(j,k,l-1,i))) &
+x(j-1,k,l,c)*((x(j,k+1,l,b)+x(j-1,k+1,l,b))*(f(j-1,k,l,i)-f(j-1,k,l-1,i)) &
              +(x(j,k-1,l,b)+x(j-1,k-1,l,b))*(f(j-1,k-1,l-1,i)-f(j-1,k-1,l,i)) &
              +(x(j,k,l+1,b)+x(j-1,k,l+1,b))*(f(j-1,k-1,l,i)-f(j-1,k,l,i)) &
              +(x(j,k,l-1,b)+x(j-1,k,l-1,b))*(f(j-1,k,l-1,i)-f(j-1,k-1,l-1,i))) &
+x(j,k+1,l,c)*((x(j+1,k,l,b)+x(j+1,k+1,l,b))*(f(j,k,l,i)-f(j,k,l-1,i)) &
              +(x(j-1,k,l,b)+x(j-1,k+1,l,b))*(f(j-1,k,l-1,i)-f(j-1,k,l,i)) &
              +(x(j,k,l+1,b)+x(j,k+1,l+1,b))*(f(j-1,k,l,i)-f(j,k,l,i)) &
              +(x(j,k,l-1,b)+x(j,k+1,l-1,b))*(f(j,k,l-1,i)-f(j-1,k,l-1,i))) &
+x(j,k-1,l,c)*((x(j+1,k,l,b)+x(j+1,k-1,l,b))*(f(j,k-1,l-1,i)-f(j,k-1,l,i)) &
              +(x(j-1,k,l,b)+x(j-1,k-1,l,b))*(f(j-1,k-1,l,i)-f(j-1,k-1,l-1,i)) &
              +(x(j,k,l+1,b)+x(j,k-1,l+1,b))*(f(j,k-1,l,i)-f(j-1,k-1,l,i)) &
              +(x(j,k,l-1,b)+x(j,k-1,l-1,b))*(f(j-1,k-1,l-1,i)-f(j,k-1,l-1,i))) &
+x(j,k,l+1,c)*((x(j+1,k,l,b)+x(j+1,k,l+1,b))*(f(j,k-1,l,i)-f(j,k,l,i)) &
              +(x(j-1,k,l,b)+x(j-1,k,l+1,b))*(f(j-1,k,l,i)-f(j-1,k-1,l,i)) &
              +(x(j,k+1,l,b)+x(j,k+1,l+1,b))*(f(j,k,l,i)-f(j-1,k,l,i)) &
              +(x(j,k-1,l,b)+x(j,k-1,l+1,b))*(f(j-1,k-1,l,i)-f(j,k-1,l,i))) &
+x(j,k,l-1,c)*((x(j+1,k,l,b)+x(j+1,k,l-1,b))*(f(j,k,l-1,i)-f(j,k-1,l-1,i)) &
              +(x(j-1,k,l,b)+x(j-1,k,l-1,b))*(f(j-1,k-1,l-1,i)-f(j-1,k,l-1,i)) &
              +(x(j,k+1,l,b)+x(j,k+1,l-1,b))*(f(j-1,k,l-1,i)-f(j,k,l-1,i)) &
              +(x(j,k-1,l,b)+x(j,k-1,l-1,b))*(f(j,k-1,l-1,i)-f(j-1,k-1,l-1,i))) &
 +x(j,k+1,l+1,c)*(x(j,k+1,l,b)-x(j,k,l+1,b))*(f(j,k,l,i)-f(j-1,k,l,i)) &
 +x(j,k-1,l-1,c)*(x(j,k-1,l,b)-x(j,k,l-1,b))*(f(j,k-1,l-1,i)-f(j-1,k-1,l-1,i)) &
 +x(j+1,k,l+1,c)*(x(j+1,k,l,b)-x(j,k,l+1,b))*(f(j,k-1,l,i)-f(j,k,l,i)) &
 +x(j-1,k,l-1,c)*(x(j-1,k,l,b)-x(j,k,l-1,b))*(f(j-1,k-1,l-1,i)-f(j-1,k,l-1,i)) &
 +x(j+1,k+1,l,c)*(x(j+1,k,l,b)-x(j,k+1,l,b))*(f(j,k,l,i)-f(j,k,l-1,i)) &
 +x(j-1,k-1,l,c)*(x(j-1,k,l,b)-x(j,k-1,l,b))*(f(j-1,k-1,l,i)-f(j-1,k-1,l-1,i)) &
 +x(j+1,k,l-1,c)*(x(j+1,k,l,b)-x(j,k,l-1,b))*(f(j,k,l-1,i)-f(j,k-1,l-1,i)) &
 +x(j-1,k,l+1,c)*(x(j-1,k,l,b)-x(j,k,l+1,b))*(f(j-1,k,l,i)-f(j-1,k-1,l,i)) &
 +x(j-1,k+1,l,c)*(x(j-1,k,l,b)-x(j,k+1,l,b))*(f(j-1,k,l-1,i)-f(j-1,k,l,i)) &
 +x(j+1,k-1,l,c)*(x(j+1,k,l,b)-x(j,k-1,l,b))*(f(j,k-1,l-1,i)-f(j,k-1,l,i)) &
 +x(j,k-1,l+1,c)*(x(j,k-1,l,b)-x(j,k,l+1,b))*(f(j-1,k-1,l,i)-f(j,k-1,l,i)) &
 +x(j,k+1,l-1,c)*(x(j,k+1,l,b)-x(j,k,l-1,b))*(f(j-1,k,l-1,i)-f(j,k,l-1,i)))

end select
return
end

