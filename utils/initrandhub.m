function [ EI, U ] = initrandhub (dim, cplx, isym)
	 
	 ## usage: EI U = initrandhub (dim, cplx, isym)
	 ## 
	 ## 
	 ## isym = 1 Mulliken
	 ##        2 Dirak
	 ##
	 ## Initialize a random 4-index tensor EI of dimension 
         ## dim x dim x dim x dim and rank dim 

 EI_on_site = zeros(dim,dim,dim,dim);

 for j =  1 : dim
     EI_on_site(j,j,j,j) = j;
 end

 U = rand(dim);
 if (cplx == 1)
   U += i*rand(dim);
 end
 
 U = orth(U);
     
 EI = t2e(EI_on_site, U, isym);

endfunction
